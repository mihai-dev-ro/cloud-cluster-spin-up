resource "scaleway_instance_security_group" "dcos_cluster_private" {
  name = "dcos-cluster-private-agents"
  description = "Private Network Access policies around DC/OS Cluster"
  
  external_rules = true
}

resource "scaleway_instance_security_group_rules" "security-rules" {
  security_group_id = scaleway_instance_security_group.dcos_cluster_private.id

  inbound_rule {
    action = "accept"
    ip = "82.79.248.51"
    protocol = "TCP"
  }

  inbound_rule {
    action = "accept"
    ip_range = "0.0.0.0/0"
    protocol = "TCP"
    port = "22"
  }
}

resource "scaleway_instance_security_group_rules" "security-rules-complete" {
  security_group_id = scaleway_instance_security_group.dcos_cluster_private.id

  # inbound_rule {
  #   action = "drop"
  #   ip_range = "0.0.0.0/0"
  # }

  inbound_rule {
    action = "accept"
    ip = "82.79.248.127"
    protocol = "TCP"
  }

  inbound_rule {
    action = "accept"
    ip_range = "0.0.0.0/0"
    protocol = "TCP"
    port = "22"
  }

  dynamic "inbound_rule" {
    for_each = concat(scaleway_instance_server.master.*.private_ip, scaleway_instance_server.public_agent.*.private_ip, scaleway_instance_server.private_agent.*.private_ip)
    content {
      action = "accept"
      ip = inbound_rule.value
      protocol = "TCP"
    }
  }

  inbound_rule {
    action = "accept"
    ip = scaleway_instance_server.bootstrap.private_ip
    protocol = "TCP"
  }

  outbound_rule {
    action = "accept"
    ip_range = "0.0.0.0/0"
    protocol = "TCP"
  }
}

resource "scaleway_instance_security_group" "dcos_cluster_public" {
  name = "dcos-cluster-public-agents"
  description = "Public Network Access policies around DC/OS Cluster"
  
  inbound_rule {
    action = "accept"
    ip_range = "0.0.0.0/0"
    protocol = "TCP"
  }  
}