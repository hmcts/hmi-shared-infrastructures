resource "azurerm_application_insights" "rota_dtu_app_insights" {
  name                = "${var.product}-rota-dtu-${var.env}"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
  application_type    = "java"
  tags                = var.common_tags
}

resource "azurerm_application_insights" "libra_dtu_app_insights" {
  name                = "${var.product}-libra-dtu-${var.env}"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
  application_type    = "java"
  tags                = var.common_tags
}