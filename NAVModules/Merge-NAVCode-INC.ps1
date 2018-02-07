    <#
        .SYNOPSIS
        Split Original, Modified and Target object file.
        .DESCRIPTION
        Split Original, Modified and Target object file. Creates Folder structure under the working folder and
        Uses standard NAV upgrade objects functions. Join will copy .TXT objects from the Merge folder the
         .EXAMPLE  
        Merge-NAVCode -WorkingFolderPath $WorkingFolder -OriginalFileName $OriginalObjectsPath -ModifiedFileName $ModifiedObjectsPath -TargetFileName $TargetObjectsPath -CompareObject $CompareObject -Split
        Splitting Original, Modified and Target files to individua files.
         .EXAMPLE         
        Merge-NAVCode-INC -Join -WorkingFolderPath $WorkingFolder
        Join from ToBeJoined folder and creating the file all-merged-objects.txt under the working directory
   
    #>
function Merge-NAVCode-INC
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string] $WorkingFolderPath, 
        [string] $CompareObjectFilter = "*.TXT",
        [string] $OriginalFileName,
        [string] $ModifiedFileName,
        [string] $TargetFileName,
        [Switch] $Split,
        [Switch] $Merge,
        [Switch] $Join,
        [Switch] $CopyMergedToSubFolders,
        [Switch] $JoinCopyResultFoldersBefore,
        [Switch] $OpenConflictFilesInKdiff,
        [Switch] $RemoveModifyFilesNotInTarget,
        [Switch] $RemoveOriginalFilesNotInTarget
        )
    PROCESS
    {
        try
        { 
            #Programs to use
            $NotepadPlus = Join-Path 'C:\Program Files (x86)\Notepad++' 'notepad++.exe'
            $Kdiff = Join-Path 'C:\Program Files\KDiff3' 'kdiff3.exe'

            # Set the right folder path based on company folder and files name
            $SourceOriginal = $OriginalFileName
            $SourceModified = $ModifiedFileName
            $SourceTarget = $TargetFileName

            $DestinationOriginal = join-path $WorkingFolderPath   "Original"
            $DestinationModified =  join-path $WorkingFolderPath   "Modified"
            $DestinationTarget =  join-path $WorkingFolderPath   "Target"

            $Delta =  join-path $WorkingFolderPath "Delta"
            $Result =  join-path $WorkingFolderPath "Result"
            $ResultMergedPath =  join-path $Result "Merged"
            $Merged =  join-path $WorkingFolderPath "Merged"
            $MergedResultFile =  join-path $WorkingFolderPath "Incadea-MergedResult.txt"

            # Check if folders exists. If not create them.
            if(!(Test-Path -Path $DestinationOriginal )){
                New-Item -ItemType directory -Path $DestinationOriginal
            }
            if(!(Test-Path -Path $DestinationModified )){
                New-Item -ItemType directory -Path $DestinationModified
            }
            if(!(Test-Path -Path $DestinationTarget )){
                New-Item -ItemType directory -Path $DestinationTarget
            }
            if(!(Test-Path -Path $Delta )){
                New-Item -ItemType directory -Path $Delta
            }
            if(!(Test-Path -Path $Result )){
                New-Item -ItemType directory -Path $Result
            }
            if(!(Test-Path -Path $ResultMergedPath )){
                New-Item -ItemType directory -Path $ResultMergedPath
            }
            if(!(Test-Path -Path $Merged )){
                New-Item -ItemType directory -Path $Merged
            }

            #Set Source, modified, target and result values
            $OriginalCompareObject = join-path $DestinationOriginal  $CompareObjectFilter
            $ModifiedCompareObject = join-path $DestinationModified  $CompareObjectFilter
            $TargetCompareObject = join-path $DestinationTarget  $CompareObjectFilter
            $DeltaUpdateObject = join-path $Delta  $UpdateObject
            $JoinPath = join-path $Merged  "ToBeJoined"
            $JoinSource = join-path $JoinPath  $CompareObjectFilter
            $JoinDestination = join-path $WorkingFolderPath  "all-merged-objects.txt"

            if(!(Test-Path -Path $JoinPath )){
                New-Item -ItemType directory -Path $JoinPath
            }   

            $CODFolder = join-path $Result "COD"
            $TABFolder = join-path $Result "TAB"
            $PAGFolder = join-path $Result "PAG"
            $REPFolder = join-path $Result "REP"

            # Split text files with many objects
            If($Split)
            {
                write-host "Removing items from the folder $DestinationOriginal*.*" -foregroundcolor "white"
                Remove-Item -Path "$DestinationOriginal*.*" 
                write-host "Removing items from the folder $DestinationModified*.*" -foregroundcolor "white"
                Remove-Item -Path "$DestinationModified*.*"
                write-host "Removing items from the folder $DestinationTarget*.*" -foregroundcolor "white"
                Remove-Item -Path "$DestinationTarget*.*"

                if(![String]::IsNullOrEmpty($SourceOriginal))
                {
                    Split-NAVApplicationObjectFile  -Source $SourceOriginal -Destination $DestinationOriginal -PreserveFormatting -Force
                    write-host "The source file $SourceOriginal has been split to the destination $DestinationOriginal" -foregroundcolor "white" 
                }
                if(![String]::IsNullOrEmpty($SourceModified))
                {
                    Split-NAVApplicationObjectFile  -Source $SourceModified -Destination $DestinationModified -PreserveFormatting -Force
                    write-host "The source file $SourceModified has been split to the destination $DestinationModified" -foregroundcolor "white"
                }
                if(![String]::IsNullOrEmpty($SourceTarget))
                {
                    Split-NAVApplicationObjectFile  -Source $SourceTarget -Destination $DestinationTarget -PreserveFormatting -Force
                    write-host "The source file $SourceTarget has been split to the destination $DestinationTarget" -foregroundcolor "white"
                 }
            }
            # Merge text files
            If($Merge)
            {
                write-host "Empty the folder for result files. $Result." -foregroundcolor "white" 
                Remove-Item -Path (join-path $Result '*.*') -recurse

                if ($OpenConflictFilesInKdiff)
                {
                    $ResultFiles = Merge-NAVApplicationObject -Modified $ModifiedCompareObject -Original $OriginalCompareObject -Result $Result -Target $TargetCompareObject -DateTimeProperty FromTarget -ModifiedProperty FromModified -VersionListProperty FromTarget -Force 
				    Write-Host "`nOpen NOTEPAD for each CONFLICT file" -foreground Green
				    # Open NOTEPAD for each CONFLICT file
				        $ResultFiles | 
					        Where-Object MergeResult -eq 'Conflict' | 
					        #foreach { NOTEPAD $_.Conflict }
                            foreach {& $NotepadPlus $_.Conflict}

				        Write-Host "`nOpen three-way merge-tool KDIFF3 for each object with conflict(s)" -foreground Green
				        Write-Host "  Note: The example, KDIFF3, is a free merge tool available here: http://kdiff3.sourceforge.net/" -foreground Green
				        # Open three-way merge-tool KDIFF3 for each object with conflict(s)
				        $ResultFiles | 
					        Where-Object MergeResult -eq 'Conflict' | 
					        #foreach { & "C:\Program Files\KDiff3\kdiff3" $_.Original $_.Modified $_.Target -o $_.Result }
                            foreach {& $Kdiff $_.Original $_.Modified $_.Target -o  (join-path $Merged (Get-Item $_.Original.FileName).Name) }
                }else
                {
                    $ResultFiles = Merge-NAVApplicationObject -Modified $ModifiedCompareObject -Original $OriginalCompareObject -Result $Result -Target $TargetCompareObject -DateTimeProperty FromTarget -ModifiedProperty FromModified -VersionListProperty FromTarget -Force
                }
                write-host "Write merge result to file $MergedResultFile."
                $ResultFiles | Out-File $MergedResultFile
                write-host "Creating the folder $CODFolder or deleting all files in the folde. " -foregroundcolor "white" 
                New-Item -Path $CODFolder -ItemType directory -Force | out-null
                Remove-Item -Path (join-path $CODFolder '*.*')
                write-host "Creating the folder $TABFolder or deleting all files in the folde. " -foregroundcolor "white" 
                New-Item -Path $TABFolder -ItemType directory -Force | out-null
                Remove-Item -Path (join-path $TABFolder '*.*')
                write-host "Creating the folder $PAGFolder or deleting all files in the folde. " -foregroundcolor "white" 
                New-Item -Path $PAGFolder -ItemType directory -Force | out-null
                Remove-Item -Path (join-path $PAGFolder '*.*')  
                write-host "Creating the folder $REPFolder or deleting all files in the folde. " -foregroundcolor "white" 
                New-Item -Path $REPFolder -ItemType directory -Force | out-null
                Remove-Item -Path (join-path $REPFolder '*.*')

                if($CopyMergedToSubFolder)
                {
                    write-host "Copy merged files to sub folders."  -foregroundcolor "white"
                    #get-childitem  -path $Result  | where-object {$_.Name -like "COD*.*"} | Out-Default
                    get-childitem  -path $Result  | where-object {$_.Name -like "COD*.*"} | Move-Item -Destination $CODFolder -Force | out-null
                    get-childitem  -path $Result  | where-object {$_.Name -like "TAB*.*"} | Move-Item -Destination $TABFolder -Force | out-null
                    get-childitem  -path $Result  | where-object {$_.Name -like "PAG*.*"} | Move-Item -Destination $PAGFolder -Force | out-null
                    get-childitem  -path $Result  | where-object {$_.Name -like "REP*.*"} | Move-Item -Destination $REPFolder -Force | out-null
                }else
                {
                    get-childitem  -path $Result  | where-object {$_.Name -like "*.TXT"} | Move-Item -Destination $ResultMergedPath -Force | out-null
                }
                write-host "The filter used to merge files was $CompareObjectFilter"  -foregroundcolor "white" 
                write-host "Below you can see were the source files come from ..."  -foregroundcolor "white" 
                write-host $OriginalCompareObject  -foregroundcolor "white" 
                write-host $ModifiedCompareObject  -foregroundcolor "white" 
                write-host $TargetCompareObject  -foregroundcolor "white" 
                write-host "The merged files are found in the folder $Result, and the related subfolders (COD,TAB,PAG and REP)." -foregroundcolor "white" 

                write-host "Remember!" 
                write-host "After the script has run the result files should be compared." 
                write-host "The result files should be compared to the Modified file and the target file."
                
				Write-Host "`nCompare ORIGINAL and MODIFIED and merge onto TARGET, then put the merged files in RESULT" -foreground Green
				# Compare ORIGINAL and MODIFIED and merge onto TARGET, then put the merged files in RESULT            

            }
            # Join text files to one file
            If($Join -or $JoinCopyResultFoldersBefore)
            {
                if($JoinCopyResultFoldersBefore)
                {
                    #Move and copy item to the join folder
                    write-host "Moving files from the folder $CODFolder to the folder $JoinPath" -foregroundcolor "white"
                    get-childitem  -path $CODFolder  | where-object {$_.Name -like "COD*.TXT"} | Move-Item -Destination $JoinPath -Force | out-null
                    write-host "Moving files from the folder $TABFolder to the folder $JoinPath" -foregroundcolor "white"
                    get-childitem  -path $TABFolder  | where-object {$_.Name -like "TAB*.TXT"} | Move-Item -Destination $JoinPath -Force | out-null
                    write-host "Moving files from the folder $PAGFolder to the folder $JoinPath" -foregroundcolor "white"
                    get-childitem  -path $PAGFolder  | where-object {$_.Name -like "PAG*.TXT"} | Move-Item -Destination $JoinPath -Force | out-null
                    write-host "Moving files from the folder $REPFolder to the folder $JoinPath" -foregroundcolor "white"
                    get-childitem  -path $REPFolder  | where-object {$_.Name -like "REP*.TXT"} | Move-Item -Destination $JoinPath -Force | out-null
                    write-host "Moving files from the folder $Result to the folder $JoinPath" -foregroundcolor "white"
                    get-childitem  -path $Result  | where-object {$_.Name -like "*.TXT"} | Move-Item -Destination $JoinPath -Force | out-null
                }

                if ($RemoveOriginalFilesNotInTarget)
                {
                    Remove-OriginalFilesNotInTarget -CompareObjectFilter $CompareObjectFilter -OriginalFolder $DestinationOriginal -TargetFolder $DestinationTarget -WorkingFolderPath $WorkingFolderPath                    
                }
                if ($RemoveModifyFilesNotInTarget)
                {
                    Remove-ModifiedFilesNotInTarget -CompareObjectFilter $CompareObjectFilter -ModifiedFolder $DestinationModified -TargetFolder $DestinationTarget -WorkingFolderPath $WorkingFolderPath                        
                }
                write-host "Copy manually merged objects to the join folder" -foregroundcolor "white"
                write-host "Copying files from the folder $Merged to the folder $JoinPath" -foregroundcolor "white"
                get-childitem  -path $Merged   | where-object {$_.Name -like "*.TXT"} | Copy-Item -Destination $JoinPath

                write-host "Joining all files in the folder $JoinSource into the file $JoinDestination" -foregroundcolor "white"
                write-host "The filter used to join files is $CompareObjectFilter" -foregroundcolor "white"
                Join-NAVApplicationObjectFile -Source $JoinSource -Destination $JoinDestination -Force          
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