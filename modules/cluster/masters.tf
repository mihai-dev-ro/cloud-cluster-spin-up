module "dcos001" {
  server_name     = "dcos-master-001"
  server_type     = var.master_node_server_type
  source          = "../node-master/"
  security_group  = var.security_group
}

# module "dcos002" {
#   server_name = "dcos-master-002"
#   server_type     = var.master_node_server_type
#   source          = "../node-master/"
#   security_group  = var.security_group
# }

# module "dcos003" {
#   server_name = "dcos-master-003"
#   server_type     = var.master_node_server_type
#   source          = "../node-master/"
#   security_group  = var.security_group
# }