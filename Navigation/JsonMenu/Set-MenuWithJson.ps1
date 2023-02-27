<#
    .SYNOPSIS
    Creates a menu from JSON file

    .DESCRIPTION
    Loads a provided JSON file and create a user menu.  Once it gets to menu item with no sub, will launch the function part of the menu

    .PARAMETER JsonSection
    Part of JSON to use as display menu

    .PARAMETER Title
    String of text to show in menu title

    .OUTPUTS
    Menu items loaded from the JSON file

    .LINK
    https://automatethejob.com

    .EXAMPLE
    Set-Menu -JsonSection $JsonPayload.Menu -Title "Main"

    .NOTES
    NAME: Set-MenuWithJson.ps1
    VERSION: 1.0
    Author: Daniel Rumeo
#>

Function Set-Menu
{
    Param($JsonSection, [String]$Title)

    cls
    $ctr = 1
    $menuArray = @()
    $payload = $NULL

    Write-Host "`n`n Menu Item - $Title`n"

    ForEach($item in $JsonSection.Name)
    {
        $key = $ctr
        $ctr++
        $menuObject = New-Object psobject
        $menuObject | Add-Member -MemberType NoteProperty -Name "Num" -Value $key
        $menuObject | Add-Member -MemberType NoteProperty -Name "Name" -Value $item
        $menuArray += $menuObject

        Write-Host "$key. " -NoNewline
        Write-Host $item
    }

        Write-Host "`nq. back to main menu" -NoNewline

    $userSelection = Read-Host "`n`nPlease make a selection"

    If ($userSelection -eq "q")
    {
        Set-Menu -JsonSection $JsonPayload.Menu -Title "Main"
    }
    Else
    {
        $Selection = $menuArray | Where-Object {$_. Num -eq $userSelection}
        $payload = $JsonSection | ? {$_. Name -eq $Selection.Name} #| Select-Object Sub
        If ($payload.Sub -ne $NULL)
        {
            Set-Menu -JsonSection $payload.sub -Title $selection.Name
        }
        Else
        {
            
            Invoke-Expression "$($payload.Function)"
            pause
            Set-Menu -JsonSection $JsonPayload.Menu -Title "Main"
        }
    }
}

$JsonPayload =  Get-Content -Path .\Menu.json | ConvertFrom-Json
Set-Menu -JsonSection $JsonPayload.Menu -Title "Main"