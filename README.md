# Postgresql
Terraform module that provisions a Postgresql server and database on Azure with firewall rule and integrated private endpoints.
## Usage
You can include the module by using the following code:

```
provider "azurerm" {
  
  features {}

}
# Resource Group Module
module "rg" {
  source = "git::git@ssh.dev.azure.com:v3/AZBlue/OneAZBlue/terraform.devops.resource-group?ref=v0.0.5"

  info = var.info
  tags = var.tags

  location = var.location
}

# Postgresql Module
module "postgresql" {
  source = "git::git@ssh.dev.azure.com:v3/AZBlue/OneAZBlue/terraform.devops.postgresql?ref=v0.0.3"
  
  info = var.info
  tags = var.tags
  
  # Resource Group
  resource_group_name  = module.rg.name
  location             = var.location
  
  database_attributes   = var.database_attributes
  postgresql_subnet     = var.postgresql_subnet
  sku_name              = var.sku_name
  storage_mb            = var.storage_mb
  backup_retention_days = var.backup_retention_days
  server_version        = var.server_version
  
  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_login_password
  ad_login                     = var.ad_login
  ip_whitelist                 = var.ip_whitelist
  subnet_whitelist             = var.subnet_whitelist

  #private endpoint
  private_endpoint_subnet  = var.private_endpoint_subnet
  private_endpoint_enabled = var.private_endpoint_enabled
  
}
```
## Inputs

The following are the supported inputs for the module.

| Name                          | Description                                                                                                                                                                                                                                                    | Type             | Default                                                                                 |             Required             |
| ----------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- | --------------------------------------------------------------------------------------- | :------------------------------: |
| info                          | Info object used to construct naming convention for all resources.                                                                                                                                                                                             | `object`         | n/a                                                                                     |               yes                |
| tags                          | Tags object used to tag resources.                                                                                                                                                                                                                             | `object`         | n/a                                                                                     |               yes                |
| resource_group                | Name of the resource group where the postgresql will be deployed.                                                                                                                                                                                              | `string`         | n/a                                                                                     |               yes                |
| database_attributes           | Attributes  of posgresql database.                                                                                                                                                                                                                             | `list of object` | '{name = "bcbsaz-postgress" charset = "UTF8" collation = "English_United States.1252"}' |               yes                |
| sku_name                      | Specifies the SKU Name for this PostgreSQL Server. The name of the SKU, follows the tier + family + cores pattern (e.g. B_Gen4_1, GP_Gen5_8). For more information see the product documentation.                                                              | `string`         | n/a                                                                                     |               yes                |
| location                      | Location of posgresql server and database.                                                                                                                                                                                                                     | `string`         | n/a                                                                                     |               yes                |
| administrator_login           | The Administrator Login for the PostgreSQL Server. Required when create_mode is Default. Changing this forces a new resource to be created.                                                                                                                    | `string`         |                                                                                         |                no                |
| administrator_login_password  | The Password associated with the administrator_login for the PostgreSQL Server. Required when create_mode is Default.                                                                                                                                          | `string`         | n/a                                                                                     |                no                |
| ad_login                      | The login name of the principal to set as the server administrator                                                                                                                                                                                             | `string`         | n/a                                                                                     |   required for ad integration    |
| storage_mb                    | Max storage allowed for a server. Possible values are between 5120 MB(5GB) and 1048576 MB(1TB) for the Basic SKU and between 5120 MB(5GB) and 16777216 MB(16TB) for General Purpose/Memory Optimized SKUs. For more information see the product documentation. | `number`         | n/a                                                                                     |                no                |
| backup_retention_days         | Backup retention days for the server, supported values are between 7 and 35 days                                                                                                                                                                               | `number`         | n/a                                                                                     |                no                |
| public_network_access_enabled | Whether or not public network access is allowed for this server                                                                                                                                                                                                | `bool`           | `true`                                                                                  |                no                |
| server_version                | Specifies the version of PostgreSQL to use. Valid values are 9.5, 9.6, 10, 10.0, and 11. Changing this forces a new resource to be created.                                                                                                                    | `number`         | n/a                                                                                     |               yes                |
| ip_whitelist                  | List of  IP Addresses associated with this Firewall Rule. Changing this forces a new resource to be created.                                                                                                                                                   | `List(string)`   | n/a                                                                                     |               yes                |
| subnet_whitelist              | List of objects that contains information to look up a subnet. This is a whitelist of subnets to allow for the postgresql server.                                                                                                                              | `list(object)`   | `[]`                                                                                    |                no                |
| private_endpoint_subnet       | List of objects of the subnet information that private endpoint will be created.                                                                                                                                                                               | `list of object` | []                                                                                      | yes, if private_endpoint_enabled |
| private_endpoint_enabled      | Enable the private endpoint integration                                                                                                                                                                                                                        | `bool`           | `true`                                                                                  |                no                |
