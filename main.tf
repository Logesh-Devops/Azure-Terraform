
provider "azurerm" {
  features = {}
}

resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "main" {
  name                = "main-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "main" {
  name                 = "main-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}

module "vm_instance" {
  source            = "./modules/vm_instance"
  count             = var.vm_count
  resource_group_name = azurerm_resource_group.main.name
  vm_name_prefix    = var.vm_name_prefix
  vm_size           = var.vm_size
  subnet_id         = azurerm_subnet.main.id
  admin_username    = var.admin_username
  admin_password    = var.admin_password
}

# Enable Azure Backup for VMs
resource "azurerm_backup_policy_vm" "backup_policy" {
  name                = "daily-backup-policy"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  retention_daily {
    count = 7
  }
}

resource "azurerm_backup_protected_vm" "protected_vm" {
  count        = var.vm_count
  backup_policy_id = azurerm_backup_policy_vm.backup_policy.id
  source_vm_id    = module.vm_instance.vm_ids[count.index]
}

# DR Setup: replicate VMs in a different region
resource "azurerm_virtual_machine" "dr" {
  count               = var.vm_count
  name                = "${var.vm_name_prefix}-dr-${count.index}"
  location            = var.dr_location
  resource_group_name = azurerm_resource_group.main.name
  vm_size             = var.vm_size

  network_interface_ids = [
    azurerm_network_interface.main[count.index].id
  ]

  os_disk {
    caching           = "ReadWrite"
    managed_disk_type = "Standard_LRS"
    name              = "${var.vm_name_prefix}-dr-osdisk-${count.index}"
    create_option     = "FromImage"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "${var.vm_name_prefix}-dr-${count.index}"
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

output "vm_public_ips" {
  value = module.vm_instance.vm_public_ips
}
