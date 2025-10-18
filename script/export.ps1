# -----------------------------
# Parameters
# -----------------------------
param(
    [string[]]$Languages = @("en", "de")  # default languages if not provided
)

# -----------------------------
# Config
# -----------------------------
$rootFolder = "C:\source\repos\Logger"
$outputFile = Join-Path -Path $PSScriptRoot -ChildPath "messages.json"

# Ensure output folder exists
$outputFolder = Split-Path $outputFile
if (-not (Test-Path $outputFolder)) {
    New-Item -Path $outputFolder -ItemType Directory -Force | Out-Null
}

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
# Function: compute 32-bit UDINT hash
# -----------------------------
function Get-UDINTHash([string]$text) {
    [uint32]$hash = 5381
    foreach ($c in $text.ToCharArray()) {
        $hash = (($hash -shl 5) -bor ($hash -shr 27)) + [uint32][char]$c
    }
    return $hash
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
        $logType = $match.Groups[2].Value
        $idText = $match.Groups[3].Value.Trim()
        $msgText = $match.Groups[4].Value.Trim()
        $trailing = $match.Groups[5].Value

        # Parse existing ID
        [uint32]$id = 0
        $hasExistingId = [uint32]::TryParse($idText, [ref]$id)

        # Generate new ID if missing or zero
        $computedId = [uint32](Get-UDINTHash $msgText)
        if (-not $hasExistingId -or $id -eq 0) {
            $oldIdText = $idText
            $id = $computedId
            $script:modified = $true
            Write-Host "  - Generating new ID for message '$msgText': $oldIdText => $id"
        } else {
            Write-Host "  - Keeping existing ID for message '$msgText': $id"
        }

        $idKey = [string]$id

        # Build or merge message entry
        if (-not $messages.ContainsKey($id)) {
            $messages[$id] = @{
                id = $id
                messages = @{}
            }

            if ($existingMessages.ContainsKey($idKey)) {
                # Reuse existing message entry
                $oldMsg = $existingMessages[$idKey]
                $oldEn = $oldMsg.messages.en
                $oldTranslations = $oldMsg.messages

                if ($oldEn -ne $msgText) {
                    Write-Host "  - English text changed for ID $id, resetting translations"
                    foreach ($lang in $Languages) {
                        if ($lang -eq "en") {
                            $messages[$id].messages[$lang] = $msgText
                        } else {
                            $messages[$id].messages[$lang] = ""  # reset translation
                        }
                    }
                } else {
                    # Keep all existing translations
                    foreach ($lang in $Languages) {
                        if ($oldTranslations.PSObject.Properties.Name -contains $lang) {
                            # Keep existing translation
                            $messages[$id].messages[$lang] = $oldTranslations.$lang
                        } else {
                            # Only initialize if it doesn't exist yet
                            if (-not $messages[$id].messages.ContainsKey($lang)) {
                                if ($lang -eq "en") {
                                    $messages[$id].messages[$lang] = $msgText
                                } else {
                                    $messages[$id].messages[$lang] = ""
                                }
                            }
                        }
                    }
                }
            } else {
                # New message ID
                foreach ($lang in $Languages) {
                    if ($lang -eq "en") {
                        $messages[$id].messages[$lang] = $msgText
                    } else {
                        $messages[$id].messages[$lang] = ""
                    }
                }
            }
        }

        # Reconstruct log call, preserving original formatting
        return "$prefix`M_$logType($id, '$msgText')$trailing"
    })

    # Write file if modified
    if ($script:modified -or $content -ne $originalContent) {
        Set-Content -Path $file.FullName -Value $content -NoNewline -Encoding UTF8
        Write-Host "File updated (IDs and/or syntax corrected): $($file.FullName)"
    } else {
        Write-Host "No changes needed for: $($file.FullName)"
    }
}

# -----------------------------
# Export all messages to JSON
# -----------------------------
$messages.Values | Sort-Object -Property id | ConvertTo-Json -Depth 5 | Set-Content -Path $outputFile -Encoding UTF8
Write-Host "Extracted $($messages.Count) unique log messages to $outputFile"
