# Generate SSH key
resource "tls_private_key" "ssh_mgmt" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Store private key in Key Vault
resource "azurerm_key_vault_secret" "ssh_private_key_mgmt" {
  name         = "${var.default_config.app_abbreviation}-ssh-private-key-mgmt"
  value        = tls_private_key.ssh_mgmt.private_key_pem
  key_vault_id = data.terraform_remote_state.security-core.outputs.core_output.core_kv_id
}