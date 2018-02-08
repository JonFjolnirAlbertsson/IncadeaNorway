<#
.Synopsis
   Runs Notepad++
.DESCRIPTION
   Runs Notepad++
.NOTES
   
.PREREQUISITES
   
#>
function NotepadPlus
{
    [CmdletBinding()]
    param(
        [string] $ArgumentList = "",
        [Switch] $Compare
        )
    PROCESS
    {
        try
        {   
            if($Compare)
            {    
                
                $NotepadPlus = Join-Path 'C:\Program Files (x86)\Notepad++\plugins\ComparePlugin\' 'compare.exe'
            }else
            {
                $NotepadPlus = Join-Path 'C:\Program Files (x86)\Notepad++' 'notepad++.exe'
            }     
            if($ArgumentList)
            {
                #& $NotepadPlus $ArgumentList
                Start-Process -FilePath $NotepadPlus -ArgumentList $ArgumentList          
            }
            else
            {
                & $NotepadPlus 
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