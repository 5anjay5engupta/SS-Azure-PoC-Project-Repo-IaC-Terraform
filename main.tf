/********************************************************************************/
#       Author : Sanjay Sengupta - Enterprise Cloud & Big Data Analytics Architect
# Last Updated : Sep 5, 2022
/********************************************************************************/

# configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }
  required_version = ">= 1.1.0"
  backend "azurerm" {} # required for persisting state to a remote location (Azure)
}

# set up the Azure provider
provider "azurerm" {
  features {}
}

/************************************************/

# create a resource group for the Terraform stuff
# resource "azurerm_resource_group" "idev_rg_tf" {
#   name     = "iDEV-Resource-Group-TF"
#   location = var.location
#   tags = {
#     "Project Code"     = var.project_code
#     "Budget Code"      = var.budget_code
#     "Cost Center Code" = var.cost_center_code
#   }
# }

# create a BLOB storage account for persisting the Terraform state
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

# create a container for persisting the Terraform state
# resource "azurerm_storage_container" "idev_tf_state_cont" {
#   name                  = "idev-tf-state-container"
#   storage_account_name  = azurerm_storage_account.idev_stg_act_tf.name
#   container_access_type = "private"
# }

/***************************************************************/

# create a resource group for the actual PoC IaC delpoyment stuff
resource "azurerm_resource_group" "idev_rg" {
  name     = var.resource_group
  location = var.location
  tags = {
    "Project Code"     = var.project_code
    "Budget Code"      = var.budget_code
    "Cost Center Code" = var.cost_center_code
  }
}

# create an ADLS Gen2 storage account for the actual PoC stuff
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

# create an Event Hubs Namesapce for the actual PoC stuff
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

# create an Event Hub for the actual PoC stuff
resource "azurerm_eventhub" "idev_eh" {
  name                = "iDEV-Event-Hub"
  namespace_name      = azurerm_eventhub_namespace.idev_eh_nmsp.name
  resource_group_name = azurerm_resource_group.idev_rg.name
  partition_count     = 1
  message_retention   = 1
}

# create an Event Hub Authorization Rule for the actual PoC stuff
resource "azurerm_eventhub_authorization_rule" "idev_eh_auth_rule" {
  name                = "iDEV-Event-Hub-Authorization-Rule"
  namespace_name      = azurerm_eventhub_namespace.idev_eh_nmsp.name
  eventhub_name       = azurerm_eventhub.idev_eh.name
  resource_group_name = azurerm_resource_group.idev_rg.name
  listen              = true
  send                = true
  manage              = true
}

/* # create a data factory for the actual PoC stuff
resource "azurerm_data_factory" "idev_adf_v2" {
  name                = "iDEV-ADF-V2"
  location            = var.location
  resource_group_name = azurerm_resource_group.idev_rg.name
}

# create a data factory linked service for the actual PoC stuff
resource "azurerm_data_factory_linked_service_azure_blob_storage" "idev_adf_v2_ls_adls_gen2" {
  name              = "iDEV-ADF-V2-LS-ADLS-Gen2"
  data_factory_id   = azurerm_data_factory.idev_adf_v2.id
  connection_string = data.azurerm_storage_account.idev_stg_act.primary_connection_string
} */

data "azurerm_storage_account" "adlsexample123" {
  name                = "storageaccountname123"
  resource_group_name = azurerm_resource_group.idev_rg.name
}

resource "azurerm_data_factory" "adfexample123" {
  name                = "adfexample123"
  location            = azurerm_resource_group.idev_rg.location
  resource_group_name = azurerm_resource_group.idev_rg.name
}

resource "azurerm_data_factory_linked_service_azure_blob_storage" "adfexamplels123" {
  name              = "adfexamplels123"
  data_factory_id   = azurerm_data_factory.adfexample123.id
  connection_string = data.azurerm_storage_account.adlsexample123.primary_connection_string
}