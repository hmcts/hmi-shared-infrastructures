locals {
  bootstrap_resource_group_name = "${var.product}-bootstrap-${var.env}-rg"
  bootstrap_key_vault_name      = "${var.product}-bootstrap-kv-${var.env}"
}

resource "azurerm_resource_group" "bootstrap_rg" {
  name     = local.bootstrap_resource_group_name
  location = var.location
  tags     = var.common_tags
}

module "kv_hmi_boostrap" {
  source                  = "git@github.com:hmcts/cnp-module-key-vault?ref=master"
  name                    = local.bootstrap_key_vault_name
  product                 = var.product
  env                     = var.env
  object_id               = var.jenkins_identity_object_id
  resource_group_name     = resource.azurerm_resource_group.bootstrap_rg.name
  product_group_name      = var.active_directory_group
  common_tags             = var.common_tags
  create_managed_identity = false
}

# All of the below can be removed once it is merged and run in master and all envs, as the import only needs to be run once.
data "azurerm_subscription" "current" {}

import {
  to = module.kv_hmi_boostrap.azurerm_key_vault.kv
  id = "${data.azurerm_subscription.current.id}/resourceGroups/${local.bootstrap_resource_group_name}/providers/Microsoft.KeyVault/vaults/${local.bootstrap_key_vault_name}"
}

import {
  to = azurerm_resource_group.bootstrap_rg
  id = "${data.azurerm_subscription.current.id}/resourceGroups/${local.bootstrap_resource_group_name}"
}

import {
  to = module.kv_hmi_boostrap.azurerm_monitor_diagnostic_setting.kv-ds
  id = "${data.azurerm_subscription.current.id}/resourceGroups/${local.bootstrap_resource_group_name}/providers/Microsoft.KeyVault/vaults/${local.bootstrap_key_vault_name}|${local.bootstrap_key_vault_name}"
}

import {
  to = module.kv_hmi_boostrap.azurerm_key_vault_access_policy.creator_access_policy
  id = "${data.azurerm_subscription.current.id}/resourceGroups/${local.bootstrap_resource_group_name}/providers/Microsoft.KeyVault/vaults/${local.bootstrap_key_vault_name}/objectId/${var.jenkins_identity_object_id}"
}

import {
  to = module.kv_hmi_boostrap.azurerm_key_vault_access_policy.product_team_access_policy
  id = "${data.azurerm_subscription.current.id}/resourceGroups/${local.bootstrap_resource_group_name}/providers/Microsoft.KeyVault/vaults/${local.bootstrap_key_vault_name}/objectId/7bde62e7-b39f-487c-95c9-b4c794fdbb96"
}
