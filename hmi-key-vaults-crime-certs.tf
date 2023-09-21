locals {
  crime_cert_kv_name          = "hmi-crime-cert-${var.env}"
  crime_cert_kv_password_name = "hmi-crime-cert-password"
}

data "azurerm_key_vault_certificate" "crime_bootstrap_cert" {
  name         = local.crime_cert_kv_name
  key_vault_id = data.azurerm_key_vault.bootstrap_kv.id
}

data "azurerm_key_vault_secret" "crime_bootstrap_cert_password" {
  name         = local.crime_cert_kv_password_name
  key_vault_id = module.kv_hmi.key_vault_id
}

resource "azurerm_key_vault_certificate" "import_crime_cert" {
  name         = data.azurerm_key_vault_certificate.crime_bootstrap_cert.name
  key_vault_id = module.kv_hmi.key_vault_id

  certificate {
    contents = data.azurerm_key_vault_certificate.crime_bootstrap_cert.certificate_contents
    password = data.azurerm_key_vault_secret.crime_bootstrap_cert_password.value
  }
}