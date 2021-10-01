module private_endpoint {
  
  source = "git::git@ssh.dev.azure.com:v3/AZBlue/OneAZBlue/terraform.devops.private-endpoint?ref=v0.0.6"

  info = var.info
  tags = var.tags
  resource_group_name = var.resource_group_name
  location            = var.location

  count             = var.private_endpoint_enabled ? 1:0
  resource_id       = azurerm_postgresql_server.postgresql_server.id
  subresource_names = ["postgresqlServer"]

  private_endpoint_subnet = var.private_endpoint_subnet
}