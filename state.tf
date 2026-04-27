terraform {
  backend "azurerm" {}

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.70.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.9.0"
    }
  }
}

provider "azurerm" {
  features {}
}
