# configure the authentication credentials for 
# accessing the provider of the cloud resources
provider "scaleway" {
    access_key      = var.provider_access_key
    secret_key      = var.provider_secret_key
    organization_id = var.organization_id
    region          = "nl-ams"
    zone            = "nl-ams-1"    
}

data "scaleway_instance_image" "centos" {
  name          = "dcos-base-image"  # CentOS 7.6 with Docker, NTP installed
  architecture  = "x86_64"
} 

resource "scaleway_instance_server" "master" {
  count             = var.nb_nodes_master
  name              = "${var.master_root_name}-${count.index}"
  image             = data.scaleway_instance_image.centos.id
  type              = var.server_type_master
  security_group_id = scaleway_instance_security_group.dcos_cluster_private.id
  enable_dynamic_ip = true 
}

resource "scaleway_instance_server" "public_agent" {
  count             = var.nb_nodes_public_agent
  name              = "${var.public_agent_root_name}-${count.index}"
  image             = data.scaleway_instance_image.centos.id
  type              = var.server_type_agent_public
  security_group_id = scaleway_instance_security_group.dcos_cluster_public.id
  enable_dynamic_ip = true 
}

resource "scaleway_instance_server" "private_agent" {
  count             = var.nb_nodes_private_agent
  name              = "${var.private_agent_root_name}-${count.index}"
  image             = data.scaleway_instance_image.centos.id
  type              = var.server_type_agent
  security_group_id = scaleway_instance_security_group.dcos_cluster_private.id
  enable_dynamic_ip = true 
}

resource "scaleway_instance_server" "bootstrap" {
  name              = "dcos-bootstrap"
  image             = data.scaleway_instance_image.centos.id
  type              = var.server_type_bootstrap
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
    source = "ip-detect-public.sh"
    destination = "/tmp/genconf/ip-detect-public"
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
      # ntp force sync and restart
      "systemctl stop ntpd",
      "ntpd -gq",
      "systemctl start ntpd",

      "cd /tmp/ && curl -O https://downloads.dcos.io/dcos/stable/1.13.1/dcos_generate_config.sh",
      "bash /tmp/config.sh ${self.private_ip} ${join(",", scaleway_instance_server.master.*.private_ip)} ${join(",", scaleway_instance_server.private_agent.*.private_ip)} ${join(",", scaleway_instance_server.public_agent.*.private_ip)} > /tmp/genconf/config.yaml",
      "chmod 600 /tmp/genconf/ssh_key",
      "cd /tmp/ && sudo bash dcos_generate_config.sh",
      "cd /tmp/ && docker run -d -p 8080:80 -v $PWD/genconf/serve:/usr/share/nginx/html:ro nginx"
    ]
  }
}

resource "null_resource" "deploy_master" {
  count = var.nb_nodes_master

  connection { 
    host = element(scaleway_instance_server.master.*.public_ip, count.index)
    type = "ssh"
    user = "root"
    private_key = file("~/.ssh/id_rsa") 
  }

  provisioner "remote-exec" {
    inline = [
      # ensure ntp sync
      "systemctl stop ntpd",
      "ntpd -gq",
      "systemctl start ntpd",

      "mkdir /tmp/dcos && cd /tmp/dcos",
      "curl -O http://${scaleway_instance_server.bootstrap.private_ip}:8080/dcos_install.sh",
      "sudo bash dcos_install.sh master"
    ]
  }
}

resource "null_resource" "deploy_private_agent" {
  count = var.nb_nodes_private_agent

  connection { 
    host = element(scaleway_instance_server.private_agent.*.public_ip, count.index)
    type = "ssh"
    user = "root"
    private_key = file("~/.ssh/id_rsa") 
  }

  provisioner "remote-exec" {
    inline = [
      # ensure ntp sync
      "systemctl stop ntpd",
      "ntpd -gq",
      "systemctl start ntpd",

      "mkdir /tmp/dcos && cd /tmp/dcos",
      "curl -O http://${scaleway_instance_server.bootstrap.private_ip}:8080/dcos_install.sh",
      "sudo bash dcos_install.sh slave"
    ]
  }
}

resource "null_resource" "deploy_public_agent" {
  count = var.nb_nodes_public_agent

  connection { 
    host = element(scaleway_instance_server.public_agent.*.public_ip, count.index)
    type = "ssh"
    user = "root"
    private_key = file("~/.ssh/id_rsa") 
  }

  provisioner "remote-exec" {
    inline = [
      # ensure ntp sync
      "systemctl stop ntpd",
      "ntpd -gq",
      "systemctl start ntpd",

      "mkdir /tmp/dcos && cd /tmp/dcos",
      "curl -O http://${scaleway_instance_server.bootstrap.private_ip}:8080/dcos_install.sh",
      "sudo bash dcos_install.sh slave_public"
    ]
  }
}