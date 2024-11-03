$apimGatewayUrl = "https://apim-ek001.azure-api.net"
$apimSubscriptionKey = "e83871bbfa04480ba39bc35bc66c3148"
$date = Get-Date -Format "yyyy-MM-dd-HH-mm-ss"
$headers = @{"Ocp-Apim-Subscription-Key" = $apimSubscriptionKey; "Content-Type" = "application/json" }

Invoke-WebRequest -Uri "$apimGatewayUrl/sb-operations/demo-queue" `
    -Headers $headers `
    -Method 'POST' `
    -Body "{ `"date`" : `"$date`", `"id`" : `"1`", `"data`" : `"Sending data via APIM->Service Bus->Function->CosmosDB`" }"