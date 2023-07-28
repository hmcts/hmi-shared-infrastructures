locals {
  key_vault_name = "${var.product}-kv-${var.env}"
}

# KV for rota to access secrets needed to authenticate with HMI
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
