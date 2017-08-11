
import-module azure #see pre-requisites from above.
#Get-AzurePublishSettingsFile
#SI-Data Subscription
#Import-AzurePublishSettingsFile "C:\Users\albertssonf\OneDrive - SI-Data AS\Files\Azure\Visual Studio Premium med MSDN-10-12-2015-credentials.publishsettings"
#$AzureSubsription = "Visual Studio Premium med MSDN"

#fjolnir.albertsson@incadea.com Subscription
Import-AzurePublishSettingsFile "C:\Users\albertssonf\OneDrive - SI-Data AS\Files\Azure\Visual Studio Enterprise – MPN-8-11-2017-credentials.publishsettings"
$AzureSubsription = "Visual Studio Enterprise – MPN"

#$VMDiskName = “SQLNAVUpgrade”
#$VMName = "SQL2014Upgr"
$VMDiskName = “CompelloNAV”
$VMName = "CompelloNAV"
#Get-AzureDisk 
$sourceVHD = "https://portalvhds4tpknmdhq9nyc.blob.core.windows.net/vhds/sidata-compello-CompelloSQL-2015-03-24.vhd"
#$sourceVHD = "https://portalvhds4tpknmdhq9nyc.blob.core.windows.net/vhds/sidata-compello-sidata-compello-2015-03-23.vhd"
#$sourceVHD = "https://portalvhds4tpknmdhq9nyc.blob.core.windows.net/vhds/SQLNAVUpgrade-SQLNAVUpgrade-2015-03-25.vhd" # OS Disk
#$sourceVHD = "https://portalvhds4tpknmdhq9nyc.blob.core.windows.net/vhds/hmdhiwyl.3af201503261733210185.vhd"
$destinationVHD = "D:\Incadea\Backup\Azure\" + $VMName + "OSDisk.vhd"

Set-AzureSubscription -SubscriptionName $AzureSubsription -CurrentStorageAccountName (Get-AzureStorageAccount).Label -PassThru  
#Get-AzureSubscription
#Get-AzureVMImage | where {(gm –InputObject $_ -Name DataDiskConfigurations) -ne $null} | Select -Property Label, ImageName 


#portalvhdsjsc25kv9dkvx5
$myStoreAccount = Get-AzureStorageAccount
$myStoreKey = (Get-AzureStorageKey –StorageAccountName $myStoreAccount.Label).Primary 

#Download file
#Save-AzureVhd -Source $sourceVHD -LocalFilePath $destinationVHD -NumberOfThreads 5
Save-AzureVhd -Source $sourceVHD -LocalFilePath $destinationVHD -NumberOfThreads 5 -StorageKey $myStoreKey

#Upload file
#Add-AzureVhd -LocalFilePath $sourceVHD -Destination $destinationVHD -NumberOfUploaderThreads 5
