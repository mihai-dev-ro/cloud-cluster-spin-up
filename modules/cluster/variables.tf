variable "master_node_server_type" {
  default = "DEV1-S" # 2vCPUs, 2GB RAM, 20 GB SSD
}

variable "agent_node_server_type" {
  default = "DEV1-S" # 2vCPUs, 2GB RAM, 20 GB SSD
}

variable "security_group" {}

variable "security_group_opendoors" {}
