resource "azurerm_resource_group" "appygrp" {
  name     = "app-grp"
  location = local.resource_location
}

resource "azurerm_virtual_network" "appynetwork" {
  name                = local.virtual_network.name
  location            = local.resource_location
  resource_group_name = azurerm_resource_group.appygrp.name
  address_space       = local.virtual_network.address_prefixes 
}

resource "azurerm_subnet" "Anky" {
  name                 = local.subnets[0].name
  resource_group_name  = azurerm_resource_group.appygrp.name
  virtual_network_name = azurerm_virtual_network.appynetwork.name
  address_prefixes     = local.subnets[0].address_prefixes
}

resource "azurerm_subnet" "Andy" {
  name                 = local.subnets[1].name
  resource_group_name  = azurerm_resource_group.appygrp.name
  virtual_network_name = azurerm_virtual_network.appynetwork.name
  address_prefixes     = local.subnets[1].address_prefixes
}

resource "azurerm_network_interface" "Weby" {
  name                = "Weby"
  location            = local.resource_location
  resource_group_name = azurerm_resource_group.appygrp.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.Anky.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.Webyip.id
  }
}

resource "azurerm_public_ip" "Webyip" {
  name                = "Webyip"
  resource_group_name = azurerm_resource_group.appygrp.name
  location            = local.resource_location
  allocation_method   = "Static"
}

resource "azurerm_network_security_group" "app_nsg" {
  name                = "app-nsg"
  location            = local.resource_location
  resource_group_name = azurerm_resource_group.appygrp.name

  security_rule {
    name                       = "AllowRDP"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "websubnet01_appnsg" {
  subnet_id                 = azurerm_subnet.Anky.id
  network_security_group_id = azurerm_network_security_group.app_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "appsubnet01_appnsg" {
  subnet_id                 = azurerm_subnet.Andy.id
  network_security_group_id = azurerm_network_security_group.app_nsg.id
}


resource "azurerm_windows_virtual_machine" "Alucard" {
  name                = "Alucard"
  resource_group_name = azurerm_resource_group.appygrp.name
  location            = local.resource_location
  size                = "Standard_B2s"
  admin_username      = "Natlan"
  admin_password      = "Rasgulla@123"
  
  network_interface_ids = [
    azurerm_network_interface.Weby.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }
}
