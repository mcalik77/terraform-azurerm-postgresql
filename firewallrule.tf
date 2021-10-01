

resource "azurerm_postgresql_firewall_rule" "postgresql_firewall_rule" {
  
 for_each = {
   for index, ip_address in var.ip_whitelist: index => ip_address
  }
  
  name                = "firewall-rule${each.key}"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.postgresql_server.name
  start_ip_address    = each.value
  end_ip_address      = each.value

  depends_on = [azurerm_postgresql_database.postgresql]
}