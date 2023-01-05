terraform {
  required_version = "1.3.7"
  # backend "azurerm" {}
  backend "local" {}
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.37.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.31.0"
    }
  }
}

provider "azurerm" {
  features {}
}
