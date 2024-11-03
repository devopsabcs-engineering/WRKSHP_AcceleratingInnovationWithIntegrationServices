$apimGatewayUrl = "https://apim-ek001.azure-api.net"
$apimSubscriptionKey = "e83871bbfa04480ba39bc35bc66c3148"
$date = Get-Date -Format "yyyy-MM-dd-HH-mm-ss"
$headers = @{"Ocp-Apim-Subscription-Key" = $apimSubscriptionKey; "Content-Type" = "application/json" }
$body = "{ `"date`" : `"$date`", `"id`" : `"1`", `"data`" : `"Sending data via APIM->Service Bus->Function->CosmosDB`" }"

Write-Output "Sending data to APIM Gateway"
Write-Output "CosmosDB data will show only one record with the current date: $date"
Write-Output $body

Invoke-WebRequest -Uri "$apimGatewayUrl/sb-operations/demo-queue" `
    -Headers $headers `
    -Method 'POST' `
    -Body $body