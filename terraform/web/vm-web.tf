module "ubu-web" {
  source   = "github.com/kylegill3/terraform-azurerm-linux-vm"
  defaults = local.vm_web_defaults

  names = ["ubu-web-01", "ubu-web-02"]

  availability_set_id = module.avd_availability_set.availability_set_id

  load_balancer_backend_address_pools = [{
    name = "web-traffic"
    id   = module.web_lb.load_balancer_backend_address_pool.id
  }]

  source_image_reference = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  custom_data = base64encode(<<-EOF
    #!/bin/bash
    sudo apt-get update -y
    sudo apt-get install apache2 -y
    sudo systemctl enable apache2
    sudo systemctl start apache2
    EOF
  )
  module_depends_on = [resource.azurerm_key_vault_secret.ssh_private_key_web]
}