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
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
    kustomization = {
      source  = "kbst/kustomization"
      version = "0.8.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.6.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "kubernetes" {
  config_path = "${path.module}/kubeconfig"
}
provider "kustomization" {
  kubeconfig_path = "${path.module}/kubeconfig"
}
provider "helm" {
  kubernetes {
    config_paths = ["${path.module}/kubeconfig"]
  }
}