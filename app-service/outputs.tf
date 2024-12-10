output "app_service_url" {
  value = "https://${azurerm_linux_web_app.app.default_hostname}"
}

output "application_gateway_ip" {
  value = azurerm_public_ip.pip.ip_address
}

output "cdn_endpoint_url" {
  # value = "https://${azurerm_cdn_endpoint.cdn_endpoint.host_name}"
  value = azurerm_cdn_endpoint.cdn_endpoint.fqdn
}