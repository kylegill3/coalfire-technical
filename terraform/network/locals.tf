locals {
  global_local_tags = {
    costcenter = "12345"
  }
  mgmt_vnet_output = {
    vnet_id   = module.mgmt-vnet.vnet_id
    vnet_name = module.mgmt-vnet.vnet_name
    subnets   = module.mgmt-vnet.vnet_subnets
  }
}