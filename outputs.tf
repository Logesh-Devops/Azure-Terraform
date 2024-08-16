
output "vm_public_ips" {
  description = "Public IP addresses of the provisioned VMs"
  value       = module.vm_instance.vm_public_ips
}
