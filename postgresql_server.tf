provider "azurerm" {
  
  features {}

}

locals {
domain    = title(var.info.domain)
subdomain = title(var.info.subdomain)
subproject = "${local.domain}${local.subdomain}"

}

module naming {
  source  = "github.com/Azure/terraform-azurerm-naming?ref=df6a893e8581ae2078fc40f65d3b9815ef86ac3d"
  // version = "0.1.0"
  suffix  = [ "${title(var.info.domain)}${title(var.info.subdomain)}" ]
}


resource azurerm_postgresql_server postgresql_server {
  name                = replace(format("%s%s%03d",
      lower(substr(
        module.naming.postgresql_server.name, 0, 
        module.naming.postgresql_server.max_length - 4
      )),
      lower(substr(title(var.info.environment), 0, 1)),
      title(var.info.sequence)
    ), "-", ""
  )
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = var.sku_name

  storage_mb                    = var.storage_mb
  backup_retention_days         = var.backup_retention_days
  geo_redundant_backup_enabled  = var.geo_redundant_backup_enabled
  auto_grow_enabled             = var.auto_grow_enabled
  public_network_access_enabled = var.public_network_access_enabled    

  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_login_password
  version                      = var.server_version

  ssl_enforcement_enabled          = var.ssl_enforcement_enabled
  ssl_minimal_tls_version_enforced = var.ssl_minimal_tls_version_enforced
}
