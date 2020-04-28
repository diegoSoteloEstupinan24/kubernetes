terraform {
  backend "azurerm" {
    resource_group_name   = "siniestrosautomatic"
    storage_account_name  = "storageautomatic"
    container_name        = "storageblobautomatic"
    key                   = "terraform.tfstate"
  }
}


provider "azurerm" {
  version = ">2.0.0"  
  features {}
}

resource "azurerm_resource_group" "siniestros" {
  name     = "${var.prefix}-resources"
  location = "${var.location}"
}

resource "azurerm_virtual_network" "siniestros" {
  name                = "${var.prefix}-network"
  resource_group_name = "${azurerm_resource_group.siniestros.name}"
  location            = "${azurerm_resource_group.siniestros.location}"
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "siniestros" {
  name                 = "internal"
  virtual_network_name = "${azurerm_virtual_network.siniestros.name}"
  resource_group_name  = "${azurerm_resource_group.siniestros.name}"
  address_prefix       = "10.0.1.0/24"
}