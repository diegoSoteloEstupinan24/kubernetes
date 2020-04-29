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

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
}

# Azure Resource Group
resource "azurerm_resource_group" "k8sexample" {
  name     = "${var.resource_group_name}"
  location = "${var.azure_location}"
}

# Azure Container Service (AKS) Cluster
resource "azurerm_kubernetes_cluster" "k8sexample" {
  name = "azure-k8sexample-cluster"
  location = "${azurerm_resource_group.k8sexample.location}"
  resource_group_name = "${azurerm_resource_group.k8sexample.name}"
  dns_prefix = "${var.dns_prefix}"
  kubernetes_version = "${var.k8s_version}"

  linux_profile {
    admin_username = "${var.admin_user}"
    ssh_key {
      key_data = "${chomp(tls_private_key.ssh_key.public_key_openssh)}"
    }
  }

  agent_pool_profile {
    name       = "${var.agent_pool_name}"
    count      =  "${var.agent_count}"
    os_type    = "${var.os_type}"
    os_disk_size_gb = "${var.os_disk_size}"
    vm_size    = "${var.vm_size}"
  }

  service_principal {
    client_id     = "${var.client_id}"
    client_secret = "${var.client_secret}"
  }

  tags {
    Environment = "${var.environment}"
  }
}