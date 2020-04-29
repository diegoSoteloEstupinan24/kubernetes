variable "azure_location" {
  default = "Central US"
  description = "The Azure location where all resources in this example should be created"
}

variable "client_id" {}
variable "client_secret" {}

variable "dns_prefix" {
    default = "k8stest"
}

variable resource_group_name {
    default = "azure-k8stest"
}

variable "k8s_version" {
  description = "Version of Kubernetes to use"
  default = "1.12.7"
}

variable "admin_user" {
  description = "Administrative username for the VMs"
  default = "azureuser"
}

variable "agent_pool_name" {
  description = "Name of the K8s agent pool"
  default = "default"
}

variable "agent_count" {
  description = "Number of agents to create"
  default = 1
}

variable "vm_size" {
  description = "Azure VM type"
  default = "Standard_D2"
}

variable "os_type" {
  description = "OS type for agents: Windows or Linux"
  default = "Linux"
}

variable "os_disk_size" {
  description = "OS disk size in GB"
  default = "30"
}

variable "environment" {
  description = "value passed to Environment tag and used in name of Vault k8s auth backend in the associated k8s-vault-config workspace"
  default = "aks-dev"
}