// provider keys

variable nb_nodes_master {
  type        = number
  default     = 1
  description = "number of master nodes in the cluster"
}

variable nb_nodes_public_agent {
  type        = number
  default     = 0
  description = "number of public agents in the cluster"
}

variable nb_nodes_private_agent {
  type        = number
  default     = 5
  description = "number of private agents in the cluster"
}

variable "server_type_bootstrap" {
  type    = string
  default = "DEV1-S" # 2vCPUs, 2GB RAM, 20 GB SSD
}

variable "server_type_master" {
  type    = string
  default = "DEV1-L" # 4vCPUs, 8GB RAM, 80 GB SSD
}

variable "server_type_agent" {
  type    = string
  default = "DEV1-L" # 4vCPUs, 8GB RAM, 80 GB SSD
}

variable master_root_name {
  type        = string
  default     = "dcos-master-"
  description = "root name given to all master instances"
}

variable public_agent_root_name {
  type        = string
  default     = "dcos-public-agent-"
  description = "root name given to all master instances"
}

variable private_agent_root_name {
  type        = string
  default     = "dcos-private-agent-"
  description = "root name given to all master instances"
}