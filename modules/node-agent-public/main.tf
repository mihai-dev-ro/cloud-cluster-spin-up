data "scaleway_server_image" "centos" {
  name = "CentOS 7.6"
  architecture = "x86_64"
}

resource "scaleway_instance_server" "agent_public" {
  name = "${var.server_name}"
  image = "${data.scaleway_server_image.centos.id}"
  type = "${var.server_type}"
  security_group_id = "${var.security_group_opendoors}"
  enable_dynamic_id = true
}

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
resource "scaleway_instance_security_group_rules" "security-rule" {
  security_group_id = "${var.security_group}"

  inbound_rule {
    action = "accept"
    ip_range = "${scaleway_instance_server.agent_public.private_ip}"
    protocol = "TCP"
  }
}


