module "automation_runbook_sas_token_renewal" {
  source = "git@github.com:hmcts/cnp-module-automation-runbook-sas-token-renewal?ref=master"

  for_each = local.sas_tokens

  name = "rotate-sas-tokens-${each.value.storage_account}-${each.value.container}-${each.value.permissions}"

  resource_group_name              = data.azurerm_resource_group.rg.name
  environment                      = var.env
  storage_account_name             = each.value.storage_account
  container_name                   = each.value.container
  key_vault_name                   = module.kv_rota.key_vault_name
  secret_name                      = "rota-sas-${each.value.container}-${each.value.permissions}"
  expiry_days                      = each.value.expiry_days

  automation_account_name          = azurerm_automation_account.automation_account.name
  sas_permissions                  = each.value.permissions

  bypass_kv_networking             = true
  user_assigned_identity_client_id = data.azurerm_user_assigned_identity.hmi.principal_id

  tags = var.common_tags

  depends_on = [
    azurerm_automation_account.automation_account
  ]
}
