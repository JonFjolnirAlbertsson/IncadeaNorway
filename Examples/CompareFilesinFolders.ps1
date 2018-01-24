# Delete files from result that do not exist in Target
Clear-Host
#$CompareObject = "TAB*.TXT"
$CompareObject = "COD*.TXT"
#$ComparingStr = '[A-Z][A-Z][A-Z](\d+)\.TXT'
#$range = 1..99999999
$UpgradeFolderPath = 'C:\incadea\Customer\PP\NAV2018\CU01\Upgrade_PP\'
#Compare-Folders -CompareContent -CompareMergeResult2Result -CompareObjectFilter $CompareObjectFilter -DropObjectProperty -WorkingFolderPath $UpgradeFolderPath
Compare-Folders -CompareContent -CompareMergeResult2Result -CompareObjectFilter $CompareObjectFilter -DropObjectProperty -WorkingFolderPath $UpgradeFolderPath -MoveConflictItemsFromToBeJoined2Merged
#Remove-OriginalFilesNotInTarget -WorkingFolderPath $UpgradeFolderPath
<#
$MergeResultFilePath = join-path $UpgradeFolderPath  'MergeResult\'
$ResultFilePath = join-path $UpgradeFolderPath  'Result'
$OuputFilePath = join-path $UpgradeFolderPath   'CompareOutput.txt'
$MergedFilePath = join-path $UpgradeFolderPath   'Merged'
$ToBeJoinedFilePath = join-path $MergedFilePath   'ToBeJoined'
[Switch] $CompareContent = $true
[Switch] $DropObjectProperty = $true
#$CompOriginal = Get-ChildItem -Recurse -path $OriginalFilePath | where-object {$_.Name -like $CompareObject -and $range -contains ($_.name -replace $ComparingStr,'$1')}
#$CompTarget = Get-ChildItem -Recurse -path $TargetFilePath | where-object {$_.Name -like $CompareObject -and $range -contains ($_.name -replace $ComparingStr,'$1')}

$MergeResultFolder = Get-ChildItem -Recurse -path $MergeResultFilePath | where-object {$_.Name -like $CompareObject}
$ResultFolder = Get-ChildItem -Recurse -path $ResultFilePath | where-object {$_.Name -like $CompareObject}
#$CompTarget = Get-ChildItem -Recurse -path $TargetFilePath  | where {$range -contains ($_.name -replace $ComparingStr,'$1')} 
#$results = @(Compare-Object  -casesensitive -ReferenceObject $CompOriginal -DifferenceObject $CompTarget)
get-childitem  -path $MergeResultFilePath | where-object {$_.Name -like $CompareObject} | Copy-Item -Destination $ToBeJoinedFilePath

# Get files from ToBeJoined folder
$ToBeJoinedFolder = Get-ChildItem -Recurse -path $ToBeJoinedFilePath | where-object {$_.Name -like $CompareObject}
write-host "Deleting file $OuputFilePath" -foregroundcolor "white"
Remove-Item -Path $OuputFilePath 
$CompareResult = 'Comparing Result folder and ToBeJoined folder. The symbol => means there is a difference in the Result file. The symbol <= means there is a difference in the ToBeJoined file.'
$CompareResult | Out-File $OuputFilePath -Append
# Compare ToBeJoined (MergeResult) with Result (Standard NAV Merge) folder. 
foreach($ObjectFile in $ResultFolder)
{
    $ToBeJoindedObjectFile = (join-path $ToBeJoinedFilePath $ObjectFile.Name)
    if(!(Test-Path -Path $ToBeJoindedObjectFile ))
    {
        $CompareResult = "File is missing, $ToBeJoindedObjectFile."
    }else
    {
        if($CompareContent)
        {
            $Content1 = Get-Content $ToBeJoindedObjectFile
            $Content2 = Get-Content $ObjectFile.FullName
            $CompareResult = Compare-Object $Content1 $Content2            
        }else
        {
            $CompareResult = Compare-Object $ObjectFile.FullName $ToBeJoindedObjectFile
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
#>
<#
# Compare ToBeJoined (MergeResult) with Result (Standard NAV Merge) folder
$results = @(Compare-Object -casesensitive -ReferenceObject $ResultFolder -DifferenceObject $ToBeJoinedFolder -property name -passThru) 
$results | Out-File $OuputFilePath 

# Copy each object file in result from ToBeJoined to Merged folder
foreach($result in $results)
{
    get-childitem  -path $ToBeJoinedFilePath  | where-object {$_.Name -like $result.Name} | Move-Item -Destination $MergedFilePath -Force | out-null                    
}
#>