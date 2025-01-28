#!/usr/bin/env pwsh

try {
    az tag update --resource-id /subscriptions/${env:AZURE_SUBSCRIPTION_ID}/resourceGroups/MA_${env:AZURE_MONITOR_NAME}_${env:AZURE_LOCATION}_managed --operation delete --tags azd-env-name=${env:AZURE_ENV_NAME}
    az tag update --resource-id /subscriptions/${env:AZURE_SUBSCRIPTION_ID}/resourceGroups/MA_${env:AZURE_MONITOR_NAME}_${env:AZURE_LOCATION}_managed/providers/Microsoft.Insights/dataCollectionEndpoints/${env:AZURE_MONITOR_NAME} --operation delete --tags azd-env-name=${env:AZURE_ENV_NAME}
    az tag update --resource-id /subscriptions/${env:AZURE_SUBSCRIPTION_ID}/resourceGroups/MA_${env:AZURE_MONITOR_NAME}_${env:AZURE_LOCATION}_managed/providers/Microsoft.Insights/dataCollectionRules/${env:AZURE_MONITOR_NAME} --operation delete --tags azd-env-name=${env:AZURE_ENV_NAME}
} catch {
    Write-Error "Failed to remove tags. If these tags can't be removed AZD Down will not be able to execute"
    exit 1
}