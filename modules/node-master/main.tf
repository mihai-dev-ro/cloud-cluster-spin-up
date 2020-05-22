data "scaleway_instance_image" "centos" {
  name = "dcos-base-image"  # CentOS 7.6 with Docker, NTP installed
  architecture = "x86_64"
}

resource "scaleway_instance_server" "master" {
  name = var.server_name
  image = data.scaleway_instance_image.centos.id
  type = var.server_type
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
}


