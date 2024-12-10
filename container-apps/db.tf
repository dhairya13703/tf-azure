
# # SQL Server
# resource "azurerm_mssql_server" "sql_server" {
#   name                         = "sql-microservices-demo-${random_string.suffix.result}"
#   resource_group_name          = azurerm_resource_group.confiz_rg.name
#   location                     = azurerm_resource_group.confiz_rg.location
#   version                      = "12.0"
#   administrator_login          = "sqladmin"
#   administrator_login_password = random_password.sql_password.result
# }

# # SQL Database
# resource "azurerm_mssql_database" "sql_db" {
#   name           = "sqldb-products"
#   server_id      = azurerm_mssql_server.sql_server.id
#   sku_name       = "Basic"
#   max_size_gb    = 2
# }

# # Allow Azure services to access SQL Server
# resource "azurerm_mssql_firewall_rule" "sql_fw_rule" {
#   name             = "AllowAzureServices"
#   server_id        = azurerm_mssql_server.sql_server.id
#   start_ip_address = "0.0.0.0"
#   end_ip_address   = "0.0.0.0"
# }

# # Cosmos DB Account
# resource "azurerm_cosmosdb_account" "cosmos" {
#   name                = "cosmos-microservices-${random_string.suffix.result}"
#   location            = azurerm_resource_group.confiz_rg.location
#   resource_group_name = azurerm_resource_group.confiz_rg.name
#   offer_type         = "Standard"
#   kind               = "GlobalDocumentDB"

#   consistency_policy {
#     consistency_level = "Session"
#   }

#   geo_location {
#     location          = azurerm_resource_group.confiz_rg.location
#     failover_priority = 0
#   }
# }

# # Cosmos DB Database
# resource "azurerm_cosmosdb_sql_database" "db" {
#   name                = "cosmosdb-orders"
#   resource_group_name = azurerm_resource_group.confiz_rg.name
#   account_name        = azurerm_cosmosdb_account.cosmos.name
# }

# # Random string for unique names
# resource "random_string" "suffix" {
#   length  = 6
#   special = false
#   upper   = false
# }

# # Random password for SQL Server
# resource "random_password" "sql_password" {
#   length           = 16
#   special          = true
#   override_special = "!#$%&*()-_=+[]{}<>:?"
# }
