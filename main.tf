# Create a resource group
resource "azurerm_resource_group" "testrg" {
  name     = "rgsp"
  location = "West Europe"
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "vnsp" {
  name                = "vnsp"
  resource_group_name = "rgsp"
  location            = "west us"
  address_space       = ["10.0.0.0/16"]
}