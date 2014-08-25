<# 
 .Synopsis
  Create a new post in a jekyll website using the supplied headers.

 .Description
  Creates a new post in a jekyll website using the supplied headers. 

 .Example
   # Create a new post file with the given post tile.
   Jekyll-New-Post -Title "New Update"
#>

function Jekyll-New-Post {
[CmdletBinding()]
param(
    [Parameter(Mandatory=$True,Position=1)]
    [string] $Title = [DateTime]::Today,
    
    [Parameter(Mandatory=$True)]
    [string] $Layout,
    
    [DateTime] $Date = [DateTime]::Now,
    
    [string] $Category,
    
    [string] $Tags,
    
    [Parameter(ParameterSetName='Directory')]
    [switch] $ToDirectory,
    
    [Parameter(ParameterSetName='Directory', Mandatory=$True)]
    [string] $Directory,
    
    [switch] $OpenToEdit,
    
    [Parameter(ParameterSetName='Git')]
    [switch] $Commit,
    
    [Parameter(ParameterSetName='Git')]
    [switch] $Push
    )
    
    if($ToDirectory)
    {
        if(-Not (test-path $Directory))
        {
            echo "Invalid directory!"
            return
        }
    }
    
    $dateVar = Get-Date $Date -format "yyyy-MM-d HH:mm:ss"
    $dateVarFile = Get-Date $Date -format "yyyy-MM-d"
    
    $output = "---`r`n" +
    "title: " + "`"" + (Get-Culture).TextInfo.ToTitleCase($Title) + "`"`r`n"+
    "layout: " + $layout +"`r`n" +
    "date: " + $dateVar + "`r`n"
    if($Category)
    {
        $output += "category: " + $Category + "`r`n"
    }
    if($tags)
    {
        $output += "tags: `"" + $tags + "`"`r`n"
    }
    $output += "---"
    
    $filename = $dateVarFile + "-" + $Title.ToLower().Replace(' ','-') +".md"

    if($ToDirectory)
    {
        $filename = $Directory + "/" + $filename
    }
    
    if(-not (test-path $filename))
    {
        $output | Out-File -Encoding "UTF8" $filename
    }

    if($OpenToEdit)
    {
        Start-Process -wait $filename
    }
    
    if($Commit)
    {
        git checkout -b $Title.ToLower().Replace(' ','-')
        git add .
        git commit -m ("added new post: " + (Get-Culture).TextInfo.ToTitleCase($Title))
        if($Push)
        {
            git push origin
        }
    }


}
export-modulemember -function Jekyll-New-Post