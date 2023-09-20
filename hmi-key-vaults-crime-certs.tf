locals {
  crime_cert_kv_name = var.env == "prod" ? "hmi-crime-prod" : "hmi-crime-non-prod"
}

data "azurerm_key_vault_certificate" "crime_bootstrap_cert" {
  name         = local.crime_cert_kv_name
  key_vault_id = data.azurerm_key_vault.bootstrap_kv.id
}

resource "azurerm_key_vault_certificate" "crime_hmi_kv_cert" {
  name         = data.azurerm_key_vault_certificate.crime_bootstrap_cert.name
  key_vault_id = module.kv_hmi.key_vault_id

  certificate {
    contents = data.azurerm_key_vault_certificate.crime_bootstrap_cert.value
  }

  certificate_policy {
    issuer_parameters {
      name = "self"
    }

    key_properties {
      exportable = true
      key_size   = data.azurerm_key_vault_certificate.crime_bootstrap_cert.certificate_policy.0.key_properties.0.key_size
      key_type   = data.azurerm_key_vault_certificate.crime_bootstrap_cert.certificate_policy.0.key_properties.0.key_type
      reuse_key  = true
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }

  }
  tags = var.common_tags
}
