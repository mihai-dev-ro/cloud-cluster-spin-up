module "dcos101" {
  source                    = "../node-agent-public/"
  server_name               = "dcos-public-101"
  server_type               = var.agent_node_server_type
  security_group            = var.security_group
  security_group_opendoors  = var.security_group_opendoors
}

module "dcos201" {
  source          = "../node-agent-private/"
  server_name     = "dcos-private-201"
  server_type     = var.agent_node_server_type
  security_group  = var.security_group
}

# module "dcos202" {
#   source          = "../node-agent-private/"
#   server_name     = "dcos-private-202"
#   server_type     = var.agent_node_server_type
#   security_group  = var.security_group
# }

# module "dcos203" {
#   source          = "../node-agent-private/"
#   server_name     = "dcos-private-203"
#   server_type     = var.agent_node_server_type
#   security_group  = var.security_group
# }

