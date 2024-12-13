-------------------
# Argo CD

Requirements:
* Installed kubectl command-line tool.
* Have a kubeconfig file (default location is ~/.kube/config).
* CoreDNS. Can be enabled for microk8s by microk8s enable dns && microk8s stop && microk8s start

Please see details ---> https://github.com/gsd-gsd/gsd-gsd/issues/1
----
------
# terraform and terragrunt
Terragrunt is a flexible orchestration tool that allows Infrastructure as Code to scale.
Pre-requisites
Install
Install Terraform and Terragrunt.

Prepare remote state store
We use azure blob storage container as a Terraform backend to store your Terraform state.

Prepare resource group/storage account/container and update deployment_storage_resource_group_name and deployment_storage_account_name in each site's site.hcl.

Provide Azure credentials
Provide your Azure service principal credentials via either CI/CD pipeline like Jenkins or local env file.

The following environment variables are required:

SERVICE_PRINCIPAL_USR
SERVICE_PRINCIPAL_PSW
TENANT_ID
SUBSCRIPTION_ID
Prepare environment/site level variables
Fill in environment/site level variables in env.hcl and site.hcl respectively.

Sample
terragrunt/1-dev/env.hcl

```
locals {
  env_name        = "1-dev"
  subscription_id = "00000000-0000-0000-0000-000000000000"
  client_id       = "00000000-0000-0000-0000-000000000000"
  tenant_id       = "00000000-0000-0000-0000-000000000000"
}
```

terragrunt/1-dev/us/site.hcl

```
locals {
  site_name                              = "US"
  location                               = "West US 2"
  resource_group_name                    = "gsd-rg-1"
  deployment_storage_resource_group_name = "gsddeployment"
  deployment_storage_account_name        = "gsddeploymentstate"
}
```

Code structure
The code in this repo uses the following folder hierarchy:



where:

Environment: Each environment represents an Azure subscription, like 1-dev, 2-qa, 3-prod etc. Environment level variables are defined in env.hcl.
Site: Typically, site is a region within one particular subscription, there is also some exceptions, like 2 sites are both in the same region but for different use cases. Site level variables are defined in site.hcl.
Resource: Resource is a single or a collection of Azure resources, like resource group/AKS cluster etc.
Environments vs Modules
Environments should only contain variable definitions for different environments. All common configurations like provider/backend are in the root terragrunt.hcl, it makes Terraform code DRY.

While, modules, is the actual Terraform module for one particular resource.

With this approach, copy/paste between environments is minimized. The terragrunt.hcl files contain solely the source path of the module to deploy and the inputs to set for that module in the current environment. To create a new environment, you copy an old one and update just the environment-specific inputs in the terragrunt.hcl files, which is about as close to the “essential complexity” of the problem as you can get.

Advantages
Thanks to Terragrunt (a thin wrapper of Terraform), we can have all the following advantages without many home-made scripts:

DRY Terraform code and immutable infrastructure
DRY provider and remote state configuration
Run Terraform commands on multiple modules at once in a proper dependencies order
Auto-init and auto-retry

Deployment
Deploy
Infrastructure deployment:
    -e (Required) environment name (1-dev, 2-qa, 3-prod, etc)
    -s (Required) site name (us, eu, etc)
    -c (Optional) component name (app, networking, resource-group, etc), omit this to deploy all components
    -p (Optional) plan only, do not deploy
Sample

```
bash ./scripts/deploy.sh -e 1-dev -s us -c resource-group
```
Make sure you have set required environment variables properly.

Destroy
Infrastructure destroy:
    -e (Required) environment name (1-dev, 2-qa, 3-prod, etc)
    -s (Required) site name (us, eu, etc)
    -c (Optional) component name (app, networking, resource-group, etc), omit this to deploy all components
Sample

```
 ./scripts/destroy.sh -e 1-dev -s us -c resource-group
```

Make sure you have set required environment variables properly.

-----

# Deployment Architecture
Please see details in clicking this link ---> https://github.com/gsd-gsd/gsd-gsd/issues/2
------

# Istio Service Mesh and AKS
Please see details in clicking this link ---> https://github.com/gsd-gsd/gsd-gsd/issues/3
------
