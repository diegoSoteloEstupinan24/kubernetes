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

# # Locals block for hardcoded names. 
locals {
    backend_address_pool_name      = "${azurerm_virtual_network.test.name}-beap"
    frontend_port_name             = "${azurerm_virtual_network.test.name}-feport"
    frontend_ip_configuration_name = "${azurerm_virtual_network.test.name}-feip"
    http_setting_name              = "${azurerm_virtual_network.test.name}-be-htst"
    listener_name                  = "${azurerm_virtual_network.test.name}-httplstn"
    request_routing_rule_name      = "${azurerm_virtual_network.test.name}-rqrt"
    app_gateway_subnet_name = "appgwsubnet"
}

# Azure Resource Group
resource "azurerm_resource_group" "siniestros" {
  name     = "${var.prefix}-resources"
  location = "${var.azure_location}"
}

resource "azurerm_container_registry" "acr" {
  name                     = "${var.prefix}acr"
  resource_group_name      = "${azurerm_resource_group.siniestros.name}"
  location                 = "${azurerm_resource_group.siniestros.location}"
  sku                      = "Basic"
  admin_enabled            = true
}

# User Assigned Identities 
resource "azurerm_user_assigned_identity" "testIdentity" {
  resource_group_name = "${azurerm_resource_group.siniestros.name}"
  location            = "${azurerm_resource_group.siniestros.location}"

  name = "identity1"

  tags = {
    Environment = "Developer"
  }
}

resource "azurerm_virtual_network" "test" {
  name                = "${var.virtual_network_name}"
  location            = "${azurerm_resource_group.siniestros.location}"
  resource_group_name = "${azurerm_resource_group.siniestros.name}"
  address_space       = ["${var.virtual_network_address_prefix}"]

  subnet {
    name           = "${var.aks_subnet_name}"
    address_prefix = "${var.aks_subnet_address_prefix}"
  }

  subnet {
    name           = "appgwsubnet"
    address_prefix = "${var.app_gateway_subnet_address_prefix}"
  }

  tags = {
    Environment = "Developer"
  }
}

data "azurerm_subnet" "kubesubnet" {
  name                 = "${var.aks_subnet_name}"
  virtual_network_name = "${azurerm_virtual_network.test.name}"
  resource_group_name  = "${azurerm_resource_group.siniestros.name}"
}

data "azurerm_subnet" "appgwsubnet" {
  name                 = "appgwsubnet"
  virtual_network_name = "${azurerm_virtual_network.test.name}"
  resource_group_name  = "${azurerm_resource_group.siniestros.name}"
}
# Public Ip 
resource "azurerm_public_ip" "test" {
  name                         = "publicIp1"
  location                     = "${var.azure_location}"
  resource_group_name          = "${azurerm_resource_group.siniestros.name}"
  allocation_method            = "Static"
  sku                          = "Standard"

  tags = {
    Environment = "Developer"
  }
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.prefix}aks"
  location            = "${azurerm_resource_group.siniestros.location}"
  resource_group_name = "${azurerm_resource_group.siniestros.name}"
  dns_prefix          = "${var.prefix}dns"

  linux_profile {
    admin_username = "${var.vm_user_name}"

    ssh_key {
      #key_data = "${file("${var.public_ssh_key_path}")}"
      key_data = "ssh-rsa AAAAB3Nz{snip}hwhqT9h"
    }
  }

  addon_profile {
    http_application_routing {
      enabled = false
    }
  }

  default_node_pool {
    name       = "nodepool1"
    node_count = "${var.aks_agent_count}"
    vm_size    = "${var.aks_agent_vm_size}"
    os_disk_size_gb = "${var.aks_agent_os_disk_size}"    
    #PENDIENTE
    vnet_subnet_id  = "${data.azurerm_subnet.kubesubnet.id}"
  }

  service_principal {
    client_id     = "${var.client_id}"
    client_secret = "${var.client_secret}"
  }

  network_profile {
    network_plugin     = "kubenet"
    dns_service_ip     = "${var.aks_dns_service_ip}"
    #QUE ES
    docker_bridge_cidr = "${var.aks_docker_bridge_cidr}"
    #QUE ES
    service_cidr       = "${var.aks_service_cidr}"
    #QUE ES
    pod_cidr           = "${var.aks_pod_cidr}"
  }
  #PENDIENTE
  depends_on = ["azurerm_virtual_network.test"]

  tags = {
    Environment = "Developer"
  }
}

#resource "azurerm_kubernetes_cluster_node_pool" "aks" {
#  name                  = "internal"
#  kubernetes_cluster_id = "${azurerm_kubernetes_cluster.aks.id}"
#  vm_size               = "${var.aks_agent_vm_size}"
#  node_count            = "${var.aks_agent_count}"
#  os_disk_size_gb       = "${var.aks_agent_os_disk_size}" 
#
#  tags = {
#    Environment = "Developer"
#  }
#}