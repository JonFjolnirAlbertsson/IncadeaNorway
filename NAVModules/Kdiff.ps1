﻿<#
.Synopsis
   Runs Kdiff
.DESCRIPTION
   Runs Kdiff
.NOTES
   
.PREREQUISITES
   
#>
function Kdiff
{
    [CmdletBinding()]
    param(
        [string] $ArgumentList = ""
        )
    PROCESS
    {
        try
        { 
            $Kdiff = Join-Path 'C:\Program Files\KDiff3' 'kdiff3.exe'
             
            if($ArgumentList)
            {
                Start-Process -FilePath $Kdiff -ArgumentList $ArgumentList          
            }
            else
            {
                & $Kdiff   
            }
            
        }
        catch [Exception]
        {
            write-host "Open file failed with the error :`n`n " + $_.Exception
        }
        finally
        {
            # Clean up copied backup file after restore completes successfully
        }
    }
 }