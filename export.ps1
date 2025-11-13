# -----------------------------
# Parameters
# -----------------------------
param(
    [string[]]$Languages = @("en", "de")  # default languages if not provided
)

# -----------------------------
# Determine Git repository root dynamically
# -----------------------------
try {
    $gitRoot = git rev-parse --show-toplevel 2>$null
    if (-not $gitRoot) {
        throw "Not a git repository."
    }
    $rootFolder = $gitRoot.Trim()
} catch {
    Write-Warning "Cannot determine Git repository root, falling back to script folder."
    $rootFolder = $PSScriptRoot
}

$outputFile = Join-Path -Path $rootFolder -ChildPath "messages.json"

# Ensure output folder exists
$outputFolder = Split-Path $outputFile
if (-not (Test-Path $outputFolder)) {
    New-Item -Path $outputFolder -ItemType Directory -Force | Out-Null
}

Write-Host "Using root folder: $rootFolder"
Write-Host "Output file: $outputFile"

# -----------------------------
# Load existing messages.json (if available)
# -----------------------------
$existingMessages = @{}
if (Test-Path $outputFile) {
    try {
        $jsonContent = Get-Content -Path $outputFile -Raw | ConvertFrom-Json
        foreach ($item in $jsonContent) {
            $existingMessages[[string]$item.id] = $item
        }
        Write-Host "Loaded $($existingMessages.Count) existing messages from $outputFile"
    } catch {
        Write-Warning "Failed to load existing JSON. Starting fresh."
    }
}

# -----------------------------
# Get all *.TcPOU files
# -----------------------------
$files = Get-ChildItem -Path $rootFolder -Recurse -Include "*.TcPOU"

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
# Initialize messages hashtable
# -----------------------------
$messages = @{}

# -----------------------------
# Iterate files
# -----------------------------
foreach ($file in $files) {
    Write-Host "Processing file: $($file.FullName)"
    $content = Get-Content $file.FullName -Raw
    $originalContent = $content
    $script:modified = $false

    # Regex pattern for log statements
    $pattern = '(\w+\.)?M_(Info|Warning|Error|Critical)\s*\(\s*([0-9]*)\s*,\s*''([^'']+)''\s*\)(.*)'

    $content = [regex]::Replace($content, $pattern, {
        param($match)

        $prefix = $match.Groups[1].Value
        $logType = $match.Groups[2].Value # <-- We need this log type
        $idText = $match.Groups[3].Value.Trim()
        $msgText = $match.Groups[4].Value.Trim()
        $trailing = $match.Groups[5].Value

        [uint32]$id = 0
        $hasExistingId = [uint32]::TryParse($idText, [ref]$id)

        # Generate new ID if missing or zero
        $computedId = [uint32](Get-UDINTHash $msgText)
        if (-not $hasExistingId -or $id -eq 0) {
            Write-Host "  - Generating new ID for message '$msgText': $idText => $computedId"
            $id = $computedId
            $script:modified = $true
        } else {
            Write-Host "  - Keeping existing ID for message '$msgText': $id"
        }

        $idKey = [string]$id

        # Build or merge message entry
        if (-not $messages.ContainsKey($id)) {
            $messages[$id] = @{
                id = $id
                key = $msgText
                level = $logType  # <-- MODIFIED: Store the log level
                locale = @{} 
            }

            if ($existingMessages.ContainsKey($idKey)) {
                $oldMsg = $existingMessages[$idKey]
                $oldEn = $oldMsg.locale.en
                $oldTranslations = $oldMsg.locale

                if ($oldEn -ne $msgText) {
                    Write-Host "  - English text changed for ID $id, resetting translations"
                    foreach ($lang in $Languages) {
                        if ($lang -eq "en") {
                            $messages[$id].locale[$lang] = $msgText
                        } else {
                            $messages[$id].locale[$lang] = ""
                        }
                    }
                } else {
                    foreach ($lang in $Languages) {
                        if ($oldTranslations.PSObject.Properties.Name -contains $lang) {
                            $messages[$id].locale[$lang] = $oldTranslations.$lang
                        } else {
                            $messages[$id].locale[$lang] = ""
                        }
                    }
                }
            } else {
                foreach ($lang in $Languages) {
                    if ($lang -eq "en") {
                        $messages[$id].locale[$lang] = $msgText
                    } else {
                        $messages[$id].locale[$lang] = ""
                    }
                }
            }
        }

        return "$prefix`M_$logType($id, '$msgText')$trailing"
    })

    if ($script:modified -or $content -ne $originalContent) {
        Set-Content -Path $file.FullName -Value $content -NoNewline -Encoding UTF8
        Write-Host "File updated: $($file.FullName)"
    } else {
        Write-Host "No changes needed for: $($file.FullName)"
    }
}

# -----------------------------
# Export all messages to JSON with id, key, locale order
# -----------------------------
$orderedMessages = $messages.Values | Sort-Object -Property id | ForEach-Object {
    [PSCustomObject]@{
        id     = $_.id
        key    = $_.key
        level  = $_.level  # <-- MODIFIED: Include level in the ordered object
        locale = $_.locale
    }
}

$orderedMessages | ConvertTo-Json -Depth 5 | Set-Content -Path $outputFile -Encoding UTF8
Write-Host "Extracted $($messages.Count) unique log messages to $outputFile"

# --------------------------------------------------------------------
# --- ADDED: Export all messages to eventClass.xml ---
# --------------------------------------------------------------------
$outputXmlFile = Join-Path -Path $rootFolder -ChildPath "eventClass.xml"

try {
    # Initialize XML Document
    $xmlDoc = [System.Xml.XmlDocument]::new()
    $xmlDec = $xmlDoc.CreateXmlDeclaration("1.0", "utf-8", $null)
    $xmlDoc.AppendChild($xmlDec) | Out-Null

    # Create Root Element
    $rootEl = $xmlDoc.CreateElement("EventClass")
    $xmlDoc.AppendChild($rootEl) | Out-Null

    # Loop through each message
    foreach ($msg in $orderedMessages) {
        $eventEl = $xmlDoc.CreateElement("EventId")

        # Create <Name> element
        $nameEl = $xmlDoc.CreateElement("Name")
        $nameEl.SetAttribute("Id", $msg.id)
        $nameEl.InnerText = "Tc3_Event_$($msg.id)"
        $eventEl.AppendChild($nameEl) | Out-Null

        # Create <DisplayName> element
        $displayEl = $xmlDoc.CreateElement("DisplayName")
        $displayEl.SetAttribute("TxtId", "")
        # Use CDATA for the message text to handle special characters
        $cdata = $xmlDoc.CreateCDataSection($msg.key)
        $displayEl.AppendChild($cdata) | Out-Null
        $eventEl.AppendChild($displayEl) | Out-Null

        # Create <Severity> element based on the level
        # I'm mapping 'Info' to 'Verbose' based on your example.
        $severityText = switch ($msg.level) {
            "Info"     { "Verbose" }
            "Warning"  { "Warning" }
            "Error"    { "Error" }
            "Critical" { "Critical" }
        }

        if (-not [string]::IsNullOrEmpty($severityText)) {
            $severityEl = $xmlDoc.CreateElement("Severity")
            $severityEl.InnerText = $severityText
            $eventEl.AppendChild($severityEl) | Out-Null
        }

        # Add the completed <EventId> to the root
        $rootEl.AppendChild($eventEl) | Out-Null
    }

    # Save the XML file
    $xmlDoc.Save($outputXmlFile)
    Write-Host "Exported $($orderedMessages.Count) messages to $outputXmlFile"

} catch {
    Write-Warning "Failed to create XML file '$outputXmlFile'."
    Write-Warning $_.Exception.Message
}