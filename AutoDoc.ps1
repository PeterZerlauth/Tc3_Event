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
        # --- NEW ---
        # Call the new, improved XML-based function
        $Content = Read-SourceFile-XML -Path $strPath -File $strFile
        # --- END NEW ---
      }
      if ($FileType.contains("GVL"))
      {
        # GVLs are also XML, this would need a similar new function
        # For now, use the old one as a fallback
        $Content = Read-SourceFile -Path $strPath -File $strFile
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
 
      Write-Host "Create $FileNew"
 
      $temp = New-Item -Path $FolderNew -Name $FileNew -Force
 
      if ($FileType.contains("DUT"))
      {
        $global:TypesOverview += "$strSubfolder\$FileNew";
      }
      if ($FileType.contains("POU"))
      {
        $global:SourceOverview += "$strSubfolder\$FileNew";
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
 
    $temp = New-Item -Path $Destination -Name "00_Overview.md" -Force
 
    $strContent = "[[_TOC_]]`n`n"
    $strContent += "# Functionblocks`n`n"
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
# This replaces the old Read-Variables function
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
            $varDefault = $Matches['Default'].Trim()
            
            # Use the pending comment *or* the inline comment
            $varComment = $pendingComment
            if ($Matches['Comment'] -and $Matches['Comment'].Trim()) {
                $varComment = $Matches['Comment'].Trim()
            }

            # Linkify the Type if it's in our global map
            $linkedType = $varType
            if ($global:TypesMap.ContainsKey($varType)) {
                # Create a relative path. Assumes Types and Source are siblings
                $relativePath = $global:TypesMap[$varType].Replace("Types\", "../Types/") 
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
                'INPUT'  { if (-not $inputs.ContainsKey($varName)) { $inputs.Add($varName, $varObj) } }
                'OUTPUT' { if (-not $outputs.ContainsKey($varName)) { $outputs.Add($varName, $varObj) } }
                'VAR'    { if (-not $vars.ContainsKey($varName)) { $vars.Add($varName, $varObj) } }
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
             foreach ($var in $inputs.Values) { $md += "| `$($var.Name)` | `$($var.Type)` | `$($var.Default)` | $($var.Comment) |`n" }
        } else {
             $md += "| Name | Type | Description |`n"
             $md += "| :--- | :--- | :--- |`n"
             foreach ($var in $inputs.Values) { $md += "| `$($var.Name)` | `$($var.Type)` | $($var.Comment) |`n" }
        }
        $md += "`n"
    }
    
    if ($outputs.Count -gt 0) {
        $md += "### VAR_OUTPUT`n"
        $md += "| Name | Type | Description |`n"
        $md += "| :--- | :--- | :--- |`n"
        foreach ($var in $outputs.Values) { $md += "| `$($var.Name)` | `$($var.Type)` | $($var.Comment) |`n" }
        $md += "`n"
    }

    if ($vars.Count -gt 0) {
        $md += "### VAR`n"
        $md += "| Name | Type | Description |`n"
        $md += "| :--- | :--- | :--- |`n"
        foreach ($var in $vars.Values) { $md += "| `$($var.Name)` | `$($var.Type)` | $($var.Comment) |`n" }
        $md += "`n"
    }

    return $md
}


# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# NEW Read-SourceFile function.
# This one parses the XML correctly.
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
    $strContent = "[[_TOC_]]`n`n"
    $strContent += "# $pouName`n"
    if ($pouImplements) {
        $strContent += "> **Implements:** `$pouImplements``n"
    }
    $strContent += "`n---\n`n"

    # --- Parse Main Declaration ---
    # The CDATA section is just text, so we pass it to our ST parser
    $mainDeclarationText = $pou.Declaration.'#cdata-section'
    $strContent += "## 📜 Declaration (Variables)`n`n"
    $strContent += Convert-DeclarationToMarkdown -Declaration $mainDeclarationText
    $strContent += "`n"

    # --- Parse Methods ---
    if ($pou.Method) {
        $strContent += "`n---\n`n## ⚙️ Methods`n`n"
        foreach ($method in $pou.Method) {
            $methodName = $method.Name
            $methodDeclarationText = $method.Declaration.'#cdata-section'
            
            $strContent += "### ### $methodName`n`n"
            
            # Get Return Type from the method declaration
            if ($methodDeclarationText -match 'METHOD \w+ : (?<Return>[\w\._]+)') {
                $strContent += "**Returns:** `$($Matches['Return'])``n`n"
            } elseif ($methodName -eq 'FB_Init') {
                 $strContent += "**Returns:** `BOOL` (Implicit)`n`n"
            } else {
                 $strContent += "**Returns:** `(None)`n`n"
            }

            # Get Description (simple version: finds all // comments)
            $commentLines = $methodDeclarationText.Split("`n") | 
                Where-Object { $_.Trim().StartsWith('//') } | 
                ForEach-Object { $_.Trim().Substring(2).Trim() }
            
            if ($commentLines) {
                $strContent += ($commentLines -join " `n") + "`n`n"
            }

            # Get Method-Specific Vars (VAR_INPUT, etc.)
            $strContent += Convert-DeclarationToMarkdown -Declaration $methodDeclarationText
        }
    }

    # --- Parse Properties ---
    if ($pou.Property) {
        $strContent += "`n---\n`n## 💎 Properties`n`n"
        foreach ($prop in $pou.Property) {
            $propName = $prop.Name
            $propDeclarationText = $prop.Declaration.'#cdata-section'

            $strContent += "### ### $propName`n`n"
            
            # Get Property Type
            if ($propDeclarationText -match 'PROPERTY .* : (?<Type>[\w\._]+)') {
                $propType = $Matches['Type'].Trim()
                
                # Linkify Type
                if ($global:TypesMap.ContainsKey($propType)) {
                    $relativePath = $global:TypesMap[$propType].Replace("Types\", "../Types/")
                    $propType = "[$propType]($relativePath)"
                }
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
# --- THIS IS THE OLD, UNRELIABLE FUNCTION ---
# I am leaving it here because your `New-Documentation` function still uses it
# for GVL files. It should be replaced with a new XML parser for GVLs eventually.
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function Read-SourceFile
{
    param(
        [string] $Path,
        [string] $File      
    )
 
    Write-Host "Parsing (Legacy) $File"
    $strContent = "[[_TOC_]]`n`n"
    $strContent += "## " + $File.Replace(".TcPOU", "") + "`n`n"
 
    $strSource = Get-Content -Path "$Path\$File"
 
    $strMethodType   = ""
    $strMethodName   = $File.Replace(".TcPOU", "")
    $strDescription  = $null
    $strReturnValue  = "- "
    $strInput        = $null
    $strOutput       = $null
    $strVarInput     = $null
    $DeclarationPart = $false
    $VarLocal        = $false
    $VarInput        = $false
    $VarOutput       = $false
    $strDescription  = '- '
    $Description     = $false
 
    foreach($strLine in $strSource)
    {
 
        if ($DeclarationPart -eq $false)
        {
 
            $strLine |
            Select-String $Regex -AllMatches |
            % { $_.Matches } |
            % {
                $strMethodType = "Method"
 
                if ($_.Value.Contains("Action") -eq $true)
                {
                    $strMethodType = "Action"
                }
 
                $strMethodName = $_.Value.Replace("<Method Name=`"","")
                $strMethodName = $strMethodName.Replace("<Action Name=`"","")
                $strMethodName = $strMethodName.Replace("<Property Name=`"","")
                $strMethodName = $strMethodName.Replace("<Get Name=`"","")
                $strContent += "### " + $strMethodType + " " + $strMethodName + "  `n"
              }
 
            if ($strLine.Contains('Declaration><![CDATA[') -eq $true)
            {
                $DeclarationPart = $true
                $strVarInput     = ''
                $strVarOutput    = ''
                $strDescription  = ''
            }
        }
        if ($DeclarationPart -eq $true)
        {
          
            if ($strLine.Contains(']]></Declaration>') -eq $true)
            {
                $DeclarationPart = $false
 
                $strContent += "returns : $strReturnValue  `n"
                $strContent += "#### Description  `n"
                $strContent += "$strDescription `n"          
                $strContent += "#### Input  `n"
                if ($strVarInput.Length -gt 2)
                {
                    $strContent += "|Name |Type |Comment| `n"
                    $strContent += "|---- |---- |----   | `n"
                }
                else
                {
                    $strVarInput = '- '
                }
 
                $strContent += $strVarInput + "`n"
                $strContent += "#### Output  `n"
                if ($strVarOutput.Length -gt 2)
                {
                    $strContent += "|Name |Type |Comment| `n"
                    $strContent += "|---- |---- |----   | `n"
                }
                else
                {
                    $strVarOutput = '- '
                }
 
                $strContent += $strVarOutput + "`n"
            }
 
            if ($VarInput -eq $false -and $VarOutput -eq $false -and $VarLocal -eq $false)
            {
                if ($Description -eq $false)
                {
                    if ($strLine -match $RegexComment)
                    {                  
                        $strDescription += $Matches["value"] +"  `n"                  
                    }
                    else
                    {
                        if ($strLine -match $RegexCommentBegin)
                        { 
                            $strDescription = ''          
                            $Description = $true                
                        }
                    }
                }
                else
                {
                    if ($strLine -match $RegexCommentEnd)
                    {                
                        $Description = $false                                       
                    }
                    else
                    {
                        $strDescription += $strLine + "  `n"
                    }                  
                }
 
                if ($strLine.Contains($strMethodName) -eq $true)
                {
                    if ($strLine -match $RegexReturn.Replace('%Name', $strMethodName))
                    {
                        $strReturnValue = $Matches["Return"] +"  `n"
                    }
                }
 
                if ($strLine.Contains("VAR ") -eq $true)
                {
                    $VarLocal = $true;
                }
                if ($strLine.Contains("VAR_INPUT") -eq $true)
                {
                    $VarInput = $true;
                }
                if ($strLine.Contains("VAR_OUTPUT") -eq $true)
                {
                    $VarOutput = $true;
                }
 
            }
            else
            {
                if ($strLine.Contains("END_VAR") -eq $true)
                {
                    $VarInput  = $false;
                    $VarOutput = $false;
                    $VarLocal  = $false;
                }
 
                if ($VarInput -eq $true)
                {
                    # This function no longer exists, this will fail
                    # $strVarInput += Read-Variables($strLine) 
                }
 
                if ($VarOutput -eq $true)
                {
                    # This function no longer exists, this will fail
                    # $strVarOutput += Read-Variables($strLine)
                }
            }
 
 
        }
    }
 
    $strContent 
}
 

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Get content of tcDUT File
# This function still uses Regex and could also be improved by parsing as XML.
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function Read-TypeFile
{
    param(
        [string] $Path,
        [string] $File      
    )
 
    Write-Host "Check Typefile $File "
    $Declaration = $false
    $strSource = Get-Content -Path "$Path\$File" -Encoding UTF8
 
    foreach($strLine in $strSource)
    {
 
        if ($strLine -match $RegExType)
        {
            Write-Host $strLine
            $Declaration = $true
 
            $strContent = "Type : " + $Matches["Name"] + "`n`n"
           
            if ($strSource.Contains("STRUCT"))
            {
                $strContent += "|Name |Type |Comment| `n"
            }
            else
            {
                $strContent += "|Name |Initvalue |Comment| `n"
            }
 
            $strContent += "|---- |---- |----   | `n"
        }
        else
        {
            if ($Declaration -eq $true)
            {
                if (-not $strLine.Contains("EXTENDS") -and -not $strLine.Contains("STRUCT"))
                {
                    if ($strLine -match $RegexEnum)
                    {
                        $strContent += "|%1 |%2 |%3   | `n"                                               
                        $strContent = $strContent.Replace("%1", $Matches["Variable"])
                        $strContent = $strContent.Replace("%2", $Matches["Value"])
                 
                    }
                    else
                    {
                        if ($strLine -match $RegexVariable)
                        {                              
                            $strTemp = "|%1 |%2 |%3   | `n"
                            $strTemp = $strTemp.Replace("%1", $Matches["Variable"])
                            $strTemp = $strTemp.Replace("%2", $Matches["Type"])
                         
                            if ($global:TypesMap.ContainsKey($Matches["Type"]))
                            {
                              $strLink = "[" + $Matches["Type"] + "](" + $global:TypesMap[$Matches["Type"]] + ")"
                              $strLink = $strLink.Replace("Types\", "")
                              $strTemp = $strTemp.Replace($Matches["Type"], $strLink)
                            }
                        
                            $strContent += $strTemp                                                
                        }
                    }
                    if ($strLine -match $RegexComment -or $strLine -match $RegexLineComment)
                    {                              
                         $strContent = $strContent.Replace("%3", $Matches["Value"])          
                    }
 
                    if ($strContent)
                    {
                        $strContent = $strContent.Replace("%3", "")
                    }  
                }
 
        
            }
 
            if ($strLine.Contains("END_TYPE") )
            {
                $Declaration = $false
                $strContent
                return
            }
           
                  
        }
       
    }
 
    $strContent
 
}
 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Build type map for later resolution
# This function is fine, but .TcDUT files are *also* XML, so this could
# be made more reliable by parsing the XML instead of Regex on text.
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
 
        $strSource = Get-Content -Path "$strPath\$strFile" -Encoding UTF8
 
        $strSubfolder = ""
        if ($Subfolder)
        {
            $strSubfolder = "Types"
        }
 
        foreach($strLine in $strSource)
        {
            if ($strLine -match $RegExType)
            {
                $global:TypesMap[$Matches["Name"]] = $strSubfolder + "\" + $index.ToString() + "_" + $strFile.Replace("TcDUT", "md")
            }
       
        }
 
    }
}
 
# --- Main Execution ---
Create-TypeMap -Path $strProject -Subfolder
 
New-Documentation -Path $strProject -FileType "TcDUT" -Destination "$strExport" -Subfolder
 
New-Documentation -Path $strProject -FileType "TcPOU" -Destination "$strExport" -Subfolder
 
New-Overview -Destination $strExport