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
    
    [string[]] $Tags,
    
    [switch] $ToDirectory,
    
    [string] $Directory = $(
            if($ToDirectory)
            {
                $Directory = Read-Host -Prompt "Enter directory where to create file:"
                while(-Not (test-path $Directory))
                {
                    $Directory = Read-Host -Prompt "Not a valid path! Please enter a valid path:"
                }
            }
        ),
    [switch] $OpenToEdit
    )
    
    $dateVar = Get-Date $Date -format "yyyy-mm-d HH:mm:ss"
    $dateVarFile = Get-Date $Date -format "yyyy-mm-d"
    
    $output = "---`r`n" +
    "title: " + "`"" + (Get-Culture).TextInfo.ToTitleCase($Title) + "`"`r`n"+
    "layout: " + $layout +"`r`n" +
    "date: " + $dateVar + "`r`n" +
    "---"
    
    $filename = $dateVarFile + "-" + $Title.ToLower().Replace(' ','-') +".md"
    
    $output | Out-File $filename
}
export-modulemember -function Jekyll-New-Post