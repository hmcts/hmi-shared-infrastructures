locals {
  bootstrap_resource_group_name = "${var.product}-bootstrap-${var.env}-rg"
  bootstrap_key_vault_name      = "${var.product}-bootstrap-kv-${var.env}"
}

resource "azurerm_resource_group" "bootstrap_rg" {
  name     = local.bootstrap_resource_group_name
  location = var.location
  tags     = var.common_tags
}

module "kv_hmi" {
  source                  = "git@github.com:hmcts/cnp-module-key-vault?ref=master"
  name                    = local.bootstrap_key_vault_name
  product                 = var.product
  env                     = var.env
  object_id               = var.jenkins_identity_object_id
  resource_group_name     = resource.azurerm_resource_group.bootstrap_rg.name
  product_group_name      = var.active_directory_group
  common_tags             = var.common_tags
  create_managed_identity = true
}
