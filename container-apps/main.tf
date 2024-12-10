resource "azurerm_container_app_environment" "confiz_container_app_env" {
  name                = "confiz-container-app-env"
  location            = azurerm_resource_group.confiz_rg.location
  resource_group_name = azurerm_resource_group.confiz_rg.name
  tags = {
    environment = "dev"
    name        = "confiz"
  }
}


resource "azurerm_container_app" "confiz_container_app" {
  name                         = "confiz-container-app"
  resource_group_name          = azurerm_resource_group.confiz_rg.name
  container_app_environment_id = azurerm_container_app_environment.confiz_container_app_env.id
  revision_mode                = "Multiple"

  template {
    container {
      name   = "demo-container"
      image  = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
      cpu    = 0.5
      memory = "1.0Gi"
    }
  }

  ingress {
    allow_insecure_connections = true
    external_enabled           = true
    target_port                = 80
    transport                  = "http"
    traffic_weight {
      latest_revision = true
      percentage = 100
    }
  }

  tags = {
    environment = "dev"
    name        = "confiz"
  }
}