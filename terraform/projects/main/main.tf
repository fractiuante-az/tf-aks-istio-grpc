
# data "azuread_user" "aad" {
#   user_principal_name = var.admin_upn
# }

# resource "azuread_group" "k8sadmins" {
#   display_name     = "Kubernetes Admins"
#   security_enabled = true
#   members = [
#     data.azuread_user.aad.object_id,
#   ]
# }

locals {
  project = "dev-test-01"
}


resource "azurerm_resource_group" "resource_group" {
  name     = lower("rg-${local.project}")
  location = var.location
}

module "aks" {
  source = "../../modules/aks/"

  name                = "aksaadexample"
  resource_group_name = azurerm_resource_group.resource_group.name
  dns_prefix          = "demolab"

  default_pool_name  = "default"
  network_plugin     = "azure"
  network_policy     = "calico"
  kubernetes_version = "1.24.6"

  enable_azure_active_directory = true
  rbac_aad_managed              = true
  # rbac_aad_admin_group_object_ids = [azuread_group.k8sadmins.object_id]
  rbac_aad_admin_group_object_ids = [var.k8sadmins_group_id]

  depends_on = [
    azurerm_resource_group.resource_group
  ]
}
