<# 
 .Synopsis
  Create a new post in a jekyll website using the supplied headers.

 .Description
  Creates a new post in a jekyll website using the supplied headers. 

 .Example
   # Create a new post file with the given post tile.
   Jekyll-New-Post -Title "New Update"
#>

function Jekyll-New-Post{
[CmdletBinding(DefaultParametersetName='None')]
param(
    [Parameter(Position=0, Mandatory=$True)] [string]$Title,
    [Parameter(Position=1, Mandatory=$True)] [string]$Layout,
    [Parameter(Position=2, Mandatory=$False)] [DateTime]$Date = [DateTime]::Now,
    [Parameter(Position=3, Mandatory=$True)] [string]$Category,
    [Parameter(Position=4, Mandatory=$False)] [string]$Tags,
    [Parameter(Position=5, Mandatory=$False)] [switch]$OpenToEdit,
    [Parameter(Position=6, Mandatory=$False)] [switch]$Commit,
    [Parameter(Position=7, Mandatory=$False)] [switch]$Push,
    [Parameter(Position=8, Mandatory=$False)] [switch]$Force,
    [Parameter(ParameterSetName='Directory', Mandatory=$False)] [switch]$ToDirectory,
    [Parameter(ParameterSetName='Directory', Mandatory=$True)] [string]$Directory
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
    $postTitle = (Get-Culture).TextInfo.ToTitleCase($Title)
    
    $output = "---`r`n" +
    "title: `"${postTitle}`"`r`n"+
    "layout: ${layout}`r`n" +
    "date: ${dateVar} `r`n"
    if($Category)
    {
        $output += "category: ${Category}`r`n"
    }
    if($tags)
    {
        $output += "tags: ${tags}`r`n"
    }
    $output += "---"
    
    $filename = $dateVarFile + "-" + $Title.ToLower().Replace(' ','-') +".md"

    if($ToDirectory)
    {
        $filename = $Directory + "/" + $filename
    }
    
    if(-not (test-path $filename) -or $Force)
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
        git commit -m ("added new post: " + $postTitle)
        if($Push)
        {
            git push origin
        }
    }
}