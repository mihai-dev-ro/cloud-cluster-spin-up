output "internal_ip" {
  value = "${scaleway_instance_server.agent_private.private_ip}"
}
