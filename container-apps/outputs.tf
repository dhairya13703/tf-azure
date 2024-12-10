output "azurerm_container_app_url" {
  value = azurerm_container_app.confiz_container_app.latest_revision_fqdn
}

output "azurerm_container_app_revision_name" {
  value = azurerm_container_app.confiz_container_app.latest_revision_name
}

# output "sql_server_name" {
#   value = azurerm_mssql_server.sql_server.name
# }

# output "sql_database_name" {
#   value = azurerm_mssql_database.sql_db.name
# }

# output "sql_connection_string" {
#   value     = "Server=${azurerm_mssql_server.sql_server.fully_qualified_domain_name};Database=${azurerm_mssql_database.sql_db.name};User Id=${azurerm_mssql_server.sql_server.administrator_login};Password=${random_password.sql_password.result};TrustServerCertificate=True"
#   sensitive = true
# }

# output "cosmos_account_name" {
#   value = azurerm_cosmosdb_account.cosmos.name
# }

# output "cosmos_database_name" {
#   value = azurerm_cosmosdb_sql_database.db.name
# }

# output "cosmos_connection_string" {
#   value     = azurerm_cosmosdb_account.cosmos.primary_sql_connection_string
#   sensitive = true
# }