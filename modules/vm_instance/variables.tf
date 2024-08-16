
variable "vm_count" {
  description = "Number of VMs to create"
  type        = number
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "vm_name_prefix" {
  description = "Prefix for VM names"
  type        = string
}

variable "vm_size" {
  description = "VM size"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet"
  type        = string
}

variable "admin_username" {
  description = "Admin username for the VM"
  type        = string
}

variable "admin_password" {
  description = "Admin password for the VM"
  type        = string
}
