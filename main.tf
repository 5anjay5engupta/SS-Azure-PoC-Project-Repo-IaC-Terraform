/********************************************************************************/
#       Author : Sanjay Sengupta - Enterprise Cloud & Big Data Analytics Architect
# Last Updated : Jan 24, 2025
/********************************************************************************/

# configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.86.0"
    }
  }
  required_version = ">= 1.1.0"
  backend "azurerm" {} # required for persisting the Terraform state file to a remote location i.e., Azure in this case
}

# set up the Azure provider
provider "azurerm" {
  features {}
}

/************************************************/

# create a dedicated Resource Group for Terraform
# resource "azurerm_resource_group" "idev_rg_tf" {
#   name     = "iDEV-Resource-Group-TF"
#   location = var.location
#   tags = {
#     "Project Code"     = var.project_code
#     "Budget Code"      = var.budget_code
#     "Cost Center Code" = var.cost_center_code
#   }
# }

# create a dedicated BLOB Storage Account for persisting the Terraform state file
# resource "azurerm_storage_account" "idev_stg_act_tf" {
#   name                     = "idevstorageaccounttf"
#   resource_group_name      = azurerm_resource_group.idev_rg_tf.name
#   location                 = var.location
#   account_tier             = "Standard"
#   account_replication_type = "LRS"
#   tags = {
#     "Project Code"     = var.project_code
#     "Budget Code"      = var.budget_code
#     "Cost Center Code" = var.cost_center_code
#   }
# }

# create a dedicated BLOB Storage Account Container for persisting the Terraform state file
# resource "azurerm_storage_container" "idev_tf_state_cont" {
#   name                  = "idev-tf-state-container"
#   storage_account_name  = azurerm_storage_account.idev_stg_act_tf.name
#   container_access_type = "private"
# }

/***************************************************************/

# create a Resource Group for the actual PoC IaC delpoyment
resource "azurerm_resource_group" "idev_rg" {
  name     = var.resource_group
  location = var.location
  tags = {
    "Project Code"     = var.project_code
    "Budget Code"      = var.budget_code
    "Cost Center Code" = var.cost_center_code
  }
}

# create an ADLS Gen2 storage account for the actual PoC
resource "azurerm_storage_account" "idev_stg_act" {
  name                     = "idevstorageaccount"
  resource_group_name      = azurerm_resource_group.idev_rg.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = "true"
  tags = {
    "Project Code"     = var.project_code
    "Budget Code"      = var.budget_code
    "Cost Center Code" = var.cost_center_code
  }
}

# create an Event Hubs Namesapce for the actual PoC
resource "azurerm_eventhub_namespace" "idev_eh_nmsp" {
  name                = "iDEV-Event-Hubs-Namespace"
  resource_group_name = azurerm_resource_group.idev_rg.name
  location            = var.location
  sku                 = "Standard"
  capacity            = 1
  tags = {
    "Project Code"     = var.project_code
    "Budget Code"      = var.budget_code
    "Cost Center Code" = var.cost_center_code
  }
}

# create an Event Hub for the actual PoC
resource "azurerm_eventhub" "idev_eh" {
  name                = "iDEV-Event-Hub"
  namespace_name      = azurerm_eventhub_namespace.idev_eh_nmsp.name
  resource_group_name = azurerm_resource_group.idev_rg.name
  partition_count     = 1
  message_retention   = 1
}

# create an Event Hub Authorization Rule for the actual PoC
resource "azurerm_eventhub_authorization_rule" "idev_eh_auth_rule" {
  name                = "iDEV-Event-Hub-Authorization-Rule"
  namespace_name      = azurerm_eventhub_namespace.idev_eh_nmsp.name
  eventhub_name       = azurerm_eventhub.idev_eh.name
  resource_group_name = azurerm_resource_group.idev_rg.name
  listen              = true
  send                = true
  manage              = true
}

/*
# create an ADF V2 for the actual PoC
resource "azurerm_data_factory" "idev_adf_v2_wksp" {
  name                = "iDEV-ADF-V2-Workspace"
  resource_group_name = azurerm_resource_group.idev_rg.name
  location            = var.location
  managed_virtual_network_enabled = true
}

# default IRT
resource "azurerm_data_factory_integration_runtime_azure" "idev_adf_v2_wksp_auto_resolve_irt" {
  name            = "AutoResolveIntegrationRuntime"
  data_factory_id = azurerm_data_factory.idev_adf_v2_wksp.id
  location        = var.location
}

# custom IRT within Managed Virtual Network
resource "azurerm_data_factory_integration_runtime_azure" "idev_adf_v2_wksp_auto_resolve_irt_pvt" {
  name            = "AutoResolveIntegrationRuntimePvt"
  data_factory_id = azurerm_data_factory.idev_adf_v2_wksp.id
  location        = var.location
  virtual_network_enabled = true
}

# create an User Assigned Managed Identity for ADF V2 access to ADLS Gen2 for the actual PoC
resource "azurerm_user_assigned_identity" "idev_adf_v2_adls_gen2_uami" {
  name = "iDEV-ADF-V2-ADLS-Gen2-User-Assigned-Managed-Identity"
  resource_group_name = azurerm_resource_group.idev_rg.name
  location            = var.location
}
*/
