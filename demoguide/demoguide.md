[comment]: <> (please keep all comment items at the top of the markdown file)
[comment]: <> (please do not change the ***, as well as <div> placeholders for Note and Tip layout)
[comment]: <> (please keep the ### 1. and 2. titles as is for consistency across all demoguides)
[comment]: <> (section 1 provides a bullet list of resources + clarifying screenshots of the key resources details)
[comment]: <> (section 2 provides summarized step-by-step instructions on what to demo)


[comment]: <> (this is the section for the Note: item; please do not make any changes here)
***
### Azure Kubernetes Service (AKS) with EShopOnWeb Retail sample Pods - demo scenario

<div style="background: lightgreen; 
            font-size: 14px; 
            color: black;
            padding: 5px; 
            border: 1px solid lightgray; 
            margin: 5px;">

**Note:** Below demo steps should be used **as a guideline** for doing your own demos. Please consider contributing to add additional demo steps.
</div>

[comment]: <> (this is the section for the Tip: item; consider adding a Tip, or remove the section between <div> and </div> if there is no tip)

<div style="background: lightblue; 
            font-size: 14px; 
            color: black;
            padding: 5px; 
            border: 1px solid lightgray; 
            margin: 5px;">

**Tip:** The same **EShopOnWeb Retail** application is also available in the **IAAS, PAAS and ACI scenarios**. If you want to walk learners through the different Azure Architectures, running the same application workload, it's a quite powerful demo.
</div>

***
### 1. What Resources are getting deployed
This scenario deploys the sample **.NET EShopOnWeb Retail** application inside a **highly-available and scalable (2 VM Nodes) AKS cluster**. The Pods for this application are configured with a **replica parameter of 5**, which means AKS will spread the containers across the nodes.
Thanks to the out-of-the-box deployed scenario, you get a fully, ready-to-use AKS environment, which guarantees several easy, yet powerful ways of showcasing the AKS and Kubernetes possibilities in Azure. Apart from AKS, the scenario also comes with an **Azure Container Registry**. 

* acr%uniqueid% - Azure Container Registry
* aks-%uniqueid% - Running Azure Kubernetes Service cluster
* grafana-%uniqueid% - Azure Managed Grafana
* monitor-%uniqueid% - Azure Monitor workspace

<img src="https://raw.githubusercontent.com/maartenvandiemen/AZD-AKS-Demo/refs/heads/main/demoguide/img/ResourceGroup_Overview.png" alt="AKS Resource Group" style="width:70%;">
<br></br>

Note: next to the AKS Services RG, there is also an MC_%resourcegroupname%_%aksname% RG, which contains the actual Azure Infrastructure Resources for the AKS Cluster, such as the VM Scale Set, Azure Load Balancer, Virtual Network and Subnets, Public IP Addresses, etc...
<img src="https://raw.githubusercontent.com/maartenvandiemen/AZD-AKS-Demo/refs/heads/main/demoguide/img/MC_ResourceGroup_Overview.png" alt="AKS MC Resource Group" style="width:70%;">
<br></br>

Note: next to the AKS Services RG, there is also an MA_%azuremonitorname%_%location%_managed RG, which contains the data collection rules and endpoints for collection the data for the Azure Monitor workspace.
<img src="https://raw.githubusercontent.com/maartenvandiemen/AZD-AKS-Demo/refs/heads/main/demoguide/img/MA_ResourceGroup_Overview.png" alt="AKS MA Resource Group" style="width:70%;">
<br></br>


### 2. What can I demo from this scenario after deployment

#### Kubernetes topology and monitoring
1. From the Azure Portal, navigate to the **AKS Kubernetes Service**
1. From the **Overview** blade, discuss the different parts of the **Properties** section, such as
    - Node Pools: explain the Kubernetes versions and update strategy, as well as the VM size flexibility
    - Networking: the scenario is using Kubenet, a network extension from Kubernetes, allowing for a 100% Azure Network integration, using different netwerk segments
1. From the top right, navigate to **Kubernetes version**, and select it. 
1. This redirects you to the **Settings/Cluster configuration**; discuss the built-in rolling update mechanism, allowing an AKS/Kubernetes setup to get upgraded without major impact on the running environment.
1. Briefly discuss the **AKS pricing tier**, allowing for a business-critical Scale Sets scenario with 99.95% SLA for the underlying AKS hosts.
1. Navigate to **Kubernetes Resoureces/NameSpaces**. AKS Namespace is a way to group and organize Kubernetes objects in a cluster. It provides a scope for Kubernetes resources and prevents name collisions between resources. Namespaces allow multiple teams or applications to use the same cluster without interfering with each other. You can create multiple namespaces within an AKS cluster to isolate workloads, network policies, and security. The most common one is called **default**, which hosts our sample application Pods. Other Namespaces have been created for Kubernetes System Pods, as well as separate monitoring and Kubernetes Gatekeeper.

<img src="https://raw.githubusercontent.com/maartenvandiemen/AZD-AKS-Demo/refs/heads/main/demoguide/img/AKS_NameSpaces.png" alt="AKS NameSpaces" style="width:70%;">
<br></br>

1. Select the **default** namespace. Open the **YAML** file and walk the learner through the basics of the **YAML Kubernetes** configuration file. It holds information about the NameSpace, the creation date, and how it is getting managed (kube-apiserver)
1. Return to the previous blade, and select **Workloads**. 
1.  In AKS, Workloads are **Kubernetes objects** that define the desired state of a set of containers, such as pods, deployments, and replica sets. Workloads provide a way to **manage and scale** containerized applications in a Kubernetes cluster. Deployments are commonly used to manage the desired state of replicas, while replica sets ensure that a specified number of pod replicas is running at any given time. **Pods** are the smallest deployable units in Kubernetes and represent one or more containers that are tightly coupled and share resources.
1. In the extensive list of Workloads, several are managing the internals of the Kubernetes cluster, for example the kube-system Namespace ones, as well as the Gatekeeper ones. Our demo setup got extended with a **monitoring** Namespace, running **Prometheus** metrics and traces, **Chaos-testing** which allows for Chaos Engineering fault injection testing, and the **default** Namespace, which runs the sample Pods with applications.

<img src="https://raw.githubusercontent.com/maartenvandiemen/AZD-AKS-Demo/refs/heads/main/demoguide/img/AKS_Workloads.png" alt="AKS Workloads" style="width:70%;">
<br></br>

1. From the list of Workloads, select **eshoponweb**. From the detailed Overview blade of the eshoponweb, notice 5 running containers. This is because our setup specified a parameter of **5 replicas**. 

1. Select any of the 5 eshoponweb-xyz123 Pods, and click **Delete**. Notice the Status will change to **Terminating**, immediately followed by the creation of a **new Pod**, having the **Pending** Status. This will shortly change to **Running**.

<img src="https://raw.githubusercontent.com/maartenvandiemen/AZD-AKS-Demo/refs/heads/main/demoguide/img/AKS_Pod_Replicas.png" alt="AKS Pod Replicas" style="width:70%;">
<br></br>

1. Return to the Azure AKS Portal blade, and select **Services and ingresses**.  In AKS, Services are Kubernetes objects that provide a **stable IP address and DNS name** for a set of pods. Services enable **inter-pod communication within a cluster and also allow external access to the pods**. AKS supports different types of Services, such as ClusterIP, NodePort, and LoadBalancer, to suit different use cases. ClusterIP services are internal to the cluster and accessible only from within the cluster, while NodePort services expose a port on each node's IP address and make the service accessible externally via a static port. LoadBalancer services expose the service externally using a cloud provider's load balancer.
1. From the list of **Services**, highlight **eshoponweb**. Explain it's running behind a **LoadBalancer**, and is public internet-facing using an Azure Public IP Address. **Select the Public IP**, and notice the EShopOnWeb app is running from within a Pod.
1. Return to the **Services** view, and click on the **eshoponweb** service. From the detailed blade, notice the **Node port, Port 80 and the different internal IP Endpoints, representing the 5 replica Pods.

<img src="https://raw.githubusercontent.com/maartenvandiemen/AZD-AKS-Demo/refs/heads/main/demoguide/img/AKS_Services.png" alt="AKS Services" style="width:70%;">
<br></br>

1. Return to the AKS Overview blade, and navigate to Settings/**Node Pools**. Node pools provide space for applications to run. Node pools of different types can be added to the cluster to handle a variety of workloads, existing node pools can be scaled and upgraded, or node pools that are no longer needed can be deleted. Each node pool will contain nodes backed by virtual machines.
1. Select **agentpool**.
1. From the agentpool Overview blade, explain the different actions available: **Upgrade Kubernetes, Update image, Scale node pool,...** 
1. Select **Scale Node Pool**. 
1. Explain the difference between **manual and autoscale**.
1. From the nodepool1 Overview blade, navigate to **Nodes**. This shows the 2 active running node-VMs.

<img src="https://raw.githubusercontent.com/maartenvandiemen/AZD-AKS-Demo/refs/heads/main/demoguide/img/AKS_agentpool.png" alt="AKS agentpool" style="width:70%;">
<br></br>

#### Managing AKS using Kubernetes KubeControl command Line
1. While the Azure Portal integrates very nicely with AKS, it is still possible to manage (most) of the AKS environment using the **kubectl commandline tool**. This is convenient if the customer has Kubernetes environments across different platforms, and wants to use a single management approach.
1. **kubectl** is preloaded in **Azure Cloud Shell**. Open Cloud Shell.
1. run the following command to **authenticate to the AKS cluster**:
```
az aks get-credentials -g MTTDemoDeployRG%alias%AKSGraf -n %alias%fastcarAKSGraf
```
1. run the following command to get a **list of running pods** in the default namespace

```
kubectl get pods
```
1. run the following command to get a list of **kubernetes namespaces**
```
kubectl get namespace
```
1. run the following command to get a list of **kubernetes nodes**
```
kubectl get nodes
```

<img src="https://raw.githubusercontent.com/maartenvandiemen/AZD-AKS-Demo/refs/heads/main/demoguide/img/AKS_kubectl.png" alt="AKS kubectl" style="width:70%;">
<br></br>

#### Using Prometheus and Grafana for monitoring metrics and dashboarding

1. Grant yourself Grafana Administrator rights in the managed grafana instance of the RG in which the AZD CLI has created the resources.
1. Open Grafana

##### Known issues
1. By Default is Azure Monitor selected, since this isn't configured you need to select Managed Prometheus (and make this the default)


#### Chaos Testing AKS cluster

1. See [this](https://learn.microsoft.com/en-us/azure/chaos-studio/chaos-studio-tutorial-aks-portal) tutorial

[comment]: <> (this is the closing section of the demo steps. Please do not change anything here to keep the layout consistant with the other demoguides.)
<br></br>
***
<div style="background: lightgray; 
            font-size: 14px; 
            color: black;
            padding: 5px; 
            border: 1px solid lightgray; 
            margin: 5px;">

**Note:** This is the end of the current demo guide instructions.
</div>
