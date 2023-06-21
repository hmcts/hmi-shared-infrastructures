#---------------------------------------------------
# Key Vault access policy for shared rota key vault
#---------------------------------------------------
resource "azurerm_key_vault_access_policy" "policy" {
  key_vault_id            = module.kv_rota.key_vault_id
  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_id               = data.azurerm_user_assigned_identity.hmi.principal_id
  key_permissions         = []
  secret_permissions      = ["Get", "List", "Set", "Delete"]
  certificate_permissions = ["Get", "List"]
  storage_permissions     = []
}