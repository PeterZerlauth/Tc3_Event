cls

$strProject = 'C:\source\repos\Tc3_Logging' # change this lines for your Project
$strExport  = 'C:\source\repos\Tc3_Logging\doc' # add folder for the md-files
 
# --- Original Regex (some still used by Read-TypeFile) ---
$RegExBegin           = '<(Method|Action|Property|Get) Name="'
$RegexName            = '(?s).(.*?)'
$RegexEnd             = '" Id='
$Regex                = "(?s)(?=($RegExBegin))($RegExName)(?=($RegExEnd))"
 
$RegexReturn          = '(?<Method>%Name) *: *(?<Return>\S*)'
$RegexComment         = '(?<Start>\/\/ *)(?<Value>.*)'
$RegexCommentBegin    = '(?<Start>\(\*\* +)(?<Line>.*)'
$RegexCommentEnd      = '(?<Line>.*?)(?<End> *\*\*\))'
$RegexNumber          = '(?<Index>[0-9][0-9][0-9]*_)(?<Filename>.*)'
 
$RegExType           = '(?<KEY>TYPE ).*?(?<Name>[A-z_]*)(?<Ending>.*:)'
$RegExElement        = '(?<Variable>\S*)\s*: *(?<Type>\S*)'
$RegExEnum           = '(?<Variable>\S*)\s*(?<Init>:= *(?<Value>[0-9]))*(?<End>,)'
$RegexVariable       = '(?<Variable>\S*)\s*:\s*(?<Type>[A-z_.]*)'
 
$overview = @();
$TypesOverview = @();
$SourceOverview = @() # <--- ADD THIS LINE
$global:TypesMap = @{} # Ensure global map is initialized

 # +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Entrypoint for documentation
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function New-Documentation
{
    param(
        [string] $Path,
        [string] $FileType,
        [string] $Destination,
        [switch] $Subfolder,
        [switch] $Structured
    )
 
    $index = 0
    $Filter = "*.$FileType"
    $strSubfolder = ""
 
    if ($FileType.contains("DUT"))
    {
        Write-Host "Create datatypes..."
        if ($Subfolder)
        {
            $strSubfolder = "Types"
        }
    }
    if ($FileType.contains("POU"))
    {
        Write-Host "Create sources..."
        if ($Subfolder)
        {
            $strSubfolder = "Source"
        }
    }
    if ($FileType.contains("GVL"))
    {
        Write-Host "Create variables..."
        if ($Subfolder)
        {
            $strSubfolder += "\Variables"
        }
    }
 
    Get-ChildItem -Path $Path -Recurse -Filter $Filter | % {
 
      $index++
      $strPath = Split-Path -Parent $_.fullname
      $strFile = Split-Path -Leaf $_.fullname
 
      if ($FileType.contains("DUT"))
      {
        $Content = Read-TypeFile -Path $strPath -File $strFile
      }
      if ($FileType.contains("POU"))
      {
        $Content = Read-SourceFile-XML -Path $strPath -File $strFile
      }
      if ($FileType.contains("GVL"))
      {
        # GVL parsing was not defined, so we'll just skip it for now
        # $Content = Read-SourceFile -Path $strPath -File $strFile
        $Content = "# $strFile (GVL)`n`n*Automatic parsing for GVL files is not yet implemented.*"
      }
     
      $FileNew = ""
    
      if ($index -lt 10)
      {
        $FileNew = "0"
      }
 
      $FileNew += $index.ToString() + "_" + $strFile.Replace($FileType, "md")
    
     
      $FolderNew = "$Destination\$strSubfolder";
 
      if ($Structured -eq $true)
      {
          $FolderNew += $strPath.Replace($Path,"")
      }
 
      # Ensure the directory exists before creating the file
      if (-not (Test-Path $FolderNew)) {
          New-Item -Path $FolderNew -ItemType Directory -Force | Out-Null
      }

      Write-Host "Create $FileNew"
 
      $temp = New-Item -Path $FolderNew -Name $FileNew -Force
 
      if ($FileType.contains("DUT"))
      {
        # --- FIX: Use forward slashes for the link path ---
        $global:TypesOverview += ("$strSubfolder\$FileNew").Replace("\", "/")
      }
      if ($FileType.contains("POU"))
      {
        # --- FIX: Use forward slashes for the link path ---
        $global:SourceOverview += ("$strSubfolder\$FileNew").Replace("\", "/")
      }
     
      Set-Content -Path "$FolderNew\$FileNew" -Value $Content -Encoding UTF8   
 
    }
 
}

 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Entrypoint for documentation
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function New-Overview
{
 
    param(
        [string] $Destination
    )
 
    Write-Host "Create Overview"
 
    # Ensure the directory exists
    if (-not (Test-Path $Destination)) {
        New-Item -Path $Destination -ItemType Directory -Force | Out-Null
    }

    $temp = New-Item -Path $Destination -Name "00_Overview.md" -Force
 
    $strContent = "# Functionblocks`n`n"
    $index = 1
 
    foreach($element in $global:SourceOverview)
    {
      $strFunction = $element
      if ($element -match $RegexNumber)
      {
         $strPath = Split-Path -Parent $strFunction
 
         $strFunction = $strFunction.Replace($Matches["Index"], "")
         $strFunction = $strFunction.Replace(".md", "")
         $strFunction = $strFunction.Replace("$strPath\", "")
      }
 
      $strContent += " $index. [$strFunction]($element)`n"
      $index++
    }
 
    $strContent += "`n`n# Datatypes`n`n"
    $index = 1
 
    foreach($element in $global:TypesOverview)
    {
      $strFunction = $element
      if ($element -match $RegexNumber)
      {
         $strPath = Split-Path -Parent $strFunction
 
         $strFunction = $strFunction.Replace($Matches["Index"], "")
         $strFunction = $strFunction.Replace(".md", "")
         $strFunction = $strFunction.Replace("$strPath\", "")
      }
 
      $strContent += " $index. [$strFunction]($element)`n"
      $index++
    }
 
    Set-Content -Path "$Destination\00_Overview.md" -Value $strContent -Encoding UTF8
}
 

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# NEW HELPER: Parses ST declaration text into Markdown tables
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function Convert-DeclarationToMarkdown {
    param([string]$Declaration)

    $lines = $Declaration.Split([Environment]::NewLine)
    
    # Use HashtaBLES for ordered parsing
    $inputs = [ordered]@{}
    $outputs = [ordered]@{}
    $vars = [ordered]@{}
    $currentSection = 'NONE'
    $pendingComment = ''

    # This Regex is more robust. It captures Name, Type, optional Default, and optional inline Comment.
    $VarRegex = '^\s*(?<Name>\w+)\s*:\s*(?<Type>[\w\._\(\)]+)\s*(?:(?::=)\s*(?<Default>.*?))?\s*;?\s*(?:\/\/\s*(?<Comment>.*))?'

    foreach ($line in $lines) {
        $trimmedLine = $line.Trim()

        # Capture comments that appear on their *own* line before a variable
        if ($trimmedLine -match '^\/\/\s*(?<Value>.*)') {
            $pendingComment = $Matches['Value'].Trim()
            continue # This was a comment line, skip to next line
        }
        if ($trimmedLine -match '^\(\*\s*(?<Value>.*?)\s*\*\)') {
            $pendingComment = $Matches['Value'].Trim()
            continue # This was a comment line, skip to next line
        }

        # State transitions for sections
        if ($trimmedLine.StartsWith('VAR_INPUT')) { $currentSection = 'INPUT'; continue }
        if ($trimmedLine.StartsWith('VAR_OUTPUT')) { $currentSection = 'OUTPUT'; continue }
        if ($trimmedLine.StartsWith('VAR') -and -not $trimmedLine.StartsWith('VAR_')) { $currentSection = 'VAR'; continue }
        if ($trimmedLine.StartsWith('END_VAR')) { $currentSection = 'NONE'; $pendingComment = ''; continue }
        
        # Variable parsing
        if ($trimmedLine -match $VarRegex) {
            $varName = $Matches['Name']
            $varType = $Matches['Type']
            $varDefault = ""

            if ($Matches['Default']) {
                $varDefault = $Matches['Default'].Trim()
            }
            
            # Use the pending comment *or* the inline comment
            $varComment = $pendingComment
            if ($Matches['Comment'] -and $Matches['Comment'].Trim()) {
                $varComment = $Matches['Comment'].Trim()
            }

            # Linkify the Type if it's in our global map
            $linkedType = $varType
            if ($global:TypesMap.ContainsKey($varType)) {
                # --- FIX: Path needs to go up one level
                $relativePath = $global:TypesMap[$varType].Replace("Types/", "../Types/") 
                $linkedType = "[$varType]($relativePath)"
            }

            $varObj = [PSCustomObject]@{
                Name = $varName
                Type = $linkedType # Use the (potentially) linked type
                Default = $varDefault
                Comment = $varComment.Replace('|', '\|') # Escape pipes for Markdown tables
            }

            # Add to the correct dictionary
            switch ($currentSection) {
                'INPUT'  { if (-not $inputs.Contains($varName)) { $inputs.Add($varName, $varObj) } }
                'OUTPUT' { if (-not $outputs.Contains($varName)) { $outputs.Add($varName, $varObj) } }
                'VAR'    { if (-not $vars.Contains($varName)) { $vars.Add($varName, $varObj) } }
            }

            $pendingComment = '' # Reset comment after it's "used" by a variable
        }
    }

    # --- Build Markdown Output ---
    $md = ""

    if ($inputs.Count -gt 0) {
        $md += "### VAR_INPUT`n"
        # Check if any inputs have a default value
        $hasDefaults = ($inputs.Values.Default | Where-Object { $_.Length -gt 0 }).Count -gt 0
        
        if ($hasDefaults) {
             $md += "| Name | Type | Default | Description |`n"
             $md += "| :--- | :--- | :--- | :--- |`n"
             foreach ($var in $inputs.Values) {
                  $md += "| `$($var.Name)` | `$($var.Type)` | `$($var.Default)` | $($var.Comment) |`n"
              }
        } else {
             $md += "| Name | Type | Description |`n"
             $md += "| :--- | :--- | :--- |`n"
             foreach ($var in $inputs.Values) { 
                $md += "| `$($var.Name)` | `$($var.Type)` | $($var.Comment) |`n"
             }
        }
        $md += "`n"
    }
    
    if ($outputs.Count -gt 0) {
        $md += "### VAR_OUTPUT`n"
        $md += "| Name | Type | Description |`n"
        $md += "| :--- | :--- | :--- |`n"
        foreach ($var in $outputs.Values) { 
            $md += "| `$($var.Name)` | `$($var.Type)` | $($var.Comment) |`n"
        }
        $md += "`n"
    }

    if ($vars.Count -gt 0) {
        $md += "### VAR`n"
        $md += "| Name | Type | Description |`n"
        $md += "| :--- | :--- | :--- |`n"
        foreach ($var in $vars.Values) { 
            $md += "| `$($var.Name)` | `$($var.Type)` | $($var.Comment) |`n"     
        }
            $md += "`n"
     }

    return $md
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Xml parser
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function Read-SourceFile-XML
{
    param(
        [string] $Path,
        [string] $File      
    )
 
    Write-Host "Parsing (XML) $File"
    
    # 1. Load the file as XML
    [xml]$xmlContent = Get-Content -Path (Join-Path $Path $File) -Encoding UTF8

    # 2. Get POU info directly from XML nodes
    $pou = $xmlContent.TcPlcObject.POU
    $pouName = $pou.Name
    $pouImplements = $pou.IMPLEMENTS
    
    # --- Build Header ---
    $strContent = "# $pouName`n"
    if ($pouImplements) {
        $strContent += "> **Implements:** `$pouImplements``n"
    }
    $strContent += "`n`n"

    # --- Parse Main Declaration ---
    # The CDATA section is just text, so we pass it to our ST parser
    $mainDeclarationText = $pou.Declaration.'#cdata-section'
    $strContent += "## Declaration (Variables)`n`n"
    $strContent += Convert-DeclarationToMarkdown -Declaration $mainDeclarationText
    $strContent += "`n"

    # --- Parse Methods ---
    if ($pou.Method) {
        $strContent += "`n`n## Methods`n`n"
        foreach ($method in $pou.Method) {
            $methodName = $method.Name
            $methodDeclarationText = $method.Declaration.'#cdata-section'
            
            $strContent += "### ### $methodName`n`n"
            
            # Get Return Type from the method declaration
            # <--- FIX: Use double-quotes to expand the $Matches variable
            if ($methodDeclarationText -match 'METHOD \w+ : (?<Return>[\w\._]+)') {
                $strContent += "**Returns:** `$($Matches['Return'])``n`n"
            } elseif ($methodName -eq 'FB_Init') {
                 $strContent += "**Returns:** `BOOL` (Implicit)`n`n"
            } else {
                 # <--- FIX: This method might not have a return, so just say (None)
                 $strContent += "**Returns:** `(None)`n`n"
            }

            # Get Description (simple version: finds all // comments)
            $commentLines = $methodDeclarationText.Split("`n") | 
                Where-Object { $_.Trim().StartsWith('//') } | 
                ForEach-Object { $_.Trim().Substring(2).Trim() }
            
            if ($commentLines) {
                # <--- FIX: Use double-quotes to ensure `n is treated as a newline
                $strContent += ($commentLines -join " `n") + "`n`n"
            }

            # Get Method-Specific Vars (VAR_INPUT, etc.)
            $strContent += Convert-DeclarationToMarkdown -Declaration $methodDeclarationText
        }
    }

    # --- Parse Properties ---
    if ($pou.Property) {
        $strContent += "`n`n##Properties`n`n"
        foreach ($prop in $pou.Property) {
            $propName = $prop.Name
            $propDeclarationText = $prop.Declaration.'#cdata-section'

            $strContent += "### ### $propName`n`n"
            
            # Get Property Type
            if ($propDeclarationText -match 'PROPERTY .* : (?<Type>[\w\._]+)') {
                $propType = $Matches['Type'].Trim()
                
                # Linkify Type
                if ($global:TypesMap.ContainsKey($propType)) {
                    # <--- FIX: This path was wrong. It should go *up* from Source/ to Types/
                    $relativePath = $global:TypesMap[$propType].Replace("Types/", "../Types/")
                    $propType = "[$propType]($relativePath)"
                }
                # <--- FIX: Use double-quotes to expand the $propType variable
                $strContent += "**Type:** `$propType``n`n"
            }

            if ($prop.Get) { $strContent += "* **Get:** Available`n" }
            if ($prop.Set) { $strContent += "* **Set:** Available`n" }
            $strContent += "`n"
        }
    }
    
    return $strContent
}
 

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Get content of tcDUT File
# REBUILT to use robust XML parsing instead of fragile Regex.
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function Read-TypeFile
{
    param(
        [string] $Path,
        [string] $File      
    )
 
    Write-Host "Parsing (XML) $File "
    
    [xml]$xmlContent = Get-Content -Path (Join-Path $Path $File) -Encoding UTF8
    
    # Handle missing DUT node gracefully
    if (-not $xmlContent.TcPlcObject.DUT) {
        Write-Warning "File $File does not appear to be a valid DUT file."
        return "# $File`n`n*Error: Could not parse file as DUT.*"
    }

    $declaration = $xmlContent.TcPlcObject.DUT.Declaration.'#cdata-section'
    
    $typeName = ""
    $isStruct = $declaration.Contains("STRUCT")
    $isEnum = $declaration.Contains("(") -and -not $isStruct # A simple check for ENUMs
    $strContent = ""

    # Get the Type name
    if ($declaration -match 'TYPE\s+(?<Name>\w+)\s*:') {
        $typeName = $Matches['Name']
    }

    $strContent += "# $typeName`n`n"

    if ($isStruct) {
        $strContent += "| Name | Type | Comment |`n"
        $strContent += "| :--- | :--- | :--- |`n"
    } else { # Likely ENUM
        $strContent += "| Name | Value | Comment |`n"
        $strContent += "| :--- | :--- | :--- |`n"
    }

    $lines = $declaration.Split([Environment]::NewLine)
    $pendingComment = ""
    
    # Regex to capture variables/members
    $VarRegex = '^\s*(?<Name>\w+)\s*:\s*(?<Type>[\w\._\(\)]+)\s*;?\s*(?:\/\/\s*(?<Comment>.*))?'
    # Regex to capture ENUMs
    $EnumRegex = '^\s*(?<Name>\w+)\s*(?:\(:(=\s*)?(?<Value>\d+)\))?[,;]?\s*(?:\/\/\s*(?<Comment>.*))?'

    foreach ($line in $lines) {
        $trimmedLine = $line.Trim()

        # Skip start/end
        if ($trimmedLine.StartsWith("TYPE") -or $trimmedLine.StartsWith("END_TYPE")) { continue }
        if ($trimmedLine.StartsWith("STRUCT") -or $trimmedLine.StartsWith("END_STRUCT")) { continue }

        # Capture comments
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

            # Linkify Type
            $linkedType = $varType
            if ($global:TypesMap.ContainsKey($varType)) {
                # <--- FIX: This path was also wrong.
                $relativePath = $global:TypesMap[$varType].Replace("Types/", "") 
                $linkedType = "[$varType]($relativePath)"
            }
            
            $row = "| `$varName` | `$linkedType` | $varComment |"

        } elseif (-not $isStruct -and ($trimmedLine -match $EnumRegex)) {
            $varName = $Matches['Name']
            $varValue = $Matches['Value']
            $varComment = $pendingComment
            if ($Matches['Comment']) { $varComment = $Matches['Comment'].Trim() }
            
            if (-not $varValue) { $varValue = "..." } # Auto-incremented
            
            $row = "| `$varName` | `$varValue` | $varComment |"
        }
        
        if ($row) {
            $strContent += $row + "`n"
            $pendingComment = "" # Reset comment
        }
    }
 
    return $strContent
}
 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Build type map for later resolution
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function Create-TypeMap
{
    param(
        [string] $Path,
        [switch] $Subfolder      
    )
 
    $index = 0
    Write-Host "Create global Type map..."
 
    Get-ChildItem -Path $Path -Recurse -Filter "*.TcDUT" | % {
 
      $index++
      $strPath = Split-Path -Parent $_.fullname
      $strFile = Split-Path -Leaf $_.fullname
 
      #Write-host $strFile
 
        [xml]$xmlContent = Get-Content -Path (Join-Path $strPath $strFile) -Encoding UTF8

        # Handle missing DUT node gracefully
        if (-not $xmlContent.TcPlcObject.DUT) {
            Write-Warning "File $strFile does not appear to be a valid DUT file. Skipping for TypeMap."
            return # 'return' in a ForEach-Object (%) loop acts like 'continue'
        }

        $declaration = $xmlContent.TcPlcObject.DUT.Declaration.'#cdata-section'
 
        $strSubfolder = ""
        if ($Subfolder)
        {
            $strSubfolder = "Types"
        }
 
        if ($declaration -match 'TYPE\s+(?<Name>\w+)\s*:')
        {
            $typeName = $Matches["Name"]
            $fileName = $index.ToString()
            if ($index -lt 10) { $fileName = "0" + $fileName }
            
            $filePath = "$strSubfolder\" + $fileName + "_" + $strFile.Replace("TcDUT", "md")
            
            # Use forward slashes for map paths
            $global:TypesMap[$typeName] = $filePath.Replace("\", "/")
        }
 
    }
}
 
# --- Main Execution ---
Create-TypeMap -Path $strProject -Subfolder
 
New-Documentation -Path $strProject -FileType "TcDUT" -Destination "$strExport" -Subfolder
 
New-Documentation -Path $strProject -FileType "TcPOU" -Destination "$strExport" -Subfolder
 
New-Overview -Destination $strExport