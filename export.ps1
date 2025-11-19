#Requires -Version 5.1

<#
.SYNOPSIS
    Extracts, processes, and standardizes messages from TwinCAT PLC (.TcPOU) files.

.DESCRIPTION
    This script scans a Git repository for *.TcPOU files to find structured log messages
    (e.g., M_Info(...), M_Warning(...)). It performs the following actions:
    1. Calculates a unique, reproducible hash-based ID for each message if one is not present.
    2. Updates source files with the calculated ID.
    3. **NEW:** If an ID collision is detected (same ID for different text), it automatically generates a new unique ID and updates the source file.
    4. Generates a 'messages.json' file, MERGING new messages with existing translations.
    5. Reports any new messages found during the run.
    6. Generates an 'EventClass.xml' file for TwinCAT Event Manager integration.
    7. Includes robust error handling, logging, and output validation.

.PARAMETER Languages
    An array of language codes (e.g., "en", "de") to include in the output 'messages.json'.
    Defaults to "en".

.EXAMPLE
    .\Extract-Messages.ps1
    Runs the script with default settings, processing all *.TcPOU files in the Git repository.

.EXAMPLE
    .\Extract-Messages.ps1 -Languages @("en", "de", "fr")
    Runs the script and generates entries for English, German, and French in the JSON output.
#>

# -----------------------------
# Parameters
# -----------------------------
param(
    [Parameter(HelpMessage="An array of language codes to include in the output JSON.")]
    [string[]]$Languages = @("en")
)

# -----------------------------
# Centralized Configuration
# -----------------------------
 $script:Config = @{
    # --- Script Metadata ---
    Version = "2.8" # Updated version
    GeneratedBy = "Tc3 Message Extractor (PowerShell)"


    # --- File Processing ---
    # Regex to find messages: [optional_prefix.]M_(Type)([optional_id], 'message_text')
    MessagePattern = '(\w+\.)?M_(Info|Warning|Error|Critical)\s*\(\s*([0-9]*)\s*,\s*''([^'']+)''\s*\)(.*)'
    FileFilter = "*.TcPOU"

    # --- Placeholder Conversion for XML ---
    # Maps PLC placeholders to .NET string format placeholders
    PlaceholderMap = @{
        '%s' = '{0}'
        '%d' = '{1}'
        '%i' = '{2}'
        '%f' = '{3}'
    }

    # --- Output Filenames ---
    OutputJson = "messages.json"
    OutputXml = "EventClass.xml"
}

# -----------------------------
# Logging Function
# -----------------------------
 $script:Log = @()
function Write-Log {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Message,
        [ValidateSet("Info", "Warning", "Error")]
        [string]$Level = "Info"
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "[$timestamp] [$Level] $Message"
    $script:Log += $logEntry

    switch ($Level) {
        "Info"    { Write-Host $logEntry -ForegroundColor White }
        "Warning" { Write-Host $logEntry -ForegroundColor Red } # MODIFIED LINE
        "Error"   { Write-Error $logEntry }
    }
}

# -----------------------------
# Determine Git repository root dynamically
# -----------------------------
try {
    $gitRoot = git rev-parse --show-toplevel 2>$null
    if (-not $gitRoot) {
        throw "Not a git repository (or no .git directory)."
    }
    $rootFolder = $gitRoot.Trim()
    Write-Log "Successfully determined Git repository root: $rootFolder"
} catch {
    Write-Log "Cannot determine Git repository root. Falling back to script folder. Error: $($_.Exception.Message)" -Level Warning
    $rootFolder = $PSScriptRoot
}

 $outputFile = Join-Path -Path $rootFolder -ChildPath $script:Config.OutputJson
 $outputXmlFile = Join-Path -Path $rootFolder -ChildPath $script:Config.OutputXml

# Ensure output folder exists
 $outputFolder = Split-Path $outputFile
if (-not (Test-Path $outputFolder)) {
    New-Item -Path $outputFolder -ItemType Directory -Force | Out-Null
    Write-Log "Created output directory: $outputFolder"
}

Write-Log "Output JSON file: $outputFile"
Write-Log "Output XML file: $outputXmlFile"

# -----------------------------
# Get all *.TcPOU files
# -----------------------------
try {
    $files = Get-ChildItem -Path $rootFolder -Recurse -Include $script:Config.FileFilter -ErrorAction Stop
    if ($files.Count -eq 0) {
        Write-Log "No '$($script:Config.FileFilter)' files found in '$rootFolder'. Exiting." -Level Warning
        return
    }
    Write-Log "Found $($files.Count) '$($script:Config.FileFilter)' files to process."
} catch {
    Write-Log "Failed to search for files. Error: $($_.Exception.Message)" -Level Error
    return
}

# -----------------------------
# Function: Get-UDINTHash (polynomial rolling hash)
# -----------------------------

function Get-UDINTHash {
    param([string]$s)

    [int64]$p = 37
    [int64]$m = 1000000009
    [int64]$hash = 0
    [int64]$pPow = 1



    foreach ($ch in $s.ToCharArray()) {
        [int64]$cVal = [int][char]$ch 
        $hash = ($hash + ($cVal * $pPow) % $m) % $m
        $pPow = ($pPow * $p) % $m
    }
    # which can be safely cast to [uint32].
    return [uint32]$hash
}

# -----------------------------
# Function: Convert-Placeholders
# -----------------------------
function Convert-Placeholders {
    param([string]$text)

    $script:pIndex = 0
    $placeholders = $script:Config.PlaceholderMap.Keys -join '|'
    return ([regex]::Replace($text, "($placeholders)", {
        param($match)
        $placeholder = $match.Value
        if ($script:Config.PlaceholderMap.ContainsKey($placeholder)) {
            $current = $script:pIndex
            $script:pIndex++
            # Use the mapped placeholder, but keep the index {0}, {1} etc.
            return $script:Config.PlaceholderMap[$placeholder] -f $current
        }
        return $match.Value # Return original if not in map
    }))
}

# -----------------------------
# Initialize messages hashtable
# -----------------------------
 $messages = @{}

# --- NEW: Track processed messages to detect collisions ---
 $processedMessages = @{}

# -----------------------------
# Iterate files and process content
# -----------------------------
foreach ($file in $files) {
    Write-Log "Processing file: $($file.FullName)"
    try {
        $content = Get-Content $file.FullName -Raw -Encoding UTF8
        if ([string]::IsNullOrWhiteSpace($content)) {
            Write-Log "File is empty or contains only whitespace. Skipping." -Level Warning
            continue
        }

        $originalContent = $content
        $script:modified = $false
        $pattern = $script:Config.MessagePattern

        $content = [regex]::Replace($content, $pattern, {
            param($match)

            $prefix = $match.Groups[1].Value
            $logType = $match.Groups[2].Value
            $idText = $match.Groups[3].Value.Trim()
            $msgText = $match.Groups[4].Value.Trim()
            $trailing = $match.Groups[5].Value

            if ([string]::IsNullOrWhiteSpace($msgText)) {
                Write-Log "Found an empty message string in $($file.FullName). Skipping this match." -Level Warning
                return $match.Value # Return original content to avoid breaking the file
            }

            [uint32]$id = 0
            $hasExistingId = [uint32]::TryParse($idText, [ref]$id)
            $computedId = [uint32](Get-UDINTHash $msgText)

            # --- NEW: ID Collision Resolution Logic ---
            # Check if an ID was provided and if it collides with a different text.
            if ($hasExistingId -and $processedMessages.ContainsKey($id) -and $processedMessages[$id].key -ne $msgText) {
                # This is a collision. The provided ID is used by a different message.
                # We need to resolve this by generating a new ID.
                $newId = [uint32](Get-UDINTHash "$($msgText)_collision_fix")
                Write-Log "ID Collision: The provided ID $id for message '$msgText' is already used by a different message. A new ID $newId will be generated and used." -Level Warning
                $id = $newId
                $script:modified = $true
            } elseif (-not $hasExistingId -or $id -eq 0) {
                # No ID was provided or it was 0, so we use the computed one.
                $id = $computedId
                $script:modified = $true
            } else {
                # An existing, valid ID was provided and it doesn't collide. Use it as is.
                # No modification needed for this message.
            }

            # Add the (potentially new or updated) message to the main hashtable.
            # The key is the ID, so we only add it once.
            if (-not $messages.ContainsKey($id)) {
                $messages[$id] = @{
                    id = $id
                    key = $msgText
                    locale = @{}
                }
            }

            # Store English text as the definitive source for this ID.
            $messages[$id].locale["en"] = $msgText

            # Update the processed messages list for future collision checks.
            # This is crucial. We use the FINAL ID that was decided.
            $processedMessages[$id] = @{ id = $id; key = $msgText }

            # Return the replacement string with the FINAL ID.
            return "$prefix`M_$logType($id, '$msgText')$trailing"
        })

        if ($script:modified) {
            Set-Content -Path $file.FullName -Value $content -NoNewline -Encoding UTF8
            Write-Log "Updated file with new message IDs: $($file.FullName)"
        }

    } catch {
        Write-Log "An error occurred while processing file '$($file.FullName)'. Error: $($_.Exception.Message)" -Level Error
    }
}

# --------------------------------------------------------------------
# --- Export flat-structure messages.json (MERGING LOGIC) ---
# --------------------------------------------------------------------
# This section is rewritten to preserve all existing messages and add/update new ones.

# Start with a complete copy of all existing messages.
# This hashtable will be our "master list" and will contain the final result.
# The key is a combination of ID and locale, e.g., "12345_en".
 $finalMessages = @{}
if (Test-Path $outputFile) {
    try {
        $jsonContent = Get-Content -Path $outputFile -Raw | ConvertFrom-Json
        foreach ($item in $jsonContent) {
            $key = "$($item.id)_$($item.locale)"
            $finalMessages[$key] = $item
        }
        Write-Log "Loaded $($finalMessages.Count) existing messages from '$($script:Config.OutputJson)' to be used as base for new output."
    } catch {
        Write-Log "Failed to load or parse existing JSON file '$($script:Config.OutputJson)'. Starting with an empty list. Error: $($_.Exception.Message)" -Level Warning
    }
}

# --- Initialize a counter for new messages ---
 $newMessageCount = 0
 $newMessagesFound = @() # To store details of new messages for a final report

# Now, iterate through the messages we just found in the .TcPOU files.
# For each new message, we will either update an existing entry in our master list
# or add a brand new one.
foreach ($newMsg in $messages.Values | Sort-Object id) {
    foreach ($lang in $Languages) {
        $key = "$($newMsg.id)_$($lang)"

        # --- Check if this is a new message and log it ---
        # We only need to report it once, so we check the 'en' locale.
        if (-not $finalMessages.ContainsKey($key) -and $lang -eq "en") {
            $newMessageCount++
            $newMessagesFound += [PSCustomObject]@{
                Id = $newMsg.id
                Text = $newMsg.key
            }
        }

        # Create the object that represents this message (new or updated).
        $messageObject = [PSCustomObject]@{
            locale = $lang
            id     = $newMsg.id
            key    = "" # Default to an empty translation
        }

        if ($finalMessages.ContainsKey($key)) {
            # This message (ID + Locale) already exists in our master list.
            # We preserve its existing translation to avoid losing work.
            $messageObject.key = $finalMessages[$key].key
        } elseif ($lang -eq "en") {
            # This is a brand new message and it's the English version.
            # Use the text from the source code as the definitive translation.
            $messageObject.key = $newMsg.key
        }
        # If it's a new message and not English, 'key' correctly remains empty,
        # ready to be filled in by a translator.

        # Update the master list with this (new or updated) message object.
        # This ensures that even if the English text changed, the old translation is kept
        # until a translator can update it.
        $finalMessages[$key] = $messageObject
    }
}

# --- Log a summary of new messages ---
if ($newMessageCount -gt 0) {
    Write-Log "Found and added $newMessageCount new message(s) this run:" -Level Warning
    foreach ($msg in $newMessagesFound) {
        Write-Log "  - New: ID=$($msg.Id), Text='$($msg.Text)'" -Level Warning
    }
} else {
    Write-Log "No new messages found in source files."
}

# The $finalMessages hashtable now contains the complete, merged set of messages.
# We convert it to an array, sort it for consistent output, and save it.
try {
    $sortedOutput = $finalMessages.Values | Sort-Object -Property @{Expression={[uint32]$_.id}; Ascending=$true}, Locale
    $sortedOutput | ConvertTo-Json -Depth 5 | Set-Content -Path $outputFile -Encoding UTF8
    Write-Log "Exported $($sortedOutput.Count) total message entries to '$outputFile'. Old messages have been preserved."
} catch {
    Write-Log "Failed to write JSON output file. Error: $($_.Exception.Message)" -Level Error
}

# --------------------------------------------------------------------
# --- Export EventClass.xml (Enhanced with metadata and placeholders) ---
# --------------------------------------------------------------------
try {
    $xmlDoc = [System.Xml.XmlDocument]::new()
    $xmlDec = $xmlDoc.CreateXmlDeclaration("1.0", "utf-8", $null)
    $xmlDoc.AppendChild($xmlDec) | Out-Null

    $rootEl = $xmlDoc.CreateElement("EventClass")
    $rootEl.SetAttribute("Generated", (Get-Date -Format "yyyy-MM-ddTHH:mm:ss"))
    $rootEl.SetAttribute("Generator", $script:Config.GeneratedBy)
    $rootEl.SetAttribute("Version", $script:Config.Version)
    $xmlDoc.AppendChild($rootEl) | Out-Null

    foreach ($msg in $messages.Values | Sort-Object id) {
        $eventEl = $xmlDoc.CreateElement("EventId")

        $nameEl = $xmlDoc.CreateElement("Name")
        $nameEl.SetAttribute("Id", $msg.id)
        $nameEl.InnerText = "Tc3_Event_$($msg.id)"
        $eventEl.AppendChild($nameEl) | Out-Null

        $displayEl = $xmlDoc.CreateElement("DisplayName")
        $displayEl.SetAttribute("TxtId", "")
        # Convert placeholders like %s to {0} for TwinCAT
        $cdata = $xmlDoc.CreateCDataSection( (Convert-Placeholders $msg.key) )
        $displayEl.AppendChild($cdata) | Out-Null
        $eventEl.AppendChild($displayEl) | Out-Null

        $rootEl.AppendChild($eventEl) | Out-Null
    }

    $xmlDoc.Save($outputXmlFile)
    Write-Log "Exported XML to '$outputXmlFile'"

} catch {
    Write-Log "Failed to create or save XML file. Error: $($_.Exception.Message)" -Level Error
}

# --------------------------------------------------------------------
# --- Final Output Validation ---
# --------------------------------------------------------------------
function Test-OutputFiles {
    $issues = @()
    # Validate JSON
    if (Test-Path $outputFile) {
        try {
            $jsonContent = Get-Content -Path $outputFile -Raw | ConvertFrom-Json
            if ($jsonContent.Count -eq 0) {
                $issues += "JSON file '$($script:Config.OutputJson)' is valid but contains no entries."
            }
        } catch {
            $issues += "JSON file '$($script:Config.OutputJson)' is not valid or cannot be parsed. Error: $_"
        }
    } else {
        $issues += "JSON file '$($script:Config.OutputJson)' was not created."
    }

    # Validate XML
    if (Test-Path $outputXmlFile) {
        try {
            [xml]$xmlContent = Get-Content -Path $outputXmlFile -Raw
            if (-not $xmlContent.EventClass -or $xmlContent.EventClass.EventId.Count -eq 0) {
                $issues += "XML file '$($script:Config.OutputXml)' is valid but contains no EventId elements."
            }
        } catch {
            $issues += "XML file '$($script:Config.OutputXml)' is not valid or cannot be parsed. Error: $_"
        }
    } else {
        $issues += "XML file '$($script:Config.OutputXml)' was not created."
    }
    return $issues
}

 $validationIssues = Test-OutputFiles
if ($validationIssues.Count -gt 0) {
    Write-Log "Validation completed with issues:" -Level Warning
    $validationIssues | ForEach-Object { Write-Log "- $_" -Level Warning }
} else {
    Write-Log "Validation completed successfully. Output files are present and appear to be well-formed."
}

Write-Log "Script finished."