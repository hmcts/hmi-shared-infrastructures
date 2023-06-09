locals {
  prefix = "${var.product}-sharedinfra"
  resource_group_name  = "${local.prefix}-${var.env}-rg"

  sas_tokens = {
    "rota-rl" = {
      permissions     = "rl"
      storage_account = "${var.product}sa${var.env}"
      container       = "rota"
      expiry_days     = 180
    }

    "rota-rlw" = {
      permissions     = "rlw"
      storage_account = "${var.product}sa${var.env}"
      container       = "rota"
      expiry_days     = 180
    }
  }
}

# Needs to be a resource when current repo is deleted.
data "azurerm_resource_group" "rg" {
  name = local.resource_group_name
}

data "azurerm_client_config" "current" {}

data "azurerm_user_assigned_identity" "hmi" {
  name                = "hmi-${var.env}-mi"
  resource_group_name = "managed-identities-${var.env}-rg"
}