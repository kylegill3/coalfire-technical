module "web_lb" {
  source   = "github.com/kylegill3/terraform-azurerm-load-balancer"
  defaults = local.load_balancer_defaults
  name     = "${var.default_config.app_abbreviation}-lb"

  load_balancer_rules = [
    { protocol = "Tcp", frontend_port = 80, backend_port = 80 },
    { protocol = "Tcp", frontend_port = 443, backend_port = 443 }
  ]
}