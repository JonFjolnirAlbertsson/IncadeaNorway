<#
.Synopsis
   Imports NAV Modules
.DESCRIPTION
   Imports NAV Modules
.NOTES
   
.PREREQUISITES
   
#>

function Import-NAVModule-INC {
    [CmdLetBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string] $ShortVersion = 110,
        [String] $ServiceFolder = 'Service',
        [string] $RTCFolder = 'RoleTailored Client',
        [Switch] $ImportRTCModule
      )   
    if($ImportRTCModule)
    {
        Import-Module "${env:ProgramFiles(x86)}\Microsoft Dynamics NAV\$ShortVersion\$RTCFolder\Microsoft.Dynamics.NAV.Model.Tools.psd1" -Force -DisableNameChecking -Global
        Import-Module "${env:ProgramFiles(x86)}\Microsoft Dynamics NAV\$ShortVersion\$RTCFolder\Microsoft.Dynamics.Nav.Apps.Tools.psd1" -Force -DisableNameChecking -Global
        Import-Module "${env:ProgramFiles(x86)}\Microsoft Dynamics NAV\$ShortVersion\$RTCFolder\Microsoft.Dynamics.NAV.Apps.Management.psd1" -Force -DisableNameChecking -Global
    }
    $NAVServerModulePath = "$env:ProgramFiles\Microsoft Dynamics NAV\$ShortVersion\$ServiceFolder\Microsoft.Dynamics.Nav.Management.psm1"
	Import-Module $NAVServerModulePath -Force -DisableNameChecking -Global
}