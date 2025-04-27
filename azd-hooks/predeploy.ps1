#!/usr/bin/env pwsh

function Assert-Command {
    param (
        [string]$command
    )
    if (-not (Get-Command $command -ErrorAction SilentlyContinue)) {
        Write-Error "$command is not installed or not found in PATH."
        exit 1
    }
}

Assert-Command -command "az"
Assert-Command -command "kubectl"
Assert-Command -command "helm"

try {
    az aks get-credentials --resource-group ${env:AZURE_RG_NAME} --name ${env:AZURE_AKS_CLUSTERNAME} --overwrite-existing
} catch {
    Write-Error "Failed to get AKS credentials: $_"
    exit 1
}

try {
    @"
image: ${env:AZURE_REGISTRY_URI}/maartenvandiemen/eshoponweb:latest
"@ | Out-File -FilePath ./custom-values.yaml -Encoding utf8 -Force
} catch {
    Write-Error "Failed to write custom-values.yaml: $_"
    exit 1
}

try {
    $releaseName = "eshoponweb"
    $namespace = "default"

    $releaseExists = helm list --namespace $namespace -q | Select-String -Pattern "^$releaseName$"

    if ($releaseExists) {
        helm upgrade $releaseName ./eshoponweb-chart -f ./custom-values.yaml --namespace $namespace
    } else {
        helm install $releaseName ./eshoponweb-chart -f ./custom-values.yaml --namespace $namespace
    }
} catch {
    Write-Error "Failed to deploy Helm chart: $_"
    exit 1
}

try {
    $chartsUrl = "https://charts.chaos-mesh.org"

    if (-not (helm repo list | Select-String -Pattern $chartsUrl)) {
        helm repo add chaos-mesh $chartsUrl
        helm repo update
    }
} catch {
    Write-Error "Failed to add or update Helm repo: $_"
    exit 1
}

try {
    if (-not (kubectl get ns chaos-testing -o name)) {
        kubectl create ns chaos-testing

        $chaosMeshPods = kubectl get pods --namespace chaos-testing -l app.kubernetes.io/instance=chaos-mesh --no-headers
        if (-not $chaosMeshPods) {
            helm repo update
            helm install chaos-mesh chaos-mesh/chaos-mesh --namespace=chaos-testing --set chaosDaemon.runtime=containerd --set chaosDaemon.socketPath=/run/containerd/containerd.sock
        }
    }
} catch {
    Write-Error "Failed to deploy Chaos Mesh: $_"
    exit 1
}
