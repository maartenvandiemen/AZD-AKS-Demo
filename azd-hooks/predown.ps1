#!/usr/bin/env pwsh

# The AZD down command is failing due to a default deny rule set by Bicep.
# To resolve the issue, the AZD tags have been removed from the resource with the deny assignment.
# By doing this, the resource is no longer targeted by the AZD down command, allowing it to proceed without errors.
# The resource group will be deleted by Azure. If the Azure Monitor Workspace is deleted, the resource group with the deny assignment will be deleted as well.
try {
    az tag update --resource-id /subscriptions/${env:AZURE_SUBSCRIPTION_ID}/resourceGroups/MA_${env:AZURE_MONITOR_NAME}_${env:AZURE_LOCATION}_managed --operation delete --tags azd-env-name=${env:AZURE_ENV_NAME}
    az tag update --resource-id /subscriptions/${env:AZURE_SUBSCRIPTION_ID}/resourceGroups/MA_${env:AZURE_MONITOR_NAME}_${env:AZURE_LOCATION}_managed/providers/Microsoft.Insights/dataCollectionEndpoints/${env:AZURE_MONITOR_NAME} --operation delete --tags azd-env-name=${env:AZURE_ENV_NAME}
    az tag update --resource-id /subscriptions/${env:AZURE_SUBSCRIPTION_ID}/resourceGroups/MA_${env:AZURE_MONITOR_NAME}_${env:AZURE_LOCATION}_managed/providers/Microsoft.Insights/dataCollectionRules/${env:AZURE_MONITOR_NAME} --operation delete --tags azd-env-name=${env:AZURE_ENV_NAME}
} catch {
    Write-Error "Failed to remove tags. If these tags can't be removed AZD Down will not be able to execute"
    exit 1
}