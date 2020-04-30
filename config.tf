variable "prefix" {
  description = "The prefix used for all resources in this example"
}
variable "azure_location" {
    description = "The Azure location where all resources in this example should be created"
}
variable "client_id" {
    description = "Client ID"
}
variable "client_secret" {
    description = "Client Secret"
}
variable "object_id" {
  description = "Object ID of the service principal."
}
variable "virtual_network_name" {
  description = "Virtual network name"
  default     = "aksVirtualNetwork"
}
variable "virtual_network_address_prefix" {
  description = "Containers DNS server IP address."
  default     = "15.0.0.0/8"
}
variable "app_gateway_subnet_address_prefix" {
  description = "Containers DNS server IP address."
  default     = "15.0.0.0/29"
}
variable "aks_subnet_address_prefix" {
  description = "Containers DNS server IP address."
  default     = "15.240.0.0/16"
}
variable "aks_subnet_name" {
  description = "AKS Subnet Name."
  default     = "kubesubnet"
}
variable "app_gateway_name" {
  description = "Name of the Application Gateway."
  default = "ApplicationGateway1"
}
variable "app_gateway_sku" {
  description = "Name of the Application Gateway SKU."
  default = "Standard_v2"
}
variable "app_gateway_tier" {
  description = "Tier of the Application Gateway SKU."
  default = "Standard_v2"
}
variable "vm_user_name" {
  description = "User name for the VM"
  default     = "vmuser1"
}
variable "public_ssh_key_path" {
  description = "Public key path for SSH."
  default     = "~/.ssh/id_rsa.pub"
}
variable "aks_agent_count" {
  description = "The number of agent nodes for the cluster."
  default     = 1
}
variable "aks_agent_vm_size" {
  description = "The size of the Virtual Machine."
  default     = "Standard_D2s_v3"
}
variable "aks_agent_os_disk_size" {
  description = "Disk size (in GB) to provision for each of the agent pool nodes. This value ranges from 0 to 1023. Specifying 0 applies the default disk size for that agentVMSize."
  default     = 40
}
variable "aks_dns_service_ip" {
  description = "Containers DNS server IP address."
  default     = "15.1.0.10"
}
variable "aks_docker_bridge_cidr" {
  description = "A CIDR notation IP for Docker bridge."
  default     = "172.17.0.1/16"
}
variable "aks_service_cidr" {
  description = "A CIDR notation IP range from which to assign service cluster IPs."
  default     = "15.1.0.0/16"
}
variable "aks_pod_cidr" {
  description = "A Pod CIDR notation IP range from which to assign service cluster IPs."
  default     = "15.244.0.0/16"
}