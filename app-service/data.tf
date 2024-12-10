data "azurerm_resource_group" "confiz_rg" {
  name = "confiz-rg"
}

data "azurerm_virtual_network" "confiz_vnet" {
  name                = "confiz-vnet"
  resource_group_name = data.azurerm_resource_group.confiz_rg.name
}

data "azurerm_subnet" "appservice-subnet" {
  name                 = "appservice-subnet"
  virtual_network_name = data.azurerm_virtual_network.confiz_vnet.name
  resource_group_name  = data.azurerm_resource_group.confiz_rg.name
}