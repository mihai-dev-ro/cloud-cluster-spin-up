data "scaleway_instance_image" "centos" {
  name = "dcos-base-image"  # CentOS 7.6 with Docker, NTP installed
  architecture = "x86_64"
} 

resource "scaleway_instance_server" "agent_private" {
  name = var.server_name
  type = var.server_type
  image = data.scaleway_instance_image.centos.id
  security_group_id = var.security_group
  enable_dynamic_ip = true


  connection {
    host = self.public_ip
    type = "ssh"
    user = "root"
    private_key = file("~/.ssh/id_rsa")
  }

  provisioner "remote-exec" {
    inline = [
      "sudo systemctl stop firewalld && sudo systemctl disable firewalld",
      "sudo systemctl stop dnsmasq && sudo systemctl disable dnsmasq.service"
      
      # should I install HDFS name node?
    ]
  }

  provisioner "file" {
    content       = file("${path.module}/daemon.json")
    destination   = "/etc/docker/daemon.json"
  }
}

