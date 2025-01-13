# Generate SSH key
resource "tls_private_key" "ssh_web" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Store private key in Key Vault
resource "azurerm_key_vault_secret" "ssh_private_key_web" {
  name         = "${var.default_config.app_abbreviation}-ssh-private-key-web"
  value        = tls_private_key.ssh_web.private_key_pem
  key_vault_id = data.terraform_remote_state.security-core.outputs.core_output.core_kv_id
}