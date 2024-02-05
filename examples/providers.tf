#terraform {
#  required_providers {
#    azapi = {
#      source = "Azure/azapi"
#      version = "1.12.0"
#    }
#  }
#}

provider "azurerm" {
  skip_provider_registration = true
  subscription_id            = "b07c6415-3b3e-4968-9c83-5f2218fd57fe"
  features {}
}

#provider "azapi" {
#}