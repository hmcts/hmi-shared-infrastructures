locals {
  key_vault_name = "${var.product}-kv-${var.env}"
  secret_expiry = "2024-03-01T01:00:00Z"
}

data "azurerm_subnet" "jenkins_subnet" {
  provider             = azurerm.mgmt
  name                 = "iaas"
  virtual_network_name = var.env == "sbox" ? "ss-ptlsbox-vnet" : "ss-ptl-vnet"
  resource_group_name  = var.env == "sbox" ? "ss-ptlsbox-network-rg" : "ss-ptl-network-rg"
}

module "kv_hmi" {
  source                  = "git@github.com:hmcts/cnp-module-key-vault?ref=master"
  name                    = local.key_vault_name
  product                 = var.product
  env                     = var.env
  object_id               = var.jenkins_identity_object_id
  resource_group_name     = data.azurerm_resource_group.rg.name
  product_group_name      = var.active_directory_group
  common_tags             = var.common_tags
  create_managed_identity = false
  network_acls_allowed_subnet_ids = [data.azurerm_subnet.jenkins_subnet.id] 
  network_acls_allowed_ip_ranges = ["IPs"]
  network_acls_default_action = "Deny"
}

resource "azurerm_key_vault_access_policy" "cft_jenkins_access" {
  key_vault_id = module.kv_hmi.key_vault_id

  object_id = "ca6d5085-485a-417d-8480-c3cefa29df31"
  tenant_id = data.azurerm_client_config.current.tenant_id

  certificate_permissions = []
  key_permissions         = []
  secret_permissions = [
    "Get",
  ]
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
    }
  ]

  depends_on = [
    module.kv_hmi
  ]
}
