# AutoDoc.ps1 - improved (POU -> Type mapping added)
# Generates Markdown documentation from TwinCAT PLC sources.
# Improvements:
# - auto-detects git root directory
# - generates cleaner markdown output
# - robust Type map and relative link resolution
# - adds POU map (FunctionBlocks / Functions) so FB types are linkable like enums
# - passes output file path to parsers so they can compute relative links

# ------------------------------------------------------------
# Config / Defaults (no more hard-coded $strProject)
# ------------------------------------------------------------
# The script will attempt to find the git root automatically.
# You can override by setting $strProject or running from desired folder.

# Global containers
$overview = @()
$TypesOverview = @()
$global:FunctionBlocks = @()
$global:Functions = @()
$global:TypesMap = @{}    # typeName -> absolute full path to generated md file (DUT types)
$global:POUMap  = @{}     # POUName   -> absolute full path to generated md file (POU FB/Function types)

# -------------------
# Helpers
# -------------------
function Get-GitRoot {
    param([string]$StartPath = (Get-Location).Path)

    # Try git if available
    try {
        $git = (Get-Command git -ErrorAction SilentlyContinue)
        if ($git) {
            $proc = & git -C $StartPath rev-parse --show-toplevel 2>$null
            if ($LASTEXITCODE -eq 0 -and $proc) {
                return $proc.Trim()
            }
        }
    } catch {
        # ignore and fallback to manual search
    }

    # Walk up directories looking for .git
    $dir = [System.IO.Path]::GetFullPath($StartPath)
    while ($dir -ne [System.IO.Path]::GetPathRoot($dir)) {
        if (Test-Path (Join-Path $dir ".git")) {
            return $dir
        }
        $dir = Split-Path $dir -Parent
        if (-not $dir) { break }
    }

    # last fallback: script folder or current location
    if ($PSScriptRoot) { return $PSScriptRoot }
    return (Get-Location).Path
}

function Get-RelativePath {
    param(
        [Parameter(Mandatory=$true)][string]$FromFilePath,
        [Parameter(Mandatory=$true)][string]$ToFilePath
    )

    # Convert to full absolute paths
    try {
        $fromFileFull = [System.IO.Path]::GetFullPath($FromFilePath)
    } catch {
        $fromFileFull = $FromFilePath
    }
    try {
        $toFileFull = [System.IO.Path]::GetFullPath($ToFilePath)
    } catch {
        $toFileFull = $ToFilePath
    }

    # We need directory for the "from"
    $fromDir = Split-Path $fromFileFull -Parent
    if (-not $fromDir) { return $toFileFull }

    try {
        $fromUri = New-Object System.Uri((($fromDir.TrimEnd('\') + [IO.Path]::DirectorySeparatorChar)))
        $toUri   = New-Object System.Uri($toFileFull)
        $relUri = $fromUri.MakeRelativeUri($toUri)
        $relPath = [System.Uri]::UnescapeDataString($relUri.ToString())
        # Ensure forward slashes for markdown
        return $relPath -replace '\\', '/'
    } catch {
        # On failure (cross-drive etc.) return absolute normalized with forward slashes
        return ($toFileFull -replace '\\','/')
    }
}

# -------------------
# Declaration -> Markdown converter
# -------------------
function Convert-DeclarationToMarkdown {
    param(
        [string]$Declaration,
        [string]$CurrentMdPath, # full path to the .md being generated (used for relative links)
        [string]$DocRoot        # document root (not necessary but kept for compatibility)
    )

    if (-not $Declaration) { return "" }

    $lines = $Declaration -split "`r?`n"
    $inputs = [ordered]@{}
    $outputs = [ordered]@{}
    $vars = [ordered]@{}
    $currentSection = 'NONE'
    $pendingComment = ''

    $VarRegex = '^\s*(?<Name>\w+)\s*:\s*(?<Type>[\w\._\(\)<>\[\]]+)\s*(?:(?::=)\s*(?<Default>.*?))?\s*;?\s*(?:\/\/\s*(?<Comment>.*))?'

    foreach ($line in $lines) {
        $trimmedLine = $line.Trim()

        if ($trimmedLine -match '^\/\/\s*(?<Value>.*)') {
            $pendingComment = $Matches['Value'].Trim()
            continue
        }
        if ($trimmedLine -match '^\(\*\s*(?<Value>.*?)\s*\*\)') {
            $pendingComment = $Matches['Value'].Trim()
            continue
        }

        if ($trimmedLine.ToUpper().StartsWith('VAR_INPUT')) { $currentSection = 'INPUT'; continue }
        if ($trimmedLine.ToUpper().StartsWith('VAR_OUTPUT')) { $currentSection = 'OUTPUT'; continue }
        if ($trimmedLine.ToUpper().StartsWith('VAR') -and -not $trimmedLine.ToUpper().StartsWith('VAR_')) { $currentSection = 'VAR'; continue }
        if ($trimmedLine.ToUpper().StartsWith('END_VAR')) { $currentSection = 'NONE'; $pendingComment = ''; continue }

        if ($trimmedLine -match $VarRegex) {
            $varName = $Matches['Name']
            $varType = $Matches['Type']
            $varDefault = ""
            if ($Matches['Default']) { $varDefault = $Matches['Default'].Trim() }

            $varComment = $pendingComment
            if ($Matches['Comment'] -and $Matches['Comment'].Trim()) { $varComment = $Matches['Comment'].Trim() }

            # Linkify the Type using TypesMap (DUT types) or POUMap (FB/Function types)
            $linkedType = $varType
            if ($global:TypesMap.ContainsKey($varType)) {
                $typeFullPath = $global:TypesMap[$varType] # absolute path
                $rel = Get-RelativePath -FromFilePath $CurrentMdPath -ToFilePath $typeFullPath
                $linkedType = "[$varType]($rel)"
            } elseif ($global:POUMap.ContainsKey($varType)) {
                $typeFullPath = $global:POUMap[$varType]
                $rel = Get-RelativePath -FromFilePath $CurrentMdPath -ToFilePath $typeFullPath
                $linkedType = "[$varType]($rel)"
            }

            # Escape pipes in comments, names and defaults
            $varComment = $varComment -replace '\|','\|'
            $varDefault = $varDefault -replace '\|','\|'

            $varObj = [PSCustomObject]@{
                Name = $varName
                Type = $linkedType
                Default = $varDefault
                Comment = $varComment
            }

            switch ($currentSection) {
                'INPUT'  { if (-not $inputs.Contains($varName))  { $inputs.Add($varName, $varObj) } }
                'OUTPUT' { if (-not $outputs.Contains($varName)) { $outputs.Add($varName, $varObj) } }
                'VAR'    { if (-not $vars.Contains($varName))    { $vars.Add($varName, $varObj) } }
            }

            $pendingComment = ''
        }
    }

    $md = ""

    if ($inputs.Count -gt 0) {
        $md += "### VAR_INPUT`n`n"
        $hasDefaults = ($inputs.Values | Where-Object { $_.Default -and $_.Default.Length -gt 0 }).Count -gt 0
        if ($hasDefaults) {
            $md += "| Name | Type | Default | Description |`n"
            $md += "| :--- | :--- | :--- | :--- |`n"
            foreach ($var in $inputs.Values) {
                $md += "| $($var.Name) | $($var.Type) | $($var.Default) | $($var.Comment) |`n"
            }
        } else {
            $md += "| Name | Type | Description |`n"
            $md += "| :--- | :--- | :--- |`n"
            foreach ($var in $inputs.Values) {
                $md += "| $($var.Name) | $($var.Type) | $($var.Comment) |`n"
            }
        }
        $md += "`n"
    }

    if ($outputs.Count -gt 0) {
        $md += "### VAR_OUTPUT`n`n"
        $md += "| Name | Type | Description |`n"
        $md += "| :--- | :--- | :--- |`n"
        foreach ($var in $outputs.Values) {
            $md += "| $($var.Name) | $($var.Type) | $($var.Comment) |`n"
        }
        $md += "`n"
    }

    if ($vars.Count -gt 0) {
        $md += "### VAR`n`n"
        $md += "| Name | Type | Description |`n"
        $md += "| :--- | :--- | :--- |`n"
        foreach ($var in $vars.Values) {
            $md += "| $($var.Name) | $($var.Type) | $($var.Comment) |`n"
        }
        $md += "`n"
    }

    return $md
}

# -------------------
# Read POU (XML) - returns object with Content and POUType
# -------------------
function Read-SourceFile-XML {
    param(
        [string] $Path,
        [string] $File,
        [string] $OutputFullPath,
        [string] $DocRoot
    )

    Write-Host "Parsing (XML) $File"

    try {
        [xml]$xmlContent = Get-Content -Path (Join-Path $Path $File) -Encoding UTF8 -Raw
    } catch {
        Write-Warning "Could not read file $File as XML."
        return [PSCustomObject]@{ Content = "# $File`n`n*Error: Could not read as XML*" ; POUType = 'FunctionBlock' }
    }

    if (-not $xmlContent.TcPlcObject.POU) {
        Write-Warning "$File has no POU element."
        return [PSCustomObject]@{ Content = "# $File`n`n*Not a POU file.*"; POUType = 'FunctionBlock' }
    }

    $pou = $xmlContent.TcPlcObject.POU
    $pouName = $pou.Name
    $pouImplements = $pou.IMPLEMENTS

    $strContent = "# $pouName`n`n"
    if ($pouImplements) {
        $strContent += "> **Implements:** `$pouImplements``n`n"
    }

    $mainDeclarationText = $pou.Declaration.'#cdata-section'
    if ($mainDeclarationText) {
        $strContent += "## Declaration (Variables)`n`n"
        $strContent += Convert-DeclarationToMarkdown -Declaration $mainDeclarationText -CurrentMdPath $OutputFullPath -DocRoot $DocRoot
        $strContent += "`n"
    }

    $POUType = 'FunctionBlock'
    if ($mainDeclarationText -and $mainDeclarationText.Trim().ToUpper().StartsWith('FUNCTION ')) { $POUType = 'Function' }

    if ($pou.Method) {
        $strContent += "`n`n## Methods`n`n"
        foreach ($method in $pou.Method) {
            $methodName = $method.Name
            $methodDeclarationText = $method.Declaration.'#cdata-section'

            $strContent += "### $methodName`n`n"

            if ($methodDeclarationText -match 'METHOD\s+\w+\s*:\s*(?<Return>[\w\._\(\)]+)') {
                $strContent += "**Returns:** `$($Matches['Return'])``n`n"
            } elseif ($methodName -eq 'FB_Init') {
                $strContent += "**Returns:** `BOOL` (Implicit)`n`n"
            } else {
                $strContent += "**Returns:** `(None)`n`n"
            }

            $commentLines = @()
            if ($methodDeclarationText) {
                $commentLines = $methodDeclarationText -split "`r?`n" | Where-Object { $_.Trim().StartsWith('//') } | ForEach-Object { $_.Trim().Substring(2).Trim() }
            }
            if ($commentLines) { $strContent += ($commentLines -join " `n") + "`n`n" }

            $strContent += Convert-DeclarationToMarkdown -Declaration $methodDeclarationText -CurrentMdPath $OutputFullPath -DocRoot $DocRoot
        }
    }

    if ($pou.Property) {
        $strContent += "`n`n## Properties`n`n"
        foreach ($prop in $pou.Property) {
            $propName = $prop.Name
            $propDeclarationText = $prop.Declaration.'#cdata-section'

            $strContent += "### $propName`n`n"

            if ($propDeclarationText -match 'PROPERTY .* : (?<Type>[\w\._\(\)]+)') {
                $propType = $Matches['Type'].Trim()
                if ($global:TypesMap.ContainsKey($propType)) {
                    $typeFullPath = $global:TypesMap[$propType]
                    $rel = Get-RelativePath -FromFilePath $OutputFullPath -ToFilePath $typeFullPath
                    $propType = "[$propType]($rel)"
                } elseif ($global:POUMap.ContainsKey($propType)) {
                    $typeFullPath = $global:POUMap[$propType]
                    $rel = Get-RelativePath -FromFilePath $OutputFullPath -ToFilePath $typeFullPath
                    $propType = "[$propType]($rel)"
                }
                $strContent += "**Type:** `$propType``n`n"
            }

            if ($prop.Get) { $strContent += "* **Get:** Available`n" }
            if ($prop.Set) { $strContent += "* **Set:** Available`n" }
            $strContent += "`n"
        }
    }

    return [PSCustomObject]@{ Content = $strContent; POUType = $POUType }
}

# -------------------
# Read DUT file (types)
# -------------------
function Read-TypeFile {
    param(
        [string] $Path,
        [string] $File,
        [string] $OutputFullPath,
        [string] $DocRoot
    )

    Write-Host "Parsing (XML) $File "

    try {
        [xml]$xmlContent = Get-Content -Path (Join-Path $Path $File) -Encoding UTF8 -Raw
    } catch {
        Write-Warning "Could not read $File as XML"
        return "# $File`n`n*Error: Could not parse file.*"
    }

    if (-not $xmlContent.TcPlcObject.DUT) {
        Write-Warning "File $File does not appear to be a valid DUT file."
        return "# $File`n`n*Error: Could not parse file as DUT.*"
    }

    $declaration = $xmlContent.TcPlcObject.DUT.Declaration.'#cdata-section'
    if (-not $declaration) {
        return "# $File`n`n*No declaration.*"
    }

    $typeName = ""
    $isStruct = $declaration.ToUpper().Contains("STRUCT")
    $isEnum = (-not $isStruct) -and ($declaration -match '\(') # best-effort

    if ($declaration -match 'TYPE\s+(?<Name>\w+)\s*:') {
        $typeName = $Matches['Name']
    }

    $strContent = "# $typeName`n`n"

    if ($isStruct) {
        $strContent += "| Name | Type | Comment |`n"
        $strContent += "| :--- | :--- | :--- |`n"
    } else {
        $strContent += "| Name | Value | Comment |`n"
        $strContent += "| :--- | :--- | :--- |`n"
    }

    $lines = $declaration -split "`r?`n"
    $pendingComment = ""

    $VarRegex = '^\s*(?<Name>\w+)\s*:\s*(?<Type>[\w\._\(\)]+)\s*;?\s*(?:\/\/\s*(?<Comment>.*))?'
    $EnumRegex = '^\s*(?<Name>\w+)\s*(?:[:=]\s*(?<Value>\d+))?[,;]?\s*(?:\/\/\s*(?<Comment>.*))?'

    foreach ($line in $lines) {
        $trimmedLine = $line.Trim()
        if ($trimmedLine.StartsWith("TYPE") -or $trimmedLine.StartsWith("END_TYPE")) { continue }
        if ($trimmedLine.StartsWith("STRUCT") -or $trimmedLine.StartsWith("END_STRUCT")) { continue }

        if ($trimmedLine -match '^\/\/\s*(?<Value>.*)') {
            $pendingComment = $Matches['Value'].Trim()
            continue
        }
        if ($trimmedLine -match '^\(\*\s*(?<Value>.*?)\s*\*\)') {
            $pendingComment = $Matches['Value'].Trim()
            continue
        }

        $row = ""

        if ($isStruct -and ($trimmedLine -match $VarRegex)) {
            $varName = $Matches['Name']
            $varType = $Matches['Type']
            $varComment = $pendingComment
            if ($Matches['Comment']) { $varComment = $Matches['Comment'].Trim() }

            $linkedType = $varType
            if ($global:TypesMap.ContainsKey($varType)) {
                $typeFullPath = $global:TypesMap[$varType]
                $rel = Get-RelativePath -FromFilePath $OutputFullPath -ToFilePath $typeFullPath
                $linkedType = "[$varType]($rel)"
            } elseif ($global:POUMap.ContainsKey($varType)) {
                $typeFullPath = $global:POUMap[$varType]
                $rel = Get-RelativePath -FromFilePath $OutputFullPath -ToFilePath $typeFullPath
                $linkedType = "[$varType]($rel)"
            }

            $row = "| `$varName` | `$linkedType` | $varComment |"
        } elseif (-not $isStruct -and ($trimmedLine -match $EnumRegex)) {
            $varName = $Matches['Name']
            $varValue = $Matches['Value']
            $varComment = $pendingComment
            if ($Matches['Comment']) { $varComment = $Matches['Comment'].Trim() }
            if (-not $varValue) { $varValue = "..." }
            $row = "| `$varName` | `$varValue` | $varComment |"
        }

        if ($row) {
            $strContent += $row + "`n"
            $pendingComment = ""
        }
    }

    return $strContent
}

# -------------------
# Build Type map (DUT types)
# -------------------
function Create-TypeMap {
    param(
        [string] $Path,
        [string] $Destination,
        [switch] $Subfolder
    )

    $index = 0
    Write-Host "Create global Type map..."

    $duts = Get-ChildItem -Path $Path -Recurse -Filter "*.TcDUT" -ErrorAction SilentlyContinue
    foreach ($item in $duts) {
        $index++
        $strPath = Split-Path -Parent $item.FullName
        $strFile = Split-Path -Leaf $item.FullName

        try {
            [xml]$xmlContent = Get-Content -Path $item.FullName -Encoding UTF8 -Raw
        } catch {
            Write-Warning "Skipping invalid DUT: $strFile"
            continue
        }

        if (-not $xmlContent.TcPlcObject.DUT) {
            Write-Warning "Skipping non-DUT: $strFile"
            continue
        }

        $declaration = $xmlContent.TcPlcObject.DUT.Declaration.'#cdata-section'

        $strSubfolder = ""
        if ($Subfolder) { $strSubfolder = "Types" }

        if ($declaration -match 'TYPE\s+(?<Name>\w+)\s*:') {
            $typeName = $Matches["Name"]
            $fileName = $index.ToString("00")
            $mdFileName = $fileName + "_" + $strFile.Replace("TcDUT","md")
            $relativePath = if ($strSubfolder) { Join-Path $strSubfolder $mdFileName } else { $mdFileName }
            $mdFullPath = [System.IO.Path]::GetFullPath((Join-Path $Destination $relativePath))

            if (-not $global:TypesMap.ContainsKey($typeName)) {
                $global:TypesMap.Add($typeName, $mdFullPath)
            }
        }
    }
}

# -------------------
# Build POU map (FunctionBlocks / Functions)
# This lets us link a variable whose type is a FB/Function to the generated .md for that POU.
# -------------------
function Create-PouMap {
    param(
        [string] $Path,
        [string] $Destination,
        [switch] $Subfolder
    )

    $index = 0
    Write-Host "Create global POU map..."

    $pous = Get-ChildItem -Path $Path -Recurse -Filter "*.TcPOU" -ErrorAction SilentlyContinue
    foreach ($item in $pous) {
        $index++
        $strPath = Split-Path -Parent $item.FullName
        $strFile = Split-Path -Leaf $item.FullName

        try {
            [xml]$xmlContent = Get-Content -Path $item.FullName -Encoding UTF8 -Raw
        } catch {
            Write-Warning "Skipping invalid POU: $strFile"
            continue
        }

        if (-not $xmlContent.TcPlcObject.POU) {
            Write-Warning "Skipping non-POU: $strFile"
            continue
        }

        $pouNode = $xmlContent.TcPlcObject.POU
        $pouName = $pouNode.Name
        $strSubfolder = ""
        if ($Subfolder) { $strSubfolder = "Source" }

        $fileName = $index.ToString("00")
        $mdFileName = $fileName + "_" + $strFile.Replace("TcPOU","md")
        $relativePath = if ($strSubfolder) { Join-Path $strSubfolder $mdFileName } else { $mdFileName }
        $mdFullPath = [System.IO.Path]::GetFullPath((Join-Path $Destination $relativePath))

        if ($pouName -and -not $global:POUMap.ContainsKey($pouName)) {
            $global:POUMap.Add($pouName, $mdFullPath)
        }
    }
}

# -------------------
# Create documentation files for all matching files
# -------------------
function New-Documentation {
    param(
        [string] $Path,
        [string] $FileType,
        [string] $Destination,
        [switch] $Subfolder,
        [switch] $Structured
    )

    # Normalize base path
    $basePathFull = [System.IO.Path]::GetFullPath($Path)
    $destinationFull = [System.IO.Path]::GetFullPath($Destination)

    $index = 0
    $Filter = "*.$FileType"
    $strSubfolder = ""

    if ($FileType.Contains("DUT")) {
        Write-Host "Create datatypes..."
        if ($Subfolder) { $strSubfolder = "Types" }
    }
    if ($FileType.Contains("POU")) {
        Write-Host "Create sources..."
        if ($Subfolder) { $strSubfolder = "Source" }
    }
    if ($FileType.Contains("GVL")) {
        Write-Host "Create variables..."
        if ($Subfolder) { $strSubfolder = Join-Path $strSubfolder "Variables" }
    }

    $items = Get-ChildItem -Path $basePathFull -Recurse -Filter $Filter -ErrorAction SilentlyContinue
    foreach ($it in $items) {
        $index++
        # Normalize the item's parent directory
        $strPath = [System.IO.Path]::GetFullPath((Split-Path -Parent $it.FullName))
        $strFile = Split-Path -Leaf $it.FullName

        $Content = ""
        $ParseResult = $null

        # Pad index filename
        $filePrefix = $index.ToString("00")
        $mdFileName = $filePrefix + "_" + $strFile.Replace($FileType, "md")

        # Compute structured folder relative to base path safely
        if ($Structured) {
            $relativeSub = ""
            if ($strPath.StartsWith($basePathFull, [System.StringComparison]::InvariantCultureIgnoreCase)) {
                $relativeSub = $strPath.Substring($basePathFull.Length).TrimStart('\','/')
            } else {
                # fallback: try URI-based relative
                try {
                    $fromUri = New-Object System.Uri((($basePathFull.TrimEnd('\') + [IO.Path]::DirectorySeparatorChar)))
                    $toUri   = New-Object System.Uri($strPath)
                    $relUri = $fromUri.MakeRelativeUri($toUri)
                    $relativeSub = [System.Uri]::UnescapeDataString($relUri.ToString()) -replace '/','\' 
                } catch {
                    $relativeSub = "" 
                }
                $relativeSub = $relativeSub.TrimStart('\','/')
            }

            if ($strSubfolder) {
                if ($relativeSub) {
                    $FolderNew = Join-Path $destinationFull (Join-Path $strSubfolder $relativeSub)
                } else {
                    $FolderNew = Join-Path $destinationFull $strSubfolder
                }
            } else {
                if ($relativeSub) {
                    $FolderNew = Join-Path $destinationFull $relativeSub
                } else {
                    $FolderNew = $destinationFull
                }
            }
        } else {
            # Not structured: put files directly under Destination (optionally inside $strSubfolder)
            if ($strSubfolder) {
                $FolderNew = Join-Path $destinationFull $strSubfolder
            } else {
                $FolderNew = $destinationFull
            }
        }

        if (-not (Test-Path $FolderNew)) {
            # Ensure proper creation of nested folders
            New-Item -Path $FolderNew -ItemType Directory -Force | Out-Null
        }

        $FileNewPath = Join-Path $FolderNew $mdFileName
        Write-Host "Create $mdFileName -> $FileNewPath"

        if ($FileType.Contains("DUT")) {
            $Content = Read-TypeFile -Path $strPath -File $strFile -OutputFullPath $FileNewPath -DocRoot $destinationFull
        } elseif ($FileType.Contains("POU")) {
            $ParseResult = Read-SourceFile-XML -Path $strPath -File $strFile -OutputFullPath $FileNewPath -DocRoot $destinationFull
            $Content = $ParseResult.Content
        } elseif ($FileType.Contains("GVL")) {
            $Content = "# $strFile (GVL)`n`n*Automatic parsing for GVL files is not yet implemented.*"
        }

        # Determine the relative link path from Destination root (for overview lists)
        $RelativeFolderPath = ($FolderNew.Replace($destinationFull, "") -replace '^[\\/]+','').Replace('\','/')
        $LinkPath = if ($RelativeFolderPath.Length -gt 0) { "$RelativeFolderPath/$mdFileName" } else { $mdFileName }

        if ($FileType.Contains("DUT")) {
            $global:TypesOverview += $LinkPath
        }
        if ($FileType.Contains("POU")) {
            if ($ParseResult -and $ParseResult.POUType -eq 'Function') { $global:Functions += $LinkPath }
            else { $global:FunctionBlocks += $LinkPath }
        }

        # After creating a POU doc, register it in POUMap (so subsequent docs can link to it)
        if ($FileType.Contains("POU")) {
            # derive POU name from the parsed XML (if ParseResult exists) or from filename fallback
            $pouName = $null
            try {
                if ($ParseResult -and ($ParseResult.Content)) {
                    # Try to extract the title (# POUName) as best-effort fallback
                    if ($ParseResult.Content -match '^#\s*(?<Name>[^\r\n]+)') {
                        $pouName = $Matches['Name'].Trim()
                    }
                }
            } catch { }

            # If we couldn't extract pouName from content, try reading XML to get actual POU name
            if (-not $pouName) {
                try {
                    [xml]$tmpXml = Get-Content -Path (Join-Path $strPath $strFile) -Encoding UTF8 -Raw
                    if ($tmpXml.TcPlcObject.POU) { $pouName = $tmpXml.TcPlcObject.POU.Name }
                } catch { }
            }

            if ($pouName) {
                # register absolute full path in POUMap
                $abs = [System.IO.Path]::GetFullPath($FileNewPath)
                if (-not $global:POUMap.ContainsKey($pouName)) {
                    $global:POUMap.Add($pouName, $abs)
                }
            }
        }

        # Write file
        if ($Content -is [string]) {
            Set-Content -Path $FileNewPath -Value $Content -Encoding UTF8
        } else {
            Set-Content -Path $FileNewPath -Value ($Content | Out-String) -Encoding UTF8
        }
    }
}

# -------------------
# Create Overview (sorted)
# -------------------
function New-Overview {
    param([string] $Destination)

    Write-Host "Create Overview"

    if (-not (Test-Path $Destination)) {
        New-Item -Path $Destination -ItemType Directory -Force | Out-Null
    }

    $overviewPath = Join-Path $Destination "00_Overview.md"
    $strContent = ""

    $strContent += "# Functionblocks`n`n"
    $index = 1
    foreach ($element in ($global:FunctionBlocks | Sort-Object)) {
        $strFunction = $element
        if ($element -match '(?<Index>[0-9][0-9][0-9]*_)(?<Filename>.*)') {
            $strPath = Split-Path -Parent $strFunction
            $strFunction = $strFunction.Replace($Matches["Index"], "").Replace(".md","").Replace("$strPath/","")
        }
        $strContent += " $index. [$strFunction]($element)`n"
        $index++
    }

    $strContent += "`n`n`n# Functions`n`n"
    $index = 1
    foreach ($element in ($global:Functions | Sort-Object)) {
        $strFunction = $element
        if ($element -match '(?<Index>[0-9][0-9][0-9]*_)(?<Filename>.*)') {
            $strPath = Split-Path -Parent $strFunction
            $strFunction = $strFunction.Replace($Matches["Index"], "").Replace(".md","").Replace("$strPath/","")
        }
        $strContent += " $index. [$strFunction]($element)`n"
        $index++
    }

    $strContent += "`n`n`n# Datatypes`n`n"
    $index = 1
    foreach ($element in ($global:TypesOverview | Sort-Object)) {
        $strFunction = $element
        if ($element -match '(?<Index>[0-9][0-9][0-9]*_)(?<Filename>.*)') {
            $strPath = Split-Path -Parent $strFunction
            $strFunction = $strFunction.Replace($Matches["Index"], "").Replace(".md","").Replace("$strPath/","")
        }
        $strContent += " $index. [$strFunction]($element)`n"
        $index++
    }

    Set-Content -Path $overviewPath -Value $strContent -Encoding UTF8
}

# -------------------
# Main Execution
# -------------------
# Determine project root (git root)
$strProject = Get-GitRoot

if (-not $strProject) {
    Write-Error "Could not determine project root. Please run from repository or set manually."
    exit 1
}

Write-Host "Project root detected: $strProject"

# Default export folder under project
$strExport = Join-Path $strProject 'doc'

# Create TypeMap (DUT) and POUMap (POU) so links can be resolved before file generation
Create-TypeMap -Path $strProject -Destination $strExport -Subfolder
Create-PouMap  -Path $strProject -Destination $strExport -Subfolder

# Generate docs
New-Documentation -Path $strProject -FileType "TcDUT" -Destination $strExport -Subfolder -Structured
New-Documentation -Path $strProject -FileType "TcPOU" -Destination $strExport -Subfolder -Structured

# Make overview
New-Overview -Destination $strExport

Write-Host "Documentation generated to $strExport"