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
        Import-Module "C:\Program Files (x86)\Microsoft Dynamics NAV\$ShortVersion\$RTCFolder\Microsoft.Dynamics.Nav.Model.Tools.psd1" -Force -DisableNameChecking -Global
    }
    $NAVServerModulePath = "$env:ProgramFiles\Microsoft Dynamics NAV\$ShortVersion\$ServiceFolder\Microsoft.Dynamics.Nav.Management.psm1"
	Import-Module $NAVServerModulePath -Force -WarningAction SilentlyContinue | Out-Null
    #Export-ModuleMember -Function *-* -Variable Nav*
}