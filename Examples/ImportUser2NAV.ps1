Set-ExecutionPolicy RemoteSigned -Force
#Import NAV admin module for the version of Dynamics NAV you are using 
Import-Module "C:\Program Files\Microsoft Dynamics NAV\100\Service\NavAdminTool.ps1"
$NavServiceInstance = "NAVOAS"

Set-Location "C:\Incadea\Data\"
$ImportFilePath = "UsersAndRoles.csv"

$list = Import-csv -Path $ImportFilePath -Encoding UTF8 -Delimiter ';' -Header username,fullname,roleset,company
$DomainName = "overasen"

#$list = Import-csv -Path $ImportFilePath -Encoding Unicode -Delimiter ';' -Header username,fullname,roleset
foreach ($user in $list) 
{
    $navuser= Get-NAVServerUser -ServerInstance $NavServiceInstance
    #Write-Host $navuser.UserName  $user.username
    $NAVUserName = $DomainName + '\' + $user.username

    if(!($navuser.UserName -contains $user.username))
    { 
        New-NAVServerUser -ServerInstance $NavServiceInstance -WindowsAccount $NAVUserName -FullName $user.fullname -ErrorAction Continue
    }
    else
    {
        Set-NAVServerUser -ServerInstance $NavServiceInstance -WindowsAccount $NAVUserName -FullName $user.fullname -ErrorAction Continue
    }
    #In the csv file used in this example, the list of roles is divided by a comma 
    $roleset=$user.roleset.Split(',')
    foreach ($role in $roleset)
    {
        $navrole=Get-NAVServerUserPermissionSet -ServerInstance $NavServiceInstance -WindowsAccount $user.username
        if(!($navrole.PermissionSetID -contains $role))
        {
            New-NAVServerUserPermissionSet -ServerInstance $NavServiceInstance -WindowsAccount $NAVUserName -CompanyName $user.company -PermissionSetId $role -ErrorAction Continue
            #Remove-NAVServerPermissionSet ServerInstance $NavServiceInstance -WindowsAccount $NAVUserName
        }
        
    }
    #Remove-NAVServerUser -ServerInstance $NavServiceInstance -WindowsAccount $NAVUserName
}

 
