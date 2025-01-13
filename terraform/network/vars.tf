variable "default_config" {
  description = "Default configuration object"
  type = object({
    subscription_id         = string
    tenant_id               = string
    location                = string
    location_abbreviation   = string
    app_abbreviation        = string
    cidrs_for_remote_access = list(string)
    ip_for_remote_access    = list(string)
    admin_principal_ids     = list(string)
    domain_name             = string
    app_subscription_ids    = map(string)
    regional_tags           = map(string)
    global_tags             = map(string)
    security_core = object({
      azure_private_dns_zones = list(string)
    })
  })
}

variable "mgmt_network_cidr" {
  type        = string
  description = "The CIDR block for the management network"
  default     = "10.0.0.0/16"

}
