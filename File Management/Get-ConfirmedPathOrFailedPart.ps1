    <#
      .SYNOPSIS
      Path confirmation script.

      .DESCRIPTION
      Checks to see if the path exists but if it doesn't it tells you at which part of the path it fails

      .PARAMETER InputPath
      Folder or files path

      .INPUTS
      $PathToItem must include a file or folder path

      .OUTPUTS
      A) Entire path not found -> Output Red
      B) $PathToItem does not include $ErroredDir -> Output Yellow
      C) Path found -> Output Green

      .LINK
      https://automatethejob.com

      .EXAMPLE
      PS> .\Get-ConfirmedPathOrFailedPart.ps1 -PathToItem C:\Temp\Folder1\Folder2\TestItem.txt

      .NOTES
      NAME: Get-ConfirmedPathOrFailedPart.ps1
      VERSION: 1.0
      Author: Daniel Rumeo
    #>

    Param(

    [Parameter(Mandatory)]
    [string]
    $PathToItem

    )
    $ErroredDir = $NULL
    $CTR = 0
    [String]$PathVar = $PathToItem

    Do
    {
        $Found = "Yes"
        If(!(Test-Path $PathVar))
        {
            $ErroredDir = $PathVar
            $PathVar = Split-Path -Path $PathVar -Parent
            $Found ="NO"   
        }
        Else
        {
            $Found = "Yes"
        }

        $CTR++

    }Until(($Found -eq "Yes") -or ($PathVar -eq ""))

    If($PathVar -eq "")
    {
        Write-Host "Entire path NOT found" -ForegroundColor Red
    }
    ElseIf(($Found -eq "Yes") -and ($CTR -ge 2))
    {
        $IssueFolder = Split-Path -Path $ErroredDir -Leaf
        Write-Host "`n$PathToItem does not include " -NoNewline 
        Write-Host "$IssueFolder" -ForegroundColor Yellow
    }
    Else
    {
        Write-Host "Entire path found" -ForegroundColor Green
    }