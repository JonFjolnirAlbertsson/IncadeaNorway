#$Objects = Get-NAVApplicationObjectProperty -Source C:\_Customers\distri_TestVersionlist.txt 
<#$OriginalProperty = Get-NAVApplicationObjectProperty -Source $OriginalObjectsPath$ModifiedProperty = Get-NAVApplicationObjectProperty -Source $FastFitObjectsWithDEUPath
$TargetProperty = Get-NAVApplicationObjectProperty -Source $TargetObjectsPath
#>
$VersionListPrefixes = 'NAVW1', 'NAVNO'

foreach ($Object in $TargetProperty){
    
    $newVersionlist = Merge-NAVVersionList -OriginalVersionList $OriginalProperty.VersionList -ModifiedVersionList $ModifiedProperty.VersionList -TargetVersionList $TargetProperty.VersionList -Versionprefix $VersionListPrefixes
    
    "$($ModifiedProperty.VersionList) --> $newVersionlist"
}
$Object