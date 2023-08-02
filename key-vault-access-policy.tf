#---------------------------------------------------
# Key Vault access policy for shared rota key vault
#---------------------------------------------------
resource "azurerm_key_vault_access_policy" "policy" {
  key_vault_id            = module.kv_rota.key_vault_id
  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_id               = data.azurerm_user_assigned_identity.hmi.principal_id
  secret_permissions      = ["Get", "List", "Set", "Delete"]
  certificate_permissions = ["Get", "List"]
}

#---------------------------------------------------
# Key Vault access policy for hmi kv to include apim SP
#---------------------------------------------------
resource "azurerm_key_vault_access_policy" "apim_kv_policy" {
  key_vault_id            = module.kv_hmi.key_vault_id
  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_id               = data.azurerm_user_assigned_identity.sds_apim_sp.principal_id
  secret_permissions      = ["Get", "List", "Set", "Delete"]
  certificate_permissions = ["Get", "List"]
}