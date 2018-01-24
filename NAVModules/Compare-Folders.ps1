<#
.Synopsis
  Compare files in Folder structure
.DESCRIPTION
   Uses Compare-Object to compare two folders and write the result to file.
.NOTES
.PARAMETER MoveConflictItemsFromToBeJoined2Merged  
Finds files (*.CONFLICT) in the result folder and uses that to move files from ToBeJoined folder to Merged folder
.PREREQUISITES
   
#>
function Compare-Folders
{
    [CmdletBinding()]
    param(
        [string] $WorkingFolderPath,
        [string] $CompareObjectFilter = '*.TXT',
        [string] $CompareFolder1Path,
        [string] $CompareFolder2Path,
        [string] $OuputFileName = 'CompareOutput.txt',
        [Switch] $CopyMergeResult2ToBeJoined,
        [Switch] $MoveConflictItemsFromToBeJoined2Merged,
        [Switch] $CompareMergeResult2Result,
        [Switch] $CompareContent,
        [Switch] $DropObjectProperty
        )
    PROCESS
    {
        try
        { 
            #Programs to use
            $NotepadPlus = Join-Path 'C:\Program Files (x86)\Notepad++' 'notepad++.exe'
            $Kdiff = Join-Path 'C:\Program Files\KDiff3' 'kdiff3.exe'

            $ResultFolderPath =  join-path $WorkingFolderPath 'Result'
            $MergedFolderPath =  join-path $WorkingFolderPath 'Merged'
            $MergeResultFolderPath = join-path $WorkingFolderPath 'MergeResult'
            $OuputFilePath = join-path $WorkingFolderPath $OuputFileName
            $ToBeJoinedFolderPath = join-path $MergedFolderPath 'ToBeJoined'
            

            if($CopyMergeResult2ToBeJoined)
            {
                write-host "Empty the folder $ToBeJoinedFolderPath for result files." -foregroundcolor "white" 
                if (Confirm-YesOrNo -title "Delete files in the folder" -message "Delete files in the folder $ToBeJoinedFolderPath ?"){
                    Remove-Item -Path (join-path $ToBeJoinedFolderPath '*.*') -recurse
                } else {
                    write-error "Folder $ToBeJoinedFolderPath already exists.  Overwrite not allowed."
                    break
                }  
                # Get files from MergeResult folder             
                Get-ChildItem -Recurse -path $MergeResultFolderPath | where-object {$_.Name -like $CompareObjectFilter} | Copy-Item -Destination $ToBeJoinedFolderPath
            }
            # Finds files (*.CONFLICT) in the result folder and uses that to move files from ToBeJoined folder to Merged folder
            if($MoveConflictItemsFromToBeJoined2Merged)
            {
                # Get files from MergeResult folder 
                $MergeResultFolder = Get-ChildItem -Recurse -path $MergeResultFolderPath | where-object {$_.Name -like $CompareObjectFilter}
                # Get files from ToBeJoined folder
                $ToBeJoinedFolder = Get-ChildItem -Recurse -path $ToBeJoinedFolderPath | where-object {$_.Name -like $CompareObjectFilter}
                $ConflictResults = @(Compare-Object -casesensitive -ReferenceObject $MergeResultFolder -DifferenceObject $ToBeJoinedFolder -property name -passThru) 
                $ConflictResultsOuputFilePath = join-path $WorkingFolderPath 'ConflictResults.txt'
                $ConflictResults | Out-File $ConflictResultsOuputFilePath 

                # Copy each object file in result from ToBeJoined to Merged folder
                foreach($ConflictItem in $ConflictResults)
                {
                    get-childitem  -path $ToBeJoinedFolderPath  | where-object {$_.Name -like $ConflictItem.Name} | Move-Item -Destination $MergedFolderPath -Force | out-null                    
                }
            }
            # Compare ToBeJoined (MergeResult) with Result (Standard NAV Merge) folder. 
            if($CompareMergeResult2Result)
            {
                # Get files from ToBeJoined folder
                $CompareFolder1Path = $ToBeJoinedFolderPath
                # Get files from Result folder
                $CompareFolder2Path = $ResultFolderPath
            }
            write-host "Comparing files in folder $CompareFolder1Path and $CompareFolder2Path." -foregroundcolor "white"
            $CompareFolder1 = Get-ChildItem -Recurse -path $CompareFolder1Path | where-object {$_.Name -like $CompareObjectFilter}
            $CompareFolder2 = Get-ChildItem -Recurse -path $CompareFolder2Path | where-object {$_.Name -like $CompareObjectFilter}
          
            write-host "Deleting file $OuputFilePath" -foregroundcolor "white"
            Remove-Item -Path $OuputFilePath 
            $CompareResult = 'Comparing Result folder and ToBeJoined folder. The symbol => means there is a difference in the Result file. The symbol <= means there is a difference in the ToBeJoined file.'
            $CompareResult | Out-File $OuputFilePath -Append
            
            foreach($ObjectFile in $CompareFolder2)
            {
                [string] $Compare1FilePath = (join-path $CompareFolder1Path $ObjectFile.Name)
                [string] $Compare2File = $ObjectFile.FullName
                write-host $Compare2File
                if(!($Compare2File.Contains('Conflict')))
                {
                    if(!(Test-Path -Path $Compare1FilePath ))
                    {
                        $CompareResult = "File is missing, $Compare1FilePath."
                    }else
                    {
                        if($CompareContent)
                        {
                            $Content1 = Get-Content $Compare1FilePath
                            $Content2 = Get-Content $ObjectFile.FullName
                            $CompareResult = Compare-Object $Content1 $Content2            
                        }else
                        {
                            $CompareResult = Compare-Object $ObjectFile.FullName $Compare1FilePath
                        }
                    }
                    #get-childitem  -path $ToBeJoinedFilePath  | where-object {$_.Name -like $ObjectFile.Name} | Move-Item -Destination $MergedFilePath -Force | out-null                    
                    if($DropObjectProperty)
                    {
                        $FirstLine = $true
                        foreach($Line in $CompareResult)
                        {
                            [string] $LineText = $Line
                            #If not one of the following substrings then write to file
                            if(!(($LineText.StartsWith("@{InputObject=    Date=")) -or ($LineText.StartsWith("@{InputObject=    Time=")) -or ($LineText.StartsWith("@{InputObject=    Version List="))))
                         {
                                if($FirstLine)
                                {
                                    ('Comparing ' + $ObjectFile.FullName) | Out-File $OuputFilePath -Append
                                }
                                $LineText | Out-File $OuputFilePath -Append
                                $FirstLine = $false                         
                            }
                        }
                    }else
                    {

                        $CompareResult | Out-File $OuputFilePath -Append
                    }
                }
            }
            write-host "Execution finished."
        }
        catch [Exception]
        {
            write-host "Compare failed with the error :`n`n " + $_.Exception
        }
        finally
        {
            #
        }
    }
}