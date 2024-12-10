
variable "environment" {
  default = "dev"
}

# App Service Plan
resource "azurerm_service_plan" "asp" {
  name                = "asp-reactapp-${var.environment}"
  resource_group_name = data.azurerm_resource_group.confiz_rg.name
  location           = data.azurerm_resource_group.confiz_rg.location
  os_type            = "Linux"
  sku_name           = "B1"
}

# App Service
resource "azurerm_linux_web_app" "app" {
  name                = "app-reactapp-${var.environment}"
  resource_group_name = data.azurerm_resource_group.confiz_rg.name
  location           = data.azurerm_resource_group.confiz_rg.location
  service_plan_id    = azurerm_service_plan.asp.id

  site_config {
    application_stack {
      node_version = "18-lts"
    }
  }
}

# Public IP for App Gateway
resource "azurerm_public_ip" "pip" {
  name                = "pip-agw-${var.environment}"
  resource_group_name = data.azurerm_resource_group.confiz_rg.name
  location           = data.azurerm_resource_group.confiz_rg.location
  allocation_method  = "Static"
  sku               = "Standard"
}

# Application Gateway
resource "azurerm_application_gateway" "agw" {
  name                = "agw-reactapp-${var.environment}"
  resource_group_name = data.azurerm_resource_group.confiz_rg.name
  location           = data.azurerm_resource_group.confiz_rg.location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "gateway-ip-configuration"
    subnet_id = data.azurerm_subnet.appservice-subnet.id
  }

  frontend_port {
    name = "frontend-port-80"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "frontend-ip-configuration"
    public_ip_address_id = azurerm_public_ip.pip.id
  }

  backend_address_pool {
    name = "backend-pool"
    fqdns = [azurerm_linux_web_app.app.default_hostname]
  }

  backend_http_settings {
    name                  = "backend-http-settings"
    cookie_based_affinity = "Disabled"
    port                 = 80
    protocol             = "Http"
    request_timeout      = 60
    probe_name           = "health-probe"
  }

  probe {
    name                = "health-probe"
    host                = azurerm_linux_web_app.app.default_hostname
    path                = "/"
    interval            = 30
    timeout             = 30
    unhealthy_threshold = 3
    protocol            = "Http"
  }

  http_listener {
    name                           = "http-listener"
    frontend_ip_configuration_name = "frontend-ip-configuration"
    frontend_port_name            = "frontend-port-80"
    protocol                      = "Http"
  }

  request_routing_rule {
    name                       = "routing-rule"
    priority                   = 1
    rule_type                 = "Basic"
    http_listener_name        = "http-listener"
    backend_address_pool_name = "backend-pool"
    backend_http_settings_name = "backend-http-settings"
  }
}

# CDN Profile
resource "azurerm_cdn_profile" "cdn" {
  name                = "cdn-reactapp-${var.environment}"
  location           = data.azurerm_resource_group.confiz_rg.location
  resource_group_name = data.azurerm_resource_group.confiz_rg.name
  sku                = "Standard_Microsoft"
}

# CDN Endpoint
resource "azurerm_cdn_endpoint" "cdn_endpoint" {
  name                = "cdnep-reactapp-${var.environment}"
  profile_name        = azurerm_cdn_profile.cdn.name
  location           = data.azurerm_resource_group.confiz_rg.location
  resource_group_name = data.azurerm_resource_group.confiz_rg.name

  origin {
    name       = "app-gateway-origin"
    host_name  = azurerm_public_ip.pip.ip_address
  }

  origin_host_header = azurerm_public_ip.pip.ip_address
}
