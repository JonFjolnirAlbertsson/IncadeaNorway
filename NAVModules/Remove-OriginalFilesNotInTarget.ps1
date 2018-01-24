function Remove-OriginalFilesNotInTarget
{
    [CmdletBinding()]
    param(
        [string] $WorkingFolderPath, 
        [string] $OriginalFolder,
        [string] $TargetFolder,
        [string] $RemoveFromFolder,
        [string] $CompareObjectFilter = "*.TXT",
        [Switch] $WriteResultToFile,
        [string] $ResultFileName = 'Removed-OriginalFilesNotInTarget.txt'
        )
    PROCESS
    {
        try
        {          
            #Set Original, target and RemoveFromFolder and result values
  
            if([String]::IsNullOrEmpty($OriginalFolder))
            {
                $OriginalFolder = join-path $WorkingFolderPath 'Original'
            }
            if([String]::IsNullOrEmpty($TargetFolder))
            {
                $TargetFolder = join-path $WorkingFolderPath 'Target'
            }
            if([String]::IsNullOrEmpty($RemoveFromFolder))
            {
                $MergedFolder = join-path $WorkingFolderPath 'Merged'
                $RemoveFromFolder = join-path $MergedFolder 'ToBeJoined'
            } 
            $ResultFileName = join-path $WorkingFolderPath $ResultFileName 
            # Add the RemoveFromFolder folder if not existing
            if(!(Test-Path -Path $RemoveFromFolder )){
                New-Item -ItemType directory -Path $RemoveFromFolder
            } 
            write-host "Delete standard object files from previous version that that do not exists in Target version." -foregroundcolor "white"
            write-host "Starting comparing files from  the original folder $OriginalFolder with the files in the target folder $TargetFolder" -foregroundcolor "white"
            write-host "The files will be removed from the folder $RemoveFromFolder" -foregroundcolor "white"
            write-host "This process can take some minutes ..." -foregroundcolor "white"
            $CompOriginal = Get-ChildItem -Recurse -path $OriginalFolder | where-object {$_.Name -like $CompareObjectFilter}
            $CompTarget = Get-ChildItem -Recurse -path $TargetFolder | where-object {$_.Name -like $CompareObjectFilter}
            $FilesToRemove = @(Compare-Object  -casesensitive -ReferenceObject $CompOriginal -DifferenceObject $CompTarget -property Name -passThru)
            [String] $MessageStr = ""
            [String] $RemovePath = ""
            foreach($FileObject in $FilesToRemove)
            {
                $i++
                $RemovePath = join-path $RemoveFromFolder $FileObject.Name
                $MessageStr = "Deleting the file $RemovePath. The SideIndicator is " + $FileObject.SideIndicator + "."  
                if((Test-Path -Path $RemovePath)){
                        remove-item -path $RemovePath -force
                }else {
                    $MessageStr = "The file $RemovePath, with the SideIndicator " + $FileObject.SideIndicator + " does not exists."
                }                                          
                Write-Host $MessageStr -foregroundcolor "yellow"
                if($WriteResultToFile)
                {
                    $MessageStr | Out-File $ResultFileName -Append
                }                 
            } 
            $RemovePath  = join-path $RemoveFromFolder 'MEN1010.TXT'  
            $MessageStr = "Deleting the file $RemovePath." 
            Write-Host $MessageStr -foregroundcolor 'yellow'
            if((Test-Path -Path $RemovePath)){remove-item -path $RemovePath -force} else {$MessageStr = "The file $RemovePath does not exists."}
            if($WriteResultToFile)
            {
                $MessageStr | Out-File $ResultFileName -Append
            }
            $RemovePath  = join-path $RemoveFromFolder "MEN1030.TXT"  
            $MessageStr = "Deleting the file $RemovePath." 
            Write-Host $MessageStr -foregroundcolor "yellow"    
            if((Test-Path -Path $RemovePath)){remove-item -path $RemovePath -force} else {$MessageStr = "The file $RemovePath does not exists."}
            if($WriteResultToFile)
            {
                $MessageStr | Out-File $ResultFileName -Append
            }
            #Remove Client Monitor objects from NAV 2009
            $RemovePath  = join-path  $RemoveFromFolder "???15002[0-9].TXT"
            $MessageStr = "Deleting the file $RemovePath." 
            Write-Host $MessageStr -foregroundcolor "yellow"  
            $FilesToRemove = Get-ChildItem $RemovePath 
            foreach($FileObject in $FilesToRemove)
            {
                $i++
                $RemovePath = join-path $RemoveFromFolder $FileObject.Name
                $MessageStr = "Deleting the file $RemovePath. The SideIndicator is " + $FileObject.SideIndicator + "."  
                if((Test-Path -Path $RemovePath)){
                        remove-item -path $RemovePath -force
                }else {
                    $MessageStr = "The file $RemovePath, with the SideIndicator " + $FileObject.SideIndicator + " does not exists."
                }                                          
                Write-Host $MessageStr -foregroundcolor "yellow"
                if($WriteResultToFile)
                {
                    $MessageStr | Out-File $ResultFileName -Append
                }                 
            }    
            write-host "Execution finished."
        }
        catch [Exception]
        {
            write-host "Merged failed with the error :`n`n " + $_.Exception
        }
        finally
        {
            # Clean up copied backup file after restore completes successfully
        }
    }
}