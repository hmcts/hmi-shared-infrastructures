terraform {
  backend "azurerm" {}

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.7.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.2.0"
    }
  }
}

provider "azurerm" {
  features {}
}
