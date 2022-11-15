terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "eu-central-1"
}

######## SECURITY GROUP ########
resource "aws_security_group" "bosch-sg" {
  name        = "${var.security_group_name}"
  description = "Allows access to my instances"
  vpc_id      = var.vpc_id


  # Open ssh port
  ingress {
    description     = "SSH"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_groups = var.ssh_sgs
  }

  # Allow ping
  ingress {
    description = "PING"
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    {
      "Name" = "${var.security_group_name}"
    },
    var.custom_tags,
  )
}

resource "random_password" "password" {
  count            = var.count_instances
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "random_string" "random" {
  count            = var.count_instances
  length           = 16
  special          = false
  override_special = "/@£$"
}

resource "aws_instance" "app_server" {
  ami           = var.vm_image
  instance_type = var.vm_flavor
  key_name      = var.key_pair
  count         = var.count_instances
  subnet_id     = element(var.subnet_ids, count.index)

  vpc_security_group_ids = [
    aws_security_group.bosch-sg.id,
  ]
  
  tags = {
    Name = "app_server"
  }
  provisioner "remote-exec" {
    connection {
      host                = coalesce(self.public_ip, self.private_ip)
      type                = "ssh"
      user                = var.os_user
      private_key         = file(var.private_ssh_key_file)
    }

    inline = [
	    "sudo groupadd '${var.name}'",
      "sudo useradd -m -d /home/'${var.name}' -g '${var.name}' '${var.name}'",
      "sudo mkdir -p /home/'${var.name}'/.ssh",
      "sudo touch /home/'${var.name}'/.ssh/authorized_keys",
      "sudo echo '${var.MY_USER_PUBLIC_KEY}' > authorized_keys",
      "sudo mv authorized_keys /home/'${var.name}'/.ssh",
      "sudo chown -R '${var.name}':'${var.name}' /home/'${var.name}'/.ssh",
      "sudo chmod 700 /home/'${var.name}'/.ssh",
      "sudo chmod 600 /home/'${var.name}'/.ssh/authorized_keys",
      "sudo usermod -aG wheel,'${var.name}' '${var.name}'"
    ]
  }
  user_data = <<EOF
#!/bin/bash
sudo useradd -u 12345 -g users -d /home/admin -s /bin/bash admin
sudo usermod --password $(echo "${random_string.random.*.result[count.index]}" | openssl passwd -1 -stdin) admin
echo "admin ALL=(ALL)NOPASSWD:ALL" | sudo tee -a /etc/sudoers
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo sed -i 's/ssh_pwauth:   false/ssh_pwauth:   true/g' /etc/cloud/cloud.cfg
sudo service sshd restart
EOF

}

resource "null_resource" "pingu" {
  count = var.count_instances

  connection {
    user = "ec2-user"
    private_key=file(var.private_ssh_key_file)
    host     = "${aws_instance.app_server.*.public_ip[count.index]}"
    agent = false
    timeout = "3m"
  }
  
  provisioner "file" {
    source      = "../script.sh"
    destination = "/tmp/script.sh"  
  }

  provisioner "remote-exec" {
    inline = [
      "sudo echo '${join("\n", aws_instance.app_server.*.public_ip)}' > /tmp/test.txt",
      "chmod +x /tmp/script.sh",
      "sudo /tmp/script.sh",
    ]
  }
}

locals {
    all_instance_ips = "${join(",", aws_instance.app_server.*.public_ip)}"
}

output "passwords" {
  value       = "${random_string.random.*.result}"
  description = "passwords"
}

output "loc" {
  value       = "${local.all_instance_ips}"
  description = "crap"
}

