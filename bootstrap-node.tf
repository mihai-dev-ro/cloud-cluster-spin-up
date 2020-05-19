data "scaleway_instance_image" "centos" {
  name = "CentOS 7.6"
  architecture = "x86_64"
}

module "dcos_cluster" {
  source                    = "./modules/cluster"
  master_node_server_type   = var.master_node_server_type
  agent_node_server_type    = var.agent_node_server_type
  security_group            = scaleway_instance_security_group.dcos_cluster_private.id
  security_group_opendoors  = scaleway_instance_security_group.dcos_cluster_public.id  
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
      # uninstall old versions
      "yum remove docker",
      "yum remove docker-client",
      "yum remove docker-client-latest",
      "yum remove docker-common",
      "yum remove docker-latest",
      "yum remove docker-latest-logrotate",
      "yum remove docker-logrotate",
      "yum remove docker-engine",

      # install docker
      "yum install -y yum-utils",
      "yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo",
      "yum install docker",

      "[ ! -f /tmp/dcos_generate_config.sh ] && wget -O /tmp/dcos_generate_config.sh https://downloads.dcos.io/dcos/stable/dcos_generate_config.sh",
      "bash /tmp/config.sh ${module.dcos_cluster.private_agents_ip} ${module.dcos_cluster.masters_ip} ${module.dcos_cluster.public_agents_ip} > /tmp/genconf/config.yaml",
      "chmod 600 /tmp/genconf/ssh_key",
      "cd /tmp/ && bash dcos_generate_config.sh --install-prereqs && bash dcos_generate_config.sh --preflight && bash dcos_generate_config.sh --deploy"
    ]
  }
}


resource "scaleway_instance_security_group_rules" "security-rule" {
  security_group_id = scaleway_instance_security_group.dcos_cluster_private.id

  inbound_rule {
    action = "accept"
    ip_range = scaleway_instance_server.bootstrap_node.private_ip
    protocol = "TCP"
  }
}
