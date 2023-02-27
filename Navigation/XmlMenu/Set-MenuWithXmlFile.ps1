<#
    .SYNOPSIS
    Creates a menu from XML file

    .DESCRIPTION
    Loads a provided XML file and create a user menu.  Loads function associated with item and any parameters

    .PARAMETER MenuType
    section of menu to load

    .PARAMETER Submenu
    String of text to as subheaders in the menu

    .OUTPUTS
    Menu items loaded from the XML file

    .LINK
    https://automatethejob.com

    .EXAMPLE
    [xml]$XMLDocument = Get-Content -Path ".\Menu.xml"
    Set-Menu -MenuType "Main" -SubMenu "NO"

    .NOTES
    NAME: Set-MenuWithJson.ps1
    VERSION: 1.0
    Author: Daniel Rumeo
#>

Function Set-Menu
{
    Param([String]$MenuType, [String]$SubMenu)

    cls
    $Category = $XMLDocument.Menu.Item | Where-Object {$_.MenuPlacement -eq $MenuType}

    $MenuArray = @()
    
    $ctr = 1
    If($SubMenu -eq "Yes")
    {
        $MenuItems     = $XMLDocument.Menu.Item | Where-Object {$_.MenuPlacement -eq $MenuType }
        $SubCategories = $XMLDocument.Menu.Item | Where-Object {$_.MenuPlacement -eq $MenuType } | Select-Object Sub -Unique

        ForEach($SubCategory in $SubCategories)
        {
            Write-Host "`n$($SubCategory.Sub)" -ForegroundColor Green

            ForEach($item in $menuItems | Where-Object {$_.Sub -eq $SubCategory.Sub})
            {
                If($Item.Name -eq "Quit")
                {
                    $Key = "q"
                }
                Else
                {
                    $Key = $ctr
                    $ctr++
                }

                $MenuObject = New-Object psobject
                $MenuObject | Add-Member -MemberType NoteProperty -Name "Num" -Value $Key
                $MenuObject | Add-Member -MemberType NoteProperty -Name "Name" -Value $Item.Name
                $MenuObject | Add-Member -MemberType NoteProperty -Name "Function" -Value $Item.Function
                $MenuObject | Add-Member -MemberType NoteProperty -Name "Parameters" -Value $Item.Parameter
                $MenuArray += $MenuObject

                Write-Host "$($Key): Press '$Key' " -NoNewline
                Write-Host $Item.Name
            }
        }
    }
    Else
    {
        ForEach($Item in $Category)
        {
            Switch($Item.Name)
            {
                "Quit"
                {
                    Write-Host ""
                    $Key = "q"
                }

                Default
                {
                    $Key = $ctr
                    $ctr++
                }
            }

            $MenuObject = New-Object psobject
            $MenuObject | Add-Member -MemberType NoteProperty -Name "Num" -Value $Key
            $MenuObject | Add-Member -MemberType NoteProperty -Name "Name" -Value $Item.Name
            $MenuObject | Add-Member -MemberType NoteProperty -Name "Function" -Value $Item.Function
            $MenuObject | Add-Member -MemberType NoteProperty -Name "Parameters" -Value $Item.Parameter
            $MenuArray += $MenuObject

            Write-Host "$($Key): Press '$Key' " -NoNewline
            Write-Host $Item.Name
        }
    }

    Do
    {
        $userInput = Read-Host "Please make a selection"
        $selectionArray = 1..$MenuArray.Count
        $selection = $MenuArray | Where-Object {$_.Num -eq $userInput} | Select Name, Sub, Function, Parameters
        Write-Host $selection
        Invoke-Expression "$($selection.Function) $($selection.Parameters)"

    }Until (($userInput -eq 'q') -or ($userInput -in $selectionArray))

    Set-Menu -MenuType "Main" -SubMenu "NO"
}

[xml]$XMLDocument = Get-Content -Path ".\Menu.xml"
Set-Menu -MenuType "Main" -SubMenu "NO"