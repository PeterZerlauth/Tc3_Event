
cls

$strProject = 'C:\source\repos\Tc3_Logging' # change this lines for your Project
$strExport  = 'C:\source\repos\Tc3_Logging\doc' # add folder for the md-files
 
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
        $Content = Read-SourceFile -Path $strPath -File $strFile
      }
      if ($FileType.contains("GVL"))
      {
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
# Get content of TcPOU File
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function Read-SourceFile
{
    param(
        [string] $Path,
        [string] $File      
    )
 
   
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
                    $strVarInput += Read-Variables($strLine)
                }
 
                if ($VarOutput -eq $true)
                {
                    $strVarOutput += Read-Variables($strLine)
                }
            }
 
 
        }
    }
 
    $strContent 
}
 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Get variables in TcPOU
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function Read-Variables()
{
    param(
        [string] $strLine
    )
 
    $strComment = ''
    $strData = ""
 
    if ($strLine -match $RegexComment)
    {                  
        $strComment += $Matches["value"]                  
    }
    if ($strLine -match $RegexVariable)
    {                  
        $strData += "|"+ $Matches["Variable"] + " |" + $Matches["Type"] + " |"+ $strComment + "| `n"
        $strData = $strData.Replace(';', '')
 
        if ($global:TypesMap.ContainsKey($Matches["Type"]))
        {
          $strLink = "[" + $Matches["Type"] + "](" + $global:TypesMap[$Matches["Type"]] + ")"
          $strData = $strData.Replace($Matches["Type"], $strLink)
        }
    }
 
    $strData
}
 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Get content of tcDUT File
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function Read-TypeFile
{
    param(
        [string] $Path,
        [string] $File      
    )
 
    Write-Host "Check Typefile $File "
    $Declaration = $false
    $strSource = Get-Content -Path "$Path\$File"
 
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
 
        $strSource = Get-Content -Path "$strPath\$strFile"
 
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
 
Create-TypeMap -Path $strProject -Subfolder
 
New-Documentation -Path $strProject -FileType "TcDUT" -Destination "$strExport" -Subfolder
 
New-Documentation -Path $strProject -FileType "TcPOU" -Destination "$strExport" -Subfolder
 
New-Overview -Destination $strExport