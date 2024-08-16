
resource "azurerm_network_interface" "main" {
  count               = var.vm_count
  name                = "${var.vm_name_prefix}-nic-${count.index}"
  location            = azurerm_resource_group.main.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main[count.index].id
  }
}

resource "azurerm_public_ip" "main" {
  count               = var.vm_count
  name                = "${var.vm_name_prefix}-pip-${count.index}"
  location            = azurerm_resource_group.main.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
}

resource "azurerm_virtual_machine" "main" {
  count               = var.vm_count
  name                = "${var.vm_name_prefix}-${count.index}"
  location            = azurerm_resource_group.main.location
  resource_group_name = var.resource_group_name
  vm_size             = var.vm_size

  network_interface_ids = [
    azurerm_network_interface.main[count.index].id
  ]

  os_disk {
    caching           = "ReadWrite"
    managed_disk_type = "Standard_LRS"
    name              = "${var.vm_name_prefix}-osdisk-${count.index}"
    create_option     = "FromImage"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "${var.vm_name_prefix}-${count.index}"
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    environment = "Production"
  }
}

output "vm_ids" {
  value = azurerm_virtual_machine.main[*].id
}

output "vm_public_ips" {
  value = azurerm_public_ip.main[*].ip_address
}
