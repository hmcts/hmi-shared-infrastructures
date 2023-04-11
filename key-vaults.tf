locals {
  key_vault_name = "${var.product}-kv-${var.env}"
  secret_expiry = "2024-03-01T01:00:00Z"
  secrets = [
    {
      name            = "sa-connection-string"
      value           = module.sa.storageaccount_primary_connection_string
      tags            = {}
      content_type    = ""
      expiration_date = local.secret_expiry
    }
  ]
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

module "kv_secrets" {
  key_vault_id = module.kv_hmi.key_vault_id
  for_each        = { for secret in local.secrets : secret.name => secret }
  name            = each.value.name
  value           = each.value.value
  tags            = merge(var.common_tags, each.value.tags)
  content_type    = each.value.content_type
  expiration_date = each.value.expiration_date

  depends_on = [
    module.kv_hmi
  ]
}
