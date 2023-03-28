locals {
  prefix = "${var.product}-sharedinfra"
  resource_group_name  = "${local.prefix}-${var.env}-rg"
}

# Needs to be a resource when current repo is deleted.
data "azurerm_resource_group" "rg" {
  name = local.resource_group_name
}

data "azurerm_client_config" "current" {}