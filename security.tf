resource "scaleway_instance_security_group" "dcos_cluster_private" {
  name = "dcos-cluster-private-agents"
  description = "Private Network Access policies around DC/OS Cluster"
  
  external_rules = true
  #inbound_default_policy = "drop"
}

resource "scaleway_instance_security_group_rules" "dcos_cluster_private_ssh" {
  security_group_id = scaleway_instance_security_group.dcos_cluster_private.id

  inbound_rule {
    action = "accept"
    ip_range = "0.0.0.0/0"
    protocol = "TCP"
    port = "22"
  }  
}

resource "scaleway_instance_security_group_rules" "dcos_cluster_private_inbound_home" {
  security_group_id = scaleway_instance_security_group.dcos_cluster_private.id

  inbound_rule {
    action = "accept"
    ip = "82.79.248.51"
    protocol = "TCP"
  }  
}

resource "scaleway_instance_security_group_rules" "dcos_cluster_private_outbound_all" {
  security_group_id = scaleway_instance_security_group.dcos_cluster_private.id

  outbound_rule {
    action = "accept"
    ip_range = "0.0.0.0/0"
    protocol = "TCP"
  }
}

resource "scaleway_instance_security_group" "dcos_cluster_public" {
  name = "dcos-cluster-public-agents"
  description = "Public Network Access policies around DC/OS Cluster"
  external_rules = true
}

resource "scaleway_instance_security_group_rules" "dcos_cluster_public_inbound_all" {
  security_group_id = scaleway_instance_security_group.dcos_cluster_public.id

  inbound_rule {
    action = "accept"
    ip_range = "0.0.0.0/0"
    protocol = "TCP"
  }  
}