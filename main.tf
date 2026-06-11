# Create a resource group
resource "azurerm_resource_group" "testrg" {
  name     = "rgsp"
  location = "West us"
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "vnsp" {
  name                = "vnsp"
  resource_group_name = "rgsp"
  location            = "west us"
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "snsp" {
  name                 = "snsp"
  resource_group_name  = "rgsp"
  virtual_network_name = "vnsp"
  address_prefixes     = ["10.0.1.0/24"]

}

resource "azurerm_public_ip" "pip" {
  name                = "demo-pip"
  location            = "West US"
  resource_group_name = "rgsp"

  allocation_method = "Static"
  sku               = "Standard"
}

resource "azurerm_network_interface" "nic" {
  name                = "demo-nic"
  location            = "West Us"
  resource_group_name = "rgsp"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.snsp.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}


resource "azurerm_linux_virtual_machine" "vmsp" {
  name                = "vmsp"
  resource_group_name = "rgsp"
  location            = "East US"
  size                = "Standard_B1ms"

  admin_username = "azureuser"
  admin_password = "Password@1234"

  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]

  os_disk {
    name                 = "demo-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}