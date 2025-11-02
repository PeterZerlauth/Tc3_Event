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
# Function: Find-Hash2 (polynomial rolling hash)
# -----------------------------
function Get-UDINTHash {
    param([string]$s)

    $p = 37
    $m = 1000000009
    $hash = 0
    $pPow = 1

    foreach ($ch in $s.ToCharArray()) {
        $cVal = [int][char]$ch - [int][char]'a' + 1
        $hash = ($hash + ($cVal * $pPow) % $m) % $m
        $pPow = ($pPow * $p) % $m
    }

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
        $logType = $match.Groups[2].Value
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
                messages = @{}
            }

            if ($existingMessages.ContainsKey($idKey)) {
                $oldMsg = $existingMessages[$idKey]
                $oldEn = $oldMsg.messages.en
                $oldTranslations = $oldMsg.messages

                if ($oldEn -ne $msgText) {
                    Write-Host "  - English text changed for ID $id, resetting translations"
                    foreach ($lang in $Languages) {
                        if ($lang -eq "en") {
                            $messages[$id].messages[$lang] = $msgText
                        } else {
                            $messages[$id].messages[$lang] = ""
                        }
                    }
                } else {
                    foreach ($lang in $Languages) {
                        if ($oldTranslations.PSObject.Properties.Name -contains $lang) {
                            $messages[$id].messages[$lang] = $oldTranslations.$lang
                        } else {
                            $messages[$id].messages[$lang] = ""
                        }
                    }
                }
            } else {
                foreach ($lang in $Languages) {
                    if ($lang -eq "en") {
                        $messages[$id].messages[$lang] = $msgText
                    } else {
                        $messages[$id].messages[$lang] = ""
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
# Export all messages to JSON
# -----------------------------
$messages.Values | Sort-Object -Property id | ConvertTo-Json -Depth 5 | Set-Content -Path $outputFile -Encoding UTF8
Write-Host "Extracted $($messages.Count) unique log messages to $outputFile"
