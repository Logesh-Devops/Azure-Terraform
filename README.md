
# Azure VM Provisioning with Terraform

This Terraform project provisions 20-30 virtual machines (VMs) on Microsoft Azure, enabling monitoring, backups, and disaster recovery (DR) setup with a single click. The script is modular, allowing for easy customization and scaling.

## Project Structure

```plaintext
.
├── main.tf                # Main Terraform script
├── variables.tf           # Variables used across the project
├── outputs.tf             # Outputs for the project
├── modules/
│   └── vm_instance/       # Module for creating VM instances
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
└── dr.tfvars              # Variables for DR environment
```

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) installed
- Azure account with appropriate permissions
- Azure CLI configured (`az login`)
- Service principal for Terraform configured (optional)

## Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/your-repo/azure-vm-terraform.git
cd azure-vm-terraform
```

### 2. Configure Variables

Edit the `variables.tf` file in the root module to set your desired configurations:

- `resource_group_name`: Name of the resource group to create or use.
- `location`: Azure region for the primary resources.
- `dr_location`: Azure region for DR resources.
- `vm_count`: Number of VMs to provision.
- `vm_name_prefix`: Prefix for VM names.
- `admin_username` and `admin_password`: Credentials for VMs.

### 3. Initialize Terraform

```bash
terraform init
```

### 4. Plan and Apply

Generate an execution plan:

```bash
terraform plan
```

Apply the Terraform configuration to create the resources:

```bash
terraform apply
```

### 5. DR Execution (Optional)

To provision the Disaster Recovery environment:

```bash
terraform apply -var-file="dr.tfvars"
```

## Outputs

- **vm_public_ips**: Public IP addresses of the provisioned VMs.
- **vm_ids**: IDs of the provisioned VMs.

## Monitoring and Backups

- **Monitoring**: You can integrate Azure Monitor with these VMs for enhanced monitoring and alerting.
- **Backups**: Azure Backup is configured for daily snapshots with a retention period of 7 days.

## Disaster Recovery

The DR setup provisions VMs in a different Azure region, using the same configurations as the primary VMs. This setup ensures high availability and quick recovery in the event of a regional failure.

## Cleaning Up

To destroy the resources and clean up your Azure environment:

```bash
terraform destroy
```

## Customization

You can customize this project by modifying the following:

- **VM Size**: Adjust the `vm_size` variable in `variables.tf`.
- **Monitoring Agent**: Add additional configurations in the `metadata_startup_script` of the VM instances.

## Contributing

Feel free to submit issues or pull requests if you have suggestions or improvements.

## License

This project is licensed under the MIT License.
