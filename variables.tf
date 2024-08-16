
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "terraform-rg"
}

variable "location" {
  description = "Azure location"
  type        = string
  default     = "East US"
}

variable "dr_location" {
  description = "Azure DR location"
  type        = string
  default     = "West US"
}

variable "vm_count" {
  description = "Number of VMs to provision"
  type        = number
  default     = 20
}

variable "vm_name_prefix" {
  description = "Prefix for VM names"
  type        = string
  default     = "terraform-vm"
}

variable "vm_size" {
  description = "VM size"
  type        = string
  default     = "Standard_B2ms"
}

variable "admin_username" {
  description = "Admin username for the VM"
  type        = string
}

variable "admin_password" {
  description = "Admin password for the VM"
  type        = string
}
