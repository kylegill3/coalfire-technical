# Solution Overview

### Infrastructure Layout
- Flat network topology with a single VNet (10.0.0.0/16)
- Segregated subnets for application, management, backend, and web services (all /24)
- Load-balanced web tier with Ubuntu 22.04 VMs in an availability set
- Management VM for secure access

### Security Implementation
- NSG rules limiting access between tiers
- Azure Key Vault for secret management
- SSH access restricted to management subnet
- Load balancer providing frontend access to web VMs
- Storage account with GRS redundancy, accessible only from the management subnet

### Component Breakdown
1. **Core Security Layer**
   - Azure Key Vault
   - Log Analytics Workspace
   - Security policies and RBAC

2. **Network Layer**
   - Virtual Network (10.0.0.0/16)
   - Subnet segmentation:
     - Application: Application servers
     - Management: Jump boxes
     - Backend: Supporting services
     - Web: Frontend servers
   - NSGs controlling inter-subnet communication

3. **Compute Layer**
   - Web servers in an availability set
   - Management VM for administrative access
   - Load balancer for web traffic distribution
   - Scripted installation of Apache on web VMs

4. **Storage Layer**
   - Storage account with GRS redundancy
   - Containers for Terraform state and web logs
   - Access restricted to management subnet

5. **Monitoring**
   - Flow logs enabled
   - Diagnostic settings configured
   - Centralized logging

# Deployment Instructions

### Authentication
```sh
az login
Select Subscription from the prompt
```

### Layered Deployments
In an effort to minimize the blast radius of deployments as well as keeping the state files more manageable, the terraform code is broken up into "layers". Each layer acts as a building block and they need to be applied in a particular order.
1. security-core
2. region-setup
3. network
4. management
5. web

#### Security Core
- Please note, random errors happen when using the security-core module due to what looks like a race condition where permissions are not propigated at the time keys are being read. If this happens, please wait 5 minutes and re-run until all the errors cease.
- Comment out the `backend "azurerm"` section from the tfstate.tf file located at `terraform/security-core/tfstate.tf` 
- Run the below commands
```sh
cd terraform/security-core
terraform init
terraform plan -var-file="../_configs/prod.tfvars"
terraform apply -var-file="../_configs/prod.tfvars"
```
##### Migrate State
1. Uncomment the backend "azurerm" portion of the tstate.tf file.
2. Update the resource_group_name, storage_account_name and container_name variables to match the newly created storage account.
3. Run terraform init to initialize the backend. You will be prompted to migrate the state file. Select yes.
4. Run terraform apply to migrate the state file to the remote storage account.
5. Delete the terraform.tfstate and terraform.tfstate.backup files.
6. Commit changes and push to repo.

#### Region Setup
- Dependencies
   - Make sure the "Authentication" section has been followed
   - Make sure these layers have been applied successfully:
      - security-core
- Run the below commands
```sh
cd ../region-setup
terraform init
terraform plan -var-file="../_configs/prod.tfvars"
terraform apply -var-file="../_configs/prod.tfvars"
```

#### Network
- Dependencies
   - Make sure the "Authentication" section has been followed
   - Make sure these layers have been applied successfully:
      - security-core
      - region-setup
- Run the below commands
```sh
cd ../network
terraform init
terraform plan -var-file="../_configs/prod.tfvars"
terraform apply -var-file="../_configs/prod.tfvars"
```

#### Management
- Dependencies
   - Make sure the "Authentication" section has been followed
   - Make sure these layers have been applied successfully:
      - security-core
      - region-setup
      - network
- Run the below commands
```sh
cd ../management
terraform init
terraform plan -var-file="../_configs/prod.tfvars"
terraform apply -var-file="../_configs/prod.tfvars"
```

#### Web
- Dependencies
   - Make sure the "Authentication" section has been followed
   - Make sure these layers have been applied successfully:
      - security-core
      - region-setup
      - network
      - management
- Run the below commands
```sh
cd ../web
terraform init
terraform plan -var-file="../_configs/prod.tfvars"
terraform apply -var-file="../_configs/prod.tfvars"
```

# Design Decisions

### Modular Approach
- Use of Coalfire's open-source Terraform modules to ensure consistency and reuse.
- Breaking down the infrastructure into modular components: security-core, region-setup, network, management, and web.

### Layered Deployment
- Deploying infrastructure in layers to minimize the blast radius and manage state files more effectively.
- Each layer builds upon the previous one, ensuring dependencies are met.

### Network Segmentation
- Implementing a flat network topology with a single VNet (10.0.0.0/16) and four subnets (Application, Management, Backend, Web) to ensure proper network segmentation and security.
- Using Network Security Groups (NSGs) to control traffic between subnets and restrict access.

### Security Implementation
- Using Azure Key Vault for secret management to securely store sensitive information like SSH keys.
- Restricting SSH access to the management subnet and allowing web traffic only through the load balancer.
- Enabling diagnostic settings and flow logs for monitoring and auditing purposes.

### High Availability
- Deploying web servers in an availability set to ensure high availability and fault tolerance.
- Using a load balancer to distribute web traffic across the web VMs.

### Storage Configuration
- Creating a GRS redundant storage account with containers for Terraform state and web logs.
- Restricting access to the storage account to the management subnet for enhanced security.

### Automation
- Automating the installation of Apache on web VMs using custom data scripts to ensure consistency and reduce manual intervention.

# Assumptions

### Azure Environment
- The deployment is assumed to be in an Azure environment with proper permissions and access to required Azure AD roles (Groups Administrator and Application Administrator).

### Terraform Version
- The solution assumes the use of Terraform version >= 1.1.7 and Azure provider version < 4.0 due to compatibility issues with Coalfire modules.

### Access Control
- SSH access to the management VM is restricted to a specific IP or network space, ensuring secure administrative access.
- Web VMs are only accessible through the load balancer, with no direct external access.

### Resource Naming
- Resource names and tags follow a consistent naming convention based on the provided default_config variables.

### State Management
- Terraform state files are managed remotely in an Azure Storage Account to enable collaboration and state consistency across deployments.

### Compliance and Best Practices
- The design follows Azure best practices and compliance requirements, such as using private DNS zones, enabling diagnostic logs, and implementing RBAC.

### Scalability
- The infrastructure is designed to be scalable, with the ability to add more VMs to the availability set and subnets as needed.


# References

### Modules

#### Coalfire
- github.com/Coalfire-CF/terraform-azurerm-security-core
- github.com/Coalfire-CF/terraform-azurerm-region-setup
- github.com/Coalfire-CF/ACE-Azure-Vnet?ref=module
- github.com/Coalfire-CF/terraform-azurerm-nsg
- github.com/Coalfire-CF/ACE-Azure-VM-AvailabilitySet?ref=v0.0.4

#### Hashicorp
- hashicorp/subnets/cidr

#### Other
- github.com/kylegill3/terraform-azurerm-load-balancer forked and edited from github.com/terraform-azurerm-modules/terraform-azurerm-load-balancer
- github.com/kylegill3/terraform-azurerm-linux-vm forked and edited from github.com/terraform-azurerm-modules/terraform-azurerm-linux-vm


# Challenge
- Decided early on to use Coalfire modules for all resources needing created
   - Saw all the storage accounts the coalfire modules created and decided I wouldn't create one as the challenge asked for that had both "terraformstate" and "weblogs" as these already appeared to be created. So I used the ones the base modules created.