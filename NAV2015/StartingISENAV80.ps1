﻿#Prepare PowerShell
Set-ExecutionPolicy RemoteSigned -Force
Import-Module "C:\Program Files\Microsoft Dynamics NAV\80\Service\NavAdminTool.ps1"

Import-Module "${env:ProgramFiles(x86)}\Microsoft Dynamics NAV\80\RoleTailored Client\Microsoft.Dynamics.Nav.Model.Tools.psd1" -force
#Get-Help "NAV"
