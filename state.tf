terraform {
  backend "azurerm" {}

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.78.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.12.0"
    }
  }
}

provider "azurerm" {
  features {}
}
