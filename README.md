# Azure Windows VM Deployment with Terraform

This project uses Terraform to deploy infrastructure on Microsoft Azure.  
It includes:

- Azure Resource Group
- Virtual Network (VNet) with two subnets
- Network Security Group (NSG) allowing RDP (port 3389)
- Public IP Address
- Network Interface (NIC)
- Windows Virtual Machine (VM)

## How to Use

1. Clone the repository.
2. Set your Azure credentials using environment variables or terraform.tfvars (not included here for security).
3. Run:
   ```bash
   terraform init
   terraform plan
   terraform apply

