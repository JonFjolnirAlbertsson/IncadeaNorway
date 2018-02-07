function New-NAVUser-INC
{
    [CmdletBinding()]
    param(
		[Parameter(Mandatory=$True, ValueFromPipeline=$True, ValueFromPipelineByPropertyName=$True, HelpMessage='What NAV Server Instance would you like to target?')]
        [System.String]
        [string] $NavServiceInstance,
		[string] $User = "si-dev\nav_user", 
        [string] $Tenant = 'default'
        )
    PROCESS
    {
        try
        { 
            $navuser = Get-NAVServerUser -ServerInstance $NavServiceInstance -Tenant $Tenant | where-Object UserName -eq $User
            if([String]::IsNullOrEmpty($navuser.UserName))
            {           
                $navuser = New-NAVServerUser -ServerInstance $NavServiceInstance -WindowsAccount $User -Tenant $Tenant -LicenseType Full -State Enabled -ErrorAction Continue
                "New user:" + $User
            }

            $navrole = Get-NAVServerUserPermissionSet -ServerInstance $NavServiceInstance -Tenant $Tenant -WindowsAccount $User
            if([String]::IsNullOrEmpty($navrole ))
            {            
                New-NAVServerUserPermissionSet -PermissionSetId SUPER -ServerInstance $NavServiceInstance -WindowsAccount $User -Tenant $Tenant -ErrorAction Continue
                "New PermissionSetId: SUPER" 
            }

            "NAV User '$User ' Created with the role SUPER."
            $User | ft -AutoSize
        }
        catch [Exception]
        {
            "NAV User '$User ' Created :`n`n " + $_.Exception
        }
        finally
        {
            # Clean up copied backup file after restore completes successfully
        }
    }
}


