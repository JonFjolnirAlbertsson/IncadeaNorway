﻿<#
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
        [string] $ShortVersion = 110 ,
        [String] $ServiceFolder = 'Service',
        [string] $RTCFolder = 'RoleTailored Client'
      )

    Set-ExecutionPolicy RemoteSigned -Force
    Import-Module "$env:ProgramFiles\Microsoft Dynamics NAV\$ShortVersion\$ServiceFolder\NavAdminTool.ps1"
    Import-Module "${env:ProgramFiles(x86)}\Microsoft Dynamics NAV\$ShortVersion\$RTCFolder\Microsoft.Dynamics.Nav.Model.Tools.psd1" -force
     
}