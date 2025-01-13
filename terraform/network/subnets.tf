module "subnet_addrs" {
  source          = "hashicorp/subnets/cidr"
  base_cidr_block = var.mgmt_network_cidr
  networks = [
    {
      name     = "${var.default_config.app_abbreviation}-application-sn-1"
      new_bits = 8
    },
    {
      name     = "${var.default_config.app_abbreviation}-management-sn-1"
      new_bits = 8
    },
    {
      name     = "${var.default_config.app_abbreviation}-backend-sn-1"
      new_bits = 8
    },
    {
      name     = "${var.default_config.app_abbreviation}-web-sn-1"
      new_bits = 8
    }
  ]
}