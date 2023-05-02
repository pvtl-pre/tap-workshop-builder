# TAP Workshop Builder

This project was built to make [TAP Made Simple](https://github.com/pvtl-pre/tap-made-simple/), easier to consume for classroom-like settings.

## Goals and Audience

Building workshops can be a time consuming process. Workshops should be independent of the day-to-day infrastructure the set of users are accustomed to, in order to lessen the prerequisites required. TAP Workshop Builder utilizes Azure to build infrastructure for a variable set users, all with their own jump servers, in order for them to work through the lab modules of [TAP Made Simple](https://github.com/pvtl-pre/tap-made-simple/).

## Required CLIs, Plugins and Accounts

- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- [Terraform](https://www.terraform.io/)

Additionally, you will need a [Tanzu Network account](https://network.tanzu.vmware.com/). For this account, you will need to accept any Tanzu Application Platform EULAs and create a UAA API TOKEN (i.e. refresh token).

## Azure Setup

The Azure infrastructure built by TAP Workshop Builder is net-new and encapsulated in resource groups for TAP Workshop Builder and each user.

- TAP Workshop Builder Resource Group
  - Virtual Network
  - Network Security Groups
  - Subnets
- Per User Resource Group
  - Jump Server
  - Public IP
  - TAP Made Simple resources (AKS clusters, ACR, etc.)

While the previously listed resources are net-new, some Azure infrastructure must be set up prior to building workshops.

### Service Principal

The [Azure service principal](https://learn.microsoft.com/en-us/azure/active-directory/develop/app-objects-and-service-principals) acts as the delegate to your Azure Subscription but with less permissions. It is utilized by TAP Made Simple on the user's jump server to deploy resources for the user. [Create a service principal](https://learn.microsoft.com/en-us/azure/active-directory/develop/howto-create-service-principal-portal) with a client secret and a [custom role](https://learn.microsoft.com/en-us/azure/role-based-access-control/custom-roles-portal) in the Azure portal and assign the role to the service principal. The custom role should have the following permissions:

- Microsoft.ContainerRegistry
- Microsoft.ContainerService
- Microsoft.Network
- Microsoft.Resources
- Microsoft.KubernetesConfiguration
- Microsoft.Kubernetes

Be sure to capture the service principal's client id and secret.

### DNS

DNS is necessary for the user to be able to access their TAP clusters. A domain name delegated to Azure nameservers in an Azure DNS Zone will need to be set up. The service principal will have access to create DNS A records automatically.

## Build Workshops

Utilizing Terraform conventions, make a copy `terraform.tfvars.example` and remove the `.example` extension. Edit this file and add your Azure information such as tentant id, service principal information, Tanzu Network (i.e. Tanzu Registry) and usernames for each workshop you want to create.

1. [Sign in with Azure CLI](https://docs.microsoft.com/en-us/cli/azure/authenticate-azure-cli)
1. Run `terraform init`
1. Run `terraform plan`
1. Run `terraform apply -auto-approve`
1. The ssh information for each jump server will be outputted for each user and a corresponding admin account used for troubleshooting

## Cloud-init

During the workshop building process, [Cloud-init](https://cloudinit.readthedocs.io/) is utilized to install all the CLI tools and TAP Made Simple. TAP Made Simple is then configured and deployed on the jump server. Terraform will wait until this process is complete for all jump servers created.

### Debugging Cloud-init

If for some reason Cloud-init fails, SSH into the jump server using the admin account. You can run some of the commands below to help troubleshoot the issue.

```console
# Get the status of Cloud-init
cloud-init status

# Check the Cloud-init log for errors in [cloud-config.yaml](./cloud-init/cloud-config.yaml)
sudo cat /var/log/cloud-init.log

# Check the Cloud-init output log for errors in the [scripts](./scripts/)
sudo cat /var/log/cloud-init-output.log

# Verify errors in the runcmd script
sudo vim /var/lib/cloud/instance/scripts/runcmd
```
