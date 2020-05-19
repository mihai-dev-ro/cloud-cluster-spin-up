data "scaleway_instance_image" "centos" {
  name = "CentOS 7.6"
  architecture = "x86_64"
} 

resource "scaleway_instance_server" "agent_private" {
  name = var.server_name
  type = var.server_type
  image = data.scaleway_instance_image.centos.id
  security_group_id = var.security_group
  enable_dynamic_ip = true

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
      "yum install -y yum-utils device-mapper-persistent-data lvm2",
      "yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo",
      "yum install docker",
      "systemctl start docker",
      "systemctl enable docker",

      # network time protocol (to sync the times on all machines)
      "chkconfig ntpd on",
      "ntpdate -s ntp.ubuntu.com",

      # should I install HDFS name node?
    ]
  }

  provisioner "file" {
    source = "daemon.json"
    destination = "/etc/docker/daemon.json"
  }
}

resource "scaleway_instance_security_group_rules" "security-rule" {
  security_group_id = var.security_group

  inbound_rule {
    action = "accept"
    protocol = "TCP"
    ip_range = scaleway_instance_server.agent_private.private_ip
  }
}

