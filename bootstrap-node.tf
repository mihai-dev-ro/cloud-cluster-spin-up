data "scaleway_instance_image" "centos" {
  name = "dcos-base-image"  # CentOS 7.6 with Docker, NTP installed
  architecture = "x86_64"
}

module "dcos_cluster" {
  source                    = "./modules/cluster"
  master_node_server_type   = var.master_node_server_type
  agent_node_server_type    = var.agent_node_server_type
  security_group            = scaleway_instance_security_group.dcos_cluster_private.id
  security_group_opendoors  = scaleway_instance_security_group.dcos_cluster_public.id  
}

resource "scaleway_instance_security_group_rules" "security-rules-cluster-nodes" {
  security_group_id = scaleway_instance_security_group.dcos_cluster_private.id

  dynamic "inbound_rule" {
    for_each = module.dcos_cluster.all_nodes_ip
    content {
      action = "accept"
      ip = inbound_rule.value
      protocol = "TCP"
    }
  }
}

# 2 cores, 16GB RAM, 60GB disk
# used for installation or upgrade
# to be destroyed at the end of the installation/upgrade procedure
resource "scaleway_instance_server" "bootstrap_node" {
  name              = "dcos-boostrap-node"
  type              = var.bootstrap_node_server_type
  image             = data.scaleway_instance_image.centos.id
  security_group_id = scaleway_instance_security_group.dcos_cluster_private.id
  enable_dynamic_ip = true

  connection {
    host = self.public_ip
    type = "ssh"
    private_key = file("~/.ssh/id_rsa")
  }

  provisioner "remote-exec" {
    inline     = [
        "mkdir /tmp/genconf"
    ]
  }

  provisioner "file" {
    source = "ip-detect.sh"
    destination = "/tmp/genconf/ip-detect"
  }

  provisioner "file" {
    source = "~/.ssh/id_rsa"
    destination = "/tmp/genconf/ssh_key"
  }

  provisioner "file" {
    source = "config.sh"
    destination = "/tmp/config.sh"
  }

  # launch the DC/OS bootstrap sequence
  provisioner "remote-exec" {
    inline = [
      # install wget
      # "yum install -y wget",
      # "[ ! -f /tmp/dcos_generate_config.sh ] && wget -O /tmp/dcos_generate_config.sh https://downloads.dcos.io/dcos/stable/dcos_generate_config.sh",
      
      "cd /tmp/ && curl -O https://downloads.dcos.io/dcos/stable/1.13.1/dcos_generate_config.sh",
      "bash /tmp/config.sh ${module.dcos_cluster.private_agents_ip} ${module.dcos_cluster.masters_ip} ${module.dcos_cluster.public_agents_ip} > /tmp/genconf/config.yaml",
      "chmod 600 /tmp/genconf/ssh_key",
      "cd /tmp/ && sudo bash dcos_generate_config.sh --genconf",
      "cd /tmp/ && sudo bash dcos_generate_config.sh --install-prereqs",
      "cd /tmp/ && sudo bash dcos_generate_config.sh --preflight",
      "cd /tmp/ && sudo bash dcos_generate_config.sh --deploy"
    ]
  }
}


resource "scaleway_instance_security_group_rules" "security-rules-bootstrap-node" {
  security_group_id = scaleway_instance_security_group.dcos_cluster_private.id

  inbound_rule {
    action = "accept"
    ip = scaleway_instance_server.bootstrap_node.private_ip
    protocol = "TCP"
  }
}
