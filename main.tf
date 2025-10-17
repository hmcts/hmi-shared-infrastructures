locals {
  prefix              = "${var.product}-sharedinfra-sds"
  resource_group_name = "${local.prefix}-${var.env}-rg"
  bootstrap_prefix    = "${var.product}-bootstrap"
}

resource "azurerm_resource_group" "rg" {
  name     = local.resource_group_name
  location = var.location
}

data "azurerm_client_config" "current" {}

resource "azurerm_user_assigned_identity" "hmi-sds-mi" {
  name                = "hmi-sds-${var.env}-mi"
  resource_group_name = "managed-identities-${var.env}-rg"
  location            = var.location
  tags                = var.common_tags
}

data "azurerm_key_vault" "bootstrap_kv" {
  name                = "${local.bootstrap_prefix}-kv-${var.env}"
  resource_group_name = "${local.bootstrap_prefix}-${var.env}-rg"
}

data "azuread_service_principal" "sds_apim_sp" {
  display_name = "sds-api-mgmt-${var.env}"
}

