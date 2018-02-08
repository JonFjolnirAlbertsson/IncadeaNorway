<#
.Synopsis
   Open Target, Original,Result and Merged File in Notepad++ and/or Kdiff
.DESCRIPTION
   Open Target, Original,Result and Merged File in Notepad++ and/or Kdiff
.NOTES
   
.PREREQUISITES
   
#>
function Open-File-INC
{
    [CmdletBinding()]
    param(
        [string] $WorkingFolder, 
        [string] $ObjectName,
        [Switch] $OpenOriginal,
        [Switch] $OpenModified,
        [Switch] $OpenTarget,
        [Switch] $OpenMerged,
        [Switch] $OpenResult,
        [Switch] $OpenConflict,
        [Switch] $OpenToBeJoined,
        [Switch] $OpenInNotepadPlus,
        [Switch] $OpenInBCompare,
        [Switch] $OpenInKdiff,
        [Switch] $OpenToMergeInKdiff,
		[Switch] $UseWaldoFolders
        )
    PROCESS
    {
        try
        {       
            [String] $Original = ''
            [String] $Modified = ''
            [String] $Target = ''
            [String] $Merged = join-path $WorkingFolder "\Merged\$ObjectName.TXT"
            [String] $ToBeJoined = join-path $WorkingFolder "\Merged\ToBeJoined\$ObjectName.TXT"
            [String] $Result = ''
            [String] $Conflict = ''
				
            [String] $FileArgs = "";
            [String] $KdiffFileArgs = '';
			
			if($UseWaldoFolders) 
            {
				$Original = join-path $WorkingFolder "\MergeResult\ConflictOriginal\$ObjectName.TXT"
				$Modified = join-path $WorkingFolder "\MergeResult\ConflictModified\$ObjectName.TXT"
            	$Target   = join-path $WorkingFolder "\MergeResult\ConflictTarget\$ObjectName.TXT"
				$Result   = join-path $WorkingFolder "\MergeResult\$ObjectName.TXT"
                $Conflict = join-path $WorkingFolder "\MergeResult\$ObjectName.CONFLICT"
            }
			else
			{
				$Original = join-path $WorkingFolder "\Original\$ObjectName.TXT"
				$Modified = join-path $WorkingFolder "\Modified\$ObjectName.TXT"
            	$Target   = join-path $WorkingFolder "\Target\$ObjectName.TXT"			
				$Result   = join-path $WorkingFolder "\Result\$ObjectName.TXT"
                $Conflict = join-path $WorkingFolder "\Result\$ObjectName.CONFLICT"
			}
				
            if($OpenOriginal) 
            {
                if((Test-Path -Path $Original))
                {
                    $FileArgs = $Original
                    $KdiffFileArgs = join-path $WorkingFolder "\Original\$ObjectName.TXT"
                 }
            }
            if($OpenModified) 
            {
                if((Test-Path -Path $Modified))
                {
                    if([String]::IsNullOrEmpty($FileArgs))
                    {
                        $FileArgs = $Modified
                        $KdiffFileArgs =  (join-path $WorkingFolder "\Modified\$ObjectName.TXT")          
                    }
                    else
                    {           
                        $KdiffFileArgs =  $KdiffFileArgs + ' ' + (join-path $WorkingFolder "\Modified\$ObjectName.TXT")
                        $FileArgs = $FileArgs, $Modified
                    }
                }
            }
            if($OpenTarget) 
            {
                if((Test-Path -Path $Target))
                {
                    if([String]::IsNullOrEmpty($FileArgs))
                    {
                        $FileArgs = $Target
                        $KdiffFileArgs =  (join-path $WorkingFolder "\Target\$ObjectName.TXT")
                    }
                    else
                    {
                        $FileArgs = $FileArgs, $Target
                        $KdiffFileArgs =  $KdiffFileArgs + ' ' + (join-path $WorkingFolder "\Target\$ObjectName.TXT")
                    }
                }
            }
            if($OpenMerged) 
            {
                if((Test-Path -Path $Merged))
                {
                    if([String]::IsNullOrEmpty($FileArgs))
                    {
                        $FileArgs = $Merged
                        $KdiffFileArgs =  (join-path $WorkingFolder "\Merged\$ObjectName.TXT")
                    }
                    else
                    {
                        $FileArgs = $FileArgs, $Merged
                        # If merging we will not include this file
                        if(!$OpenToMergeInKdiff)
                        {
                            $KdiffFileArgs =  $KdiffFileArgs + ' ' + (join-path $WorkingFolder "\Merged\$ObjectName.TXT")
                        }         
                    }
                }
            }
            if($OpenResult) 
            {
                if((Test-Path -Path $Result))
                {
                    if([String]::IsNullOrEmpty($FileArgs))
                    {
                        $FileArgs = $Result
                        $KdiffFileArgs =  (join-path $WorkingFolder "\Result\$ObjectName.TXT")
                    }
                    else
                    {
                        $FileArgs = $FileArgs, $Result
                        $KdiffFileArgs =  $KdiffFileArgs + ' ' + (join-path $WorkingFolder "\Result\$ObjectName.TXT")
                    }
                }
            }
             if($OpenConflict) 
            {
                if((Test-Path -Path $Conflict))
                {
                    if([String]::IsNullOrEmpty($FileArgs))
                    {
                        $FileArgs = $Conflict
                        $KdiffFileArgs =  (join-path $WorkingFolder "\Result\$ObjectName.CONFLICT")
                    }
                    else
                    {
                        $FileArgs = $FileArgs, $Conflict
                        $KdiffFileArgs =  $KdiffFileArgs + ' ' + (join-path $WorkingFolder "\Result\$ObjectName.CONFLICT")
                    }
                }
            }
            if($OpenToBeJoined) 
            {
                if([String]::IsNullOrEmpty($FileArgs))
                {
                    $FileArgs = $ToBeJoined
                    $KdiffFileArgs =  (join-path $WorkingFolder "\Merged\ToBeJoined\$ObjectName.TXT")
                }
                else
                {
                    $FileArgs = $FileArgs, $ToBeJoined
                    $KdiffFileArgs =  $KdiffFileArgs + ' ' + (join-path $WorkingFolder "\Merged\ToBeJoined\$ObjectName.TXT")
                }
            }

            if($OpenInNotepadPlus)
            { 
                NotepadPlus -ArgumentList $FileArgs #-Compare      
            }

            if($OpenInKdiff -or $OpenToMergeInKdiff)
            {
                if($OpenToMergeInKdiff)
                { 
                    $KdiffFileArgs =  $KdiffFileArgs + ' -o ' + $Merged 
                    Kdiff -ArgumentList $KdiffFileArgs                    
                }
                else
                {
                    Kdiff -ArgumentList $KdiffFileArgs 
                }                                                  
            }
            if($OpenInBCompare)
            {
                BCompare -ArgumentList $KdiffFileArgs                                                  
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