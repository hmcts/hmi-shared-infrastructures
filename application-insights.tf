module "application_insights" {
  source = "git@github.com:hmcts/terraform-module-application-insights?ref=4.x"

  env                 = var.env
  product             = var.product
  name                = "${var.product}-rota-dtu"
  location            = var.location
  application_type    = "java"
  resource_group_name = azurerm_resource_group.rg.name

  common_tags = var.common_tags
}

moved {
  from = azurerm_application_insights.rota_dtu_app_insights
  to   = module.application_insights.azurerm_application_insights.this
}
