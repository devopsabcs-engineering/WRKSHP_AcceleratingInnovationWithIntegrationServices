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

az deployment sub create --name $deploymentName `
    --location "$location" `
    --template-file $templateFile `
    --parameters name="$nameSuffix" `
    --parameters publisherEmail="$publisherEmail" `
    --parameters publisherName="$publisherName"