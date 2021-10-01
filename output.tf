output "postgresql_fqdn" {
  value = azurerm_postgresql_server.postgresql_server.fqdn
}

output "name" {
  value = azurerm_postgresql_server.postgresql_server.name
}

// output "postgresql_username" {
//   value = "${local.postgresql_username}@${element(split(".", azurerm_postgresql_server.postgresql_server.fqdn), 0)}"
// }