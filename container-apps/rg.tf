resource "azurerm_resource_group" "confiz_rg" {
  name     = "confiz-rg"
  location = "eastus"
  tags = {
    environment = "dev"
    name        = "confiz"
  }
}