output "internal_ip" {
  value = "${scaleway_instance_server.agent_public.private_ip}"
}