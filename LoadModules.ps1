write-host 'Loading Incadea Norway AS modules...'

Write-Progress -Activity 'Loading Incadea.NAVModules ...' -PercentComplete 50
Import-module (join-path $PSScriptRoot 'NAVModules\Incadea.NAVModules.psm1') -DisableNameChecking -Force -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
Import-module Incadea.NAVModules -Force -WarningAction SilentlyContinue -ErrorAction SilentlyContinue

Clear-host
write-host -ForegroundColor Yellow 'Get-Command -Module ''Incadea.NAVModules*'''
get-command -Module 'Incadea.NAVModules*'
