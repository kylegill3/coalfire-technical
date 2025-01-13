module "ubu-mgmt" {
  source   = "github.com/kylegill3/terraform-azurerm-linux-vm"
  defaults = local.vm_mgmt_defaults

  names = ["ubu-mgmt-01"]
  source_image_reference = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
  module_depends_on = [resource.azurerm_key_vault_secret.ssh_private_key_mgmt]
}