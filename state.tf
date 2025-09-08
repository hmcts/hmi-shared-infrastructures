terraform {
  backend "azurerm" {}

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.43.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.5.0"
    }
  }
}

provider "azurerm" {
  features {}
}
