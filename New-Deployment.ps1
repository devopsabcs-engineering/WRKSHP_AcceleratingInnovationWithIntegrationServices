param (
    [Parameter()]
    [string]$deploymentName = "deploy-$(Get-Date -Format 'yyyyMMddHHmmss')",
    [Parameter()]
    [string]$location = "canadacentral",
    [Parameter()]
    [string]$templateFile = "infra/main.bicep",
    [Parameter()]
    [string]$nameSuffix = "ek001",
    [Parameter()]
    [string]$publisherEmail = "admin@MngEnvMCAP675646.onmicrosoft.com",
    [Parameter()]
    [string]$publisherName = "Sys Admin"
)

# if apim is soft deleted, purge it
write-host "Checking if APIM service is soft deleted..."
az apim deletedservice show --location "$location" --service-name "apim-$nameSuffix" --query "name" --output tsv
if ($?) {
    write-host "APIM service is soft deleted. Purging..."
    az apim deletedservice purge --location "$location" --service-name "apim-$nameSuffix"
}
else {    
    write-host "APIM service is not soft deleted."
}

az deployment sub create --name $deploymentName `
    --location "$location" `
    --template-file $templateFile `
    --parameters name="$nameSuffix" `
    --parameters publisherEmail="$publisherEmail" `
    --parameters publisherName="$publisherName"