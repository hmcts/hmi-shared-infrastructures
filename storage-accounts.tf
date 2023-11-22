locals {
  containers = [
    {
      name        = "rota"
      access_type = "private"
    },
    {
      name        = "processing"
      access_type = "private"
    },
    {
      name        = "libra"
      access_type = "private"
    }
  ]
  storage_account_name = "${var.product}sa${var.env}"
}

data "azurerm_user_assigned_identity" "keda" {
  name                = "keda-${var.env}-mi"
  resource_group_name = "managed-identities-${var.env}-rg"
}

#tfsec:ignore:azure-storage-default-action-deny
module "sa" {
  source = "git@github.com:hmcts/cnp-module-storage-account?ref=master"

  env = var.env

  enable_change_feed = true

  storage_account_name = local.storage_account_name
  common_tags          = var.common_tags

  default_action = "Allow"

  resource_group_name = data.azurerm_resource_group.rg.name
  location            = var.location

  account_tier             = var.sa_account_tier
  account_kind             = var.sa_account_kind
  account_replication_type = var.sa_account_replication_type
  access_tier              = var.sa_access_tier

  enable_data_protection = true

  containers = local.containers

  managed_identity_object_id = data.azurerm_user_assigned_identity.keda.principal_id
  role_assignments = [
    "Storage Blob Data Reader"
  ]
  pim_roles = {}
}