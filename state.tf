terraform {
  backend "azurerm" {}

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.42.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.6.0"
    }
  }
}

provider "azurerm" {
  features {}
}
