# Azure Kubernetes Services with Aure Developer CLI

This repo contains a demo for AKS which can be deployed to Azure using the [Aure Developer CLI](https://learn.microsoft.com/en-us/azure/developer/azure-developer-cli/overview). 

💪 This template scenario is part of the larger **[Microsoft Trainer Demo Deploy Catalog](https://aka.ms/trainer-demo-deploy)**.

## ⬇️ Installation
- [Azure Developer CLI](https://learn.microsoft.com/en-us/azure/developer/azure-developer-cli/install-azd)
    - When installing the above the following tools will be installed on your machine as well:
        - [GitHub CLI](https://cli.github.com)
        - [Bicep CLI](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/install)
- [AzureCLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
- [KubeCTL](https://kubernetes.io/docs/tasks/tools/)
- [PowerShell](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell)
- [Helm](https://helm.sh/docs/intro/install/)

## 🚀 Deploying the scenario in 4 steps:

1. Create a new folder on your machine.
```
mkdir <your repo link> e.g. maartenvandiemen/AZD-AKS-Demo
```
2. Next, navigate to the new folder.
```
cd <your repo link> e.g. maartenvandiemen/AZD-AKS-Demo
```
3. Next, run `azd init` to initialize the deployment.
```
azd init -t <your repo link> e.g. maartenvandiemen/AZD-AKS-Demo
```
4. Last, run `azd up` to trigger an actual deployment.
```
azd up
```

⏩ Note: you can delete the deployed scenario from the Azure Portal, or by running ```azd down``` from within the initiated folder.

## What is the demo scenario about?
- Use the [demo guide](demoguide.md) for inspiration for your demo.

### ⏰ Time to deploy
10 minutes

## 💭 Feedback and Contributing
Feel free to create issues for bugs, suggestions or Fork and create a PR with new demo scenarios or optimizations to the templates. 
If you like the scenario, consider giving a GitHub ⭐