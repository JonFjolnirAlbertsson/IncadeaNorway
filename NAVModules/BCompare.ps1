<#
.Synopsis
   Runs Beyond Compare 3
.DESCRIPTION
   Runs Beyond Compare 3
.NOTES
   
.PREREQUISITES
   
#>
function BCompare
{
    [CmdletBinding()]
    param(
        [string] $ArgumentList = ""
        )
    PROCESS
    {
        try
        { 
            #$ApplicaitonFile = 'BComp.exe'		
            $ApplicaitonFile = 'BCompare.exe'		
            $BeyondCompare3 = Join-Path 'C:\Program Files (x86)\Beyond Compare 3' $ApplicaitonFile
             
            if($ArgumentList)
            {
                Start-Process -FilePath $BeyondCompare3 $ArgumentList          
            }
            else
            {
                & $BeyondCompare3   
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