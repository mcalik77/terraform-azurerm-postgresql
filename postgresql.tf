# data azurerm_subnet "postgresql_subnet" {
  
#   resource_group_name  = var.postgresql_subnet.virtual_network_resource_group_name
#   virtual_network_name = var.postgresql_subnet.virtual_network_name
#   name                 = var.postgresql_subnet.virtual_network_subnet_name
# }

locals {
  subscriptions = {
    Infra-Opscore-DevTest       = "02b47050-0fc9-43cd-9017-1b250288af03",
    Infra-Opscore-Production    = "7e01a526-af7b-4ab3-9aaf-e9e541a7c684",
    Kubernetes-DevTest          = "081b69e2-3141-4fad-af19-9f20d42201ab",
    Velocity-Connect-DevTest    = "8fa861fe-6a38-4b52-bc30-4df1ac4a70b5",
    Velocity-Connect-Production = "1d834cda-73f2-4065-b96d-187dacbc2dd9"
  }

  default_subscription = {
    subscription = data.azurerm_subscription.subscription.display_name
  }

  subnet_whitelist = [
    for subnet in var.subnet_whitelist :
      merge(local.default_subscription, subnet)
  ]

  subnet_ids = [
    for subnet in local.subnet_whitelist :
      format("%s%s%s%s%s",
        "/subscriptions/${local.subscriptions[subnet.subscription]}",
        "/resourceGroups/${subnet.virtual_network_resource_group_name}",
        "/providers/Microsoft.Network",
        "/virtualNetworks/${subnet.virtual_network_name}",
        "/subnets/${subnet.virtual_network_subnet_name}"
      )
  ]
}

data azurerm_subscription subscription {}

resource azurerm_postgresql_database postgresql {
  for_each = {
    for index, attribute in var.database_attributes: index => attribute
  }
  name                = each.value.name
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.postgresql_server.name
  charset             = each.value.charset
  collation           = each.value.collation

}
resource "azurerm_postgresql_virtual_network_rule" "example" {
  for_each = {
     for index, subnet in local.subnet_ids : index => subnet
  }
  
  name                                 = replace(format("%s%s%03d",
      substr(
        module.naming.postgresql_virtual_network_rule.name, 0, 
        module.naming.postgresql_virtual_network_rule.max_length - 4
      ),
      substr(title(var.info.environment), 0, 1),
      title(var.info.sequence)
    ), "-", ""
  )

  resource_group_name                  = var.resource_group_name
  server_name                          = azurerm_postgresql_server.postgresql_server.name
  subnet_id                            = each.value
  ignore_missing_vnet_service_endpoint = var.ignore_missing_vnet_service_endpoint
}