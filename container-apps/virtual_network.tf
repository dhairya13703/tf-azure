resource "azurerm_virtual_network" "confiz_vnet" {
  name                = "confiz-vnet"
  resource_group_name = azurerm_resource_group.confiz_rg.name
  location            = azurerm_resource_group.confiz_rg.location
  address_space       = ["10.0.0.0/16"]

  tags = {
    environment = "dev"
    name        = "confiz"
  }
}

resource "azurerm_subnet" "appservice_subnet" {
  name                 = "appservice-subnet"
  address_prefixes     = ["10.0.1.0/24"]
  resource_group_name  = azurerm_resource_group.confiz_rg.name
  virtual_network_name = azurerm_virtual_network.confiz_vnet.name
}

resource "azurerm_subnet" "container_app_subnet" {
  name                 = "container-app-subnet"
  address_prefixes     = ["10.0.2.0/24"]
  resource_group_name  = azurerm_resource_group.confiz_rg.name
  virtual_network_name = azurerm_virtual_network.confiz_vnet.name
}

resource "azurerm_subnet" "integration_subnet" {
  name                 = "integration-subnet"
  address_prefixes     = ["10.0.3.0/24"]
  resource_group_name  = azurerm_resource_group.confiz_rg.name
  virtual_network_name = azurerm_virtual_network.confiz_vnet.name
}

resource "azurerm_network_security_group" "confiz_nsg" {
  name                = "confiz-nsg"
  location            = azurerm_resource_group.confiz_rg.location
  resource_group_name = azurerm_resource_group.confiz_rg.name

  security_rule {
    name                       = "AllowAll"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}