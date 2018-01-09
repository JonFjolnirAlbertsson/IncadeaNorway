$ADuser = "incadea\albertssonf"
#$ADuserSQL = "si-data\jal"
#$ADuser = "si-data\jab123243"
$NavServiceInstance = "IncadeaAddOns"
$NavServiceInstance = "DynamicsNAV100"
$NavServiceInstance = "NAV100_TP"
$ADuser = "si-dev\devjal"

Set-ExecutionPolicy RemoteSigned -Force
Import-Module "C:\Program Files\Microsoft Dynamics NAV\100\Service CU03\NavAdminTool.ps1"
#Import-Module "${env:ProgramFiles(x86)}\Microsoft Dynamics NAV\100\RTC CU03\Microsoft.Dynamics.Nav.Model.Tools.psd1" 
#Import-Module "${env:ProgramFiles(x86)}\Microsoft Dynamics NAV\100\RTC CU03\Microsoft.Dynamics.Nav.Apps.Tools.psd1" 


Get-NAVServerInstance $NavServiceInstance | New-NAVServerUser -WindowsAccount $ADuser 
Get-NAVServerInstance $NavServiceInstance | New-NAVServerUserPermissionSet –WindowsAccount $ADuser -PermissionSetId SUPER -Verbose

#Get-NAVServerInstance $NavServiceInstance | New-NAVServerUser -WindowsAccount $ADuserSQL
#Get-NAVServerInstance $NavServiceInstance | New-NAVServerUserPermissionSet –WindowsAccount $ADuserSQL -PermissionSetId SUPER -Verbose

Get-NAVServerUser $NavServiceInstance
Get-NAVServerUserPermissionSet -ServerInstance $NavServiceInstance

#New-NAVServerUserPermissionSet $NavServiceName –WindowsAccount $ADuserJAL -PermissionSetId SUPER -Verbose