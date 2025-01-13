locals {
  core_output = {
    core_rg_name             = module.core.core_rg_name
    core_la_id               = module.core.core_la_id
    core_la_workspace_id     = module.core.core_la_workspace_id
    core_kv_id               = module.core.core_kv_id
    core_private_dns_zone_id = module.core.core_private_dns_zone_id
  }
}