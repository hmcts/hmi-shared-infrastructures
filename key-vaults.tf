locals {
  key_vault_name = "${var.product}-kv-${var.env}"
  secret_expiry = "2024-03-01T01:00:00Z"
  bootstrap_secrets = ["hmi-url", "tenant-id", "hmi-gateway-scope", "hmi-dtu-id", "hmi-dtu-pwd", "sn-assignment-group", "sn-caller-id", "sn-password", "sn-role-type", "sn-service-offering", "sn-url", "sn-username"]
  bootstrap_prefix = "${var.product}-bootstrap"
}

module "kv_hmi" {
  source                      = "git@github.com:hmcts/cnp-module-key-vault?ref=master"
  name                        = local.key_vault_name
  product                     = var.product
  env                         = var.env
  object_id                   = var.jenkins_identity_object_id
  resource_group_name         = data.azurerm_resource_group.rg.name
  product_group_name          = var.active_directory_group
  common_tags                 = var.common_tags
  create_managed_identity     = false
  managed_identity_object_ids = [data.azurerm_user_assigned_identity.hmi.principal_id]
}

module "kv_rota" {
  source                      = "git@github.com:hmcts/cnp-module-key-vault?ref=master"
  name                        = "${local.key_vault_name}-shared-rota"
  product                     = var.product
  env                         = var.env
  object_id                   = var.jenkins_identity_object_id
  resource_group_name         = data.azurerm_resource_group.rg.name
  product_group_name          = var.active_directory_group
  common_tags                 = var.common_tags
  create_managed_identity     = false
}

module "keyvault_secrets" {
  source = "./modules/kv_secrets"

  key_vault_id = module.kv_hmi.key_vault_id
  tags         = var.common_tags
  secrets = [
    {
      name            = "sa-connection-string"
      value           = module.sa.storageaccount_primary_connection_string
      tags            = {}
      content_type    = ""
      expiration_date = local.secret_expiry
    },
    {
      name            = "sa-name"
      value           = module.sa.storageaccount_name
      tags            = {}
      content_type    = ""
      expiration_date = local.secret_expiry
    },
    {
      name  = "app-insights-rota-dtu-connection-string"
      value = azurerm_application_insights.rota_dtu_app_insights.connection_string
      tags = {
        "source" = "App Insights"
      }
      content_type    = ""
      expiration_date = local.secret_expiry
    },
    {
      name  = "app-insights-libra-dtu-connection-string"
      value = azurerm_application_insights.libra_dtu_app_insights.connection_string
      tags = {
        "source" = "App Insights"
      }
      content_type    = ""
      expiration_date = local.secret_expiry
    },
    {
      name            = "mi-id"
      value           = data.azurerm_user_assigned_identity.hmi.principal_id
      tags            = {}
      content_type    = ""
      expiration_date = local.secret_expiry
    }
  ]

  depends_on = [
    module.kv_hmi
  ]
}

data "azurerm_key_vault" "bootstrap_kv" {
  name                = "${local.bootstrap_prefix}-kv-${var.env}"
  resource_group_name = "${local.bootstrap_prefix}-${var.env}-rg"
}

data "azurerm_key_vault_secret" "bootstrap_secrets" {
  for_each     = { for secret in local.bootstrap_secrets : secret => secret }
  name         = each.value
  key_vault_id = data.azurerm_key_vault.bootstrap_kv.id
}

module "keyvault_bootstrap_secrets" {
  source = "./modules/kv_secrets"

  key_vault_id = module.kv_hmi.key_vault_id
  tags         = var.common_tags
  secrets = [
    for secret in data.azurerm_key_vault_secret.bootstrap_secrets : {
      name  = secret.name
      value = secret.value
      tags = {
        "source" : "bootstrap ${data.azurerm_key_vault.bootstrap_kv.name} secrets"
      }
      content_type    = ""
      expiration_date = local.secret_expiry
    }
  ]
  depends_on = [
    module.kv_hmi
  ]
}
