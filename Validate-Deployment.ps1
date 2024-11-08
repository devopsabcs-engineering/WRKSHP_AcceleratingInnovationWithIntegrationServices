param (
    [Parameter()]
    [string]
    $instanceNumber = "ek002",
    [Parameter()]
    [string]
    $apimGatewayUrl = "https://apim-$instanceNumber.azure-api.net",
    [Parameter()]
    [string]
    $resourceGroup = "rg-$instanceNumber",
    [Parameter()]
    [string]
    $apimServiceName = "apim-$instanceNumber",
    [Parameter()]
    [string]
    $subscriptionId = "64c3d212-40ed-4c6d-a825-6adfbdf25dad" # CHANGE ME
)

# echo parameters
Write-Output "instanceNumber: $instanceNumber"
Write-Output "apimGatewayUrl: $apimGatewayUrl"
Write-Output "resourceGroup: $resourceGroup"
Write-Output "apimServiceName: $apimServiceName"
Write-Output "subscriptionId: $subscriptionId"


# get subscription key from APIM using the following command

#POST https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/subscriptions/{sid}/listSecrets?api-version=2024-05-01

# do the aabove post request
# get the subscription key from the response

# get uri
$apiVersion = "2023-09-01-preview"
$uri = "https://management.azure.com/subscriptions/$subscriptionId/resourceGroups/$resourceGroup/providers/Microsoft.ApiManagement/service/$apimServiceName/subscriptions/master/listSecrets?api-version=$($apiVersion)"

# do the post call

# get authorization token
Write-Output "Getting access token"
$token = az account get-access-token --query accessToken -o tsv

$headers = @{"Authorization" = "Bearer $token"; "Content-Type" = "application/json" }

$response = Invoke-WebRequest -Uri $uri -Headers $headers -Method 'POST'

$apimSubscriptionKey = ($response.Content | ConvertFrom-Json).primaryKey

# careful this is a big secret
Write-Output "APIM Subscription Key (BIG SECRET!!): $apimSubscriptionKey"


$date = Get-Date -Format "yyyy-MM-dd-HH-mm-ss"
$headers = @{"Ocp-Apim-Subscription-Key" = $apimSubscriptionKey; "Content-Type" = "application/json" }
$body = "{ `"date`" : `"$date`", `"id`" : `"1`", `"data`" : `"Sending data via APIM->Service Bus->Function->CosmosDB`" }"

Write-Output "Sending data to APIM Gateway"
Write-Output "CosmosDB data will show only one record with the current date: $date"
Write-Output $body

$uri = "$apimGatewayUrl/sb-operations/demo-queue"

Write-Output "URI: $uri"

Invoke-WebRequest -Uri $uri `
    -Headers $headers `
    -Method 'POST' `
    -Body $body