data "azuread_group" "ad_group" {
  display_name     = var.ad_login_group
}
data "azurerm_client_config" "current" {}

resource "azurerm_postgresql_active_directory_administrator" "active_directory" {
  server_name         = azurerm_postgresql_server.postgresql_server.name
  resource_group_name = var.resource_group_name
  login               = var.ad_login_group
  tenant_id           = data.azurerm_client_config.current.tenant_id
  object_id           = data.azuread_group.ad_group.object_id
}