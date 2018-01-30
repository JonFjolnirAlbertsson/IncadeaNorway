function New-SQLUser-INC
{
    <#
    .Synopsis
       Creating  db user and adding db role 
    .DESCRIPTION
       Creating  db user and adding db role 
    .NOTES
       No Return value
    .PREREQUISITES
   
    #>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false)]
        [String] $DatabaseServer = '.',
        [Parameter(Mandatory=$false)]
        [String] $DatabaseInstance = '',
        [Parameter(Mandatory=$true)]
        [String] $DatabaseName,
        [Parameter(Mandatory=$true)]
        [String] $DatabaseUser = '',
        [Parameter(Mandatory=$false)]
        [String] $DatabaseRole = 'db_owner',
		[Parameter(Mandatory=$false)]
        [String] $TimeOut = 0,
        [Parameter(Mandatory=$false)]
        [switch]$TrustedConnection
    )
    $SQLString = "CREATE USER [$DatabaseUser] FOR LOGIN [$DatabaseUser]"
    write-Host -ForegroundColor Green "Starting command $SQLString]"
    Invoke-sql-INC -DatabaseServer $DatabaseServer -DatabaseInstance $DatabaseInstance -TrustedConnection $TrustedConnection -TimeOut $TimeOut -sqlCommand $SQLString
    $SQLString = "ALTER ROLE [db_owner] ADD MEMBER [$DatabaseUser]"
    write-Host -ForegroundColor Green "Starting command $SQLString]"
    Invoke-sql-INC -DatabaseServer $DatabaseServer -DatabaseInstance $DatabaseInstance -TrustedConnection $TrustedConnection -TimeOut $TimeOut -sqlCommand $SQLString
}

