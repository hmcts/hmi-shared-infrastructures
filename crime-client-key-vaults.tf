locals {
  crime_bootstrap_secrets = ["hmi-crime-client-id", "hmi-crime-client-pwd"]
  crime_key_vault_name    = "${var.product}-sds-kv-${var.env}-shared-crime"
}

# KV for Crime to access secrets needed to authenticate with HMI 
module "kv_crime" {
  source                  = "git@github.com:hmcts/cnp-module-key-vault?ref=master"
  name                    = local.crime_key_vault_name
  product                 = var.product
  env                     = var.env
  object_id               = var.jenkins_identity_object_id
  resource_group_name     = azurerm_resource_group.rg.name
  product_group_name      = var.active_directory_group
  common_tags             = var.common_tags
  create_managed_identity = false
}

data "azurerm_key_vault_secret" "crime_bootstrap_secrets" {
  for_each     = { for secret in local.crime_bootstrap_secrets : secret => secret }
  name         = each.value
  key_vault_id = data.azurerm_key_vault.bootstrap_kv.id
}

module "crime_keyvault_bootstrap_secrets" {
  source = "./modules/kv_secrets"

  key_vault_id = module.kv_crime.key_vault_id
  tags         = var.common_tags
  secrets = [
    for secret in data.azurerm_key_vault_secret.crime_bootstrap_secrets : {
      name  = secret.name
      value = secret.value
      tags = {
        "source" : "bootstrap ${data.azurerm_key_vault.bootstrap_kv.name} secrets"
      }
      content_type = ""
    }
  ]
  depends_on = [
    module.kv_crime
  ]
}