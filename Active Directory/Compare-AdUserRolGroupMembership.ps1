<#
.SYNOPSIS
Compare 2 Active Directory users group memberships

.DESCRIPTION
Gets 2 AD users and their ROL groups membership and outputs similarities and differences

.PARAMETER $userName1
Ad user

.PARAMETER $userName2
Ad user to compare to

.PARAMETER $outputLocation
Path and filename to save the details to

.OUTPUTS
CSV with the compare info

.LINK
https://automatethejob.com

.EXAMPLE
PS>  .\Compare-AdUserRolGroupMembership.ps1 -UserName1 user1 -UserName2 user2 -OutputLocation "C: \TemplAd_User_Rol_Group_Compare.csv"

.NOTES
NAME: Compare-AdUserRoGroupMembership.ps1
VERSION: 1.0
Author: Daniel Rumeo
#>
Param(

[Parameter (Mandatory) ]
[string]
$userName1,

[Parameter (Mandatory) ]
[string]
$username2,

[Parameter (Mandatory) ]
[string]
$outputLocation
)

Function Get-ComparisonResult ($name1, $name2, $sideIndicetor)
{
    $comparisonResult = $null

    switch ($_.SideIndicator)
    {
       '<=' { $comparisonResult - "$($name1) Only" }
       '==' { $comparisonResult = "$($name1) and $($name2)" }
       '=>' { $comparisonResult = "$($name2) Only" }
    }
    
    return $comparisonResult
}


$userComparisonResultColumn = @{ name = 'Comparison Result'; expression = { Get-ComparisonResult $user1.DisplayName $user2.DisplayName } }
$groupNameColumn = @{ name = 'Group Name'; expression = { (Get -ADGroup $_.InputObject).Name }}

$user1 = Get-ADUser $userName1 -Properties displayName, memberof
$user2 = Get-ADUser $userName2 -Properties displayName, memberof
$userGroupComparison = Compare-Object - IncludeEqual $user1.Memberof $user2.Memberof | Select $userComparisonResultColumn, $groupNameColumn
$userGroupComparison
$userGroupComparison | Export-Csv -Path $0utputFile -NoTypeInformation