variable info {
  type = object({
    domain      = string
    subdomain   = string
    environment = string
    sequence    = string
  })

}
variable tags {
  type        = map(string)
  description = "Tags object used to tag resources."
}
variable location {}
variable resource_group_name {}
variable sku_name {}
variable storage_mb {}
variable backup_retention_days {}
variable server_version {}


variable geo_redundant_backup_enabled {
    type    = bool
    default = true
}
variable auto_grow_enabled {
    type    = bool
    default = true
}

variable public_network_access_enabled {
    type    = bool
    default = true
}

variable ssl_enforcement_enabled {
    type    = bool
    default = true
}

variable administrator_login {
    type    = string
    default = "adminbcbsaz"
}

variable administrator_login_password {
  type = string
}

variable ignore_missing_vnet_service_endpoint {
    type    = bool
    default = true
}

variable subnet_whitelist {
  type        = any
  description = "List of objects that contains information to look up a subnet to whitelist."

  default = []

validation {
  condition = length(var.subnet_whitelist) > 0 ? length([
    for subnet in var.subnet_whitelist : true

      if lookup(subnet, "virtual_network_resource_group_name", null) != null &&
          lookup(subnet, "virtual_network_name", null) != null &&
          lookup(subnet, "virtual_network_subnet_name", null) != null

  ]) == length(var.subnet_whitelist) : true

  error_message = "Missing attribute detected."
}
}

# Below is a sample whitelisting a subnet from default subscription and a subnet from different subscription (Kubernetes-DevTest)
# subnet_whitelist = [
#   {
#     virtual_network_resource_group_name = "spokeVnetRg"
#     virtual_network_name                = "vnetVelConD01"
#     virtual_network_subnet_name         = "vnD01sn003"
#   },
#   {
#     virtual_network_resource_group_name = "spokeVnetRg"
#     virtual_network_name                = "vnetAKSinfraTestD01"
#     virtual_network_subnet_name         = "sbntAKSinfraTest01"
#     subscription                        = "Kubernetes-DevTest" 
#   }

# ]

variable ssl_minimal_tls_version_enforced {
    type    = string
    default = "TLS1_2"
}

variable "database_attributes" {
 type = list(object({
   name      = string
   charset   = string
   collation = string
  }
))
 default = [{
   name          = "bcbsaz_postgress"
   charset       = "UTF8"
   collation     = "English_United States.1252"
  }]

}   

variable ip_whitelist {
  type        = list(string)
  description = "List of public IP or IP ranges to allow."

  default = []
}

variable private_endpoint_subnet{
  type = object (
    {
      virtual_network_name                = string
      virtual_network_subnet_name         = string
      virtual_network_resource_group_name = string
    }
  )

  default = {
    virtual_network_name                = null
    virtual_network_subnet_name         = null
    virtual_network_resource_group_name = null
  }
}

variable private_endpoint_enabled {
    type    = bool
    default = true
}

variable ad_login_group {
  type = string
  description = "AD admin group"
}