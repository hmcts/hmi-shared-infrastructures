resource "azurerm_automation_account" "automation_account" {
  name                = "${local.product}-${var.env}-aa"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  sku_name            = var.automation_account_sku_name

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.hmi.id]
  }

  tags = var.common_tags
}
