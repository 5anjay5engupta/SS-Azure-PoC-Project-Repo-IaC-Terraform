# configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }
  required_version = ">= 1.1.0"
}

# set up the Azure provider
provider "azurerm" {
  features {}
}

/****************************************************************/

# create a resource group for the Terraform engine stuff
resource "azurerm_resource_group" "rg" {
  name     = "iDEV-TF-Resource-Group"
  location = "eastus"
  tags = {
    "Project Code"     = var.project_code
    "Budget Code"      = var.budget_code
    "Cost Center Code" = var.cost_center_code
  }
}

# create a BLOB storage account for persisting the Terraform state
resource "azurerm_storage_account" "idevtfstgact" {
  name                     = "idevtfstorageaccount"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags = {
    "Project Code"     = var.project_code
    "Budget Code"      = var.budget_code
    "Cost Center Code" = var.cost_center_code
  }
}

# create a container for persisting the Terraform state
resource "azurerm_storage_container" "idevtfstatecont" {
  name                  = "idevtfstatecontainer"
  storage_account_name  = azurerm_storage_account.idevtfstgact.name
  container_access_type = "private"
}

/****************************************************************/

# create a resource group for the actual PoC IaC delpoyment stuff
resource "azurerm_resource_group" "rg0" {
  name     = "iDEV-IaC-Resource-Group"
  location = "eastus"
  tags = {
    "Project Code"     = var.project_code
    "Budget Code"      = var.budget_code
    "Cost Center Code" = var.cost_center_code
  }
}

# create a ADLS Gen2 storage account for the actual PoC IaC delpoyment stuff
resource "azurerm_storage_account" "ideviacstgact" {
  name                     = "ideviacstorageaccount"
  resource_group_name      = azurerm_resource_group.rg0.name
  location                 = azurerm_resource_group.rg0.location
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
