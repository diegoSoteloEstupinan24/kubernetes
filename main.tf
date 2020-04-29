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

resource "azurerm_resource_group" "k8s" {
  name     = "${var.resource_group_name}"
  location = "${var.location}"
}

resource "azurerm_kubernetes_cluster" "k8s" {
    name                = "${var.cluster_name}"
    location            = "${azurerm_resource_group.k8s.location}"
    resource_group_name = "${azurerm_resource_group.k8s.name}"
    dns_prefix          = "${var.dns_prefix}"

    linux_profile {
        computer_name = "hostname"
        admin_username = "testadmin"
        admin_password = "Password1234!"
    }

    default_node_pool {
        name            = "agentpool"
        node_count      = "${var.agent_count}"
        vm_size         = "Standard_DS1_v2"
    }

    service_principal {
        client_id     = "${var.client_id}"
        client_secret = "${var.client_secret}"
    }

    tags = {
        Environment = "Development"
    }
}