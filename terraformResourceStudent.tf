resource "aws_instance" "ec2_aec_student" {
#  count = 75
  count = 8
  
  #AMI for Ubuntu 18.04
  ami = "ami-07d0cf3af28718ef8"
  instance_type = "m4.large"
  key_name = aws_key_pair.aec_key_pair.key_name
  security_groups = ["${aws_security_group.aec_sg_student.name}"]

   # increase SSH timeouts which might address dropped connection with Terraform V.11
   # https://github.com/hashicorp/terraform/issues/18517
   provisioner "remote-exec" {
    connection {
      host = self.public_ip
      type = "ssh"
      user = "ubuntu"
	  private_key = file("/Users/lancer/workspace/virtual-lab/privatekey.txt")
    }
    inline = [
    	"sudo sed -i '/#ClientAliveInterval/c\\ClientAliveInterval 120' /etc/ssh/sshd_config",
    	"sudo sed -i '/#ClientAliveCountMax/c\\ClientAliveCountMax 720' /etc/ssh/sshd_config",
    ]
  }
  
  # Provision student workstation
  provisioner "remote-exec" {
    connection {
      host = self.public_ip
      type = "ssh"
      user = "ubuntu"
      private_key = file("/Users/lancer/workspace/virtual-lab/privatekey.txt")
    }
    script = "provisionStudent.sh"
  }

   # Install OS updates
   provisioner "remote-exec" {
    connection {
      host = self.public_ip
      type = "ssh"
      user = "ubuntu"
	  private_key = file("/Users/lancer/workspace/virtual-lab/privatekey.txt")
    }
    inline = [
    	"sudo DEBIAN_FRONTEND=noninteractive apt-get -yqq dist-upgrade",
    ]
  }
        	
  tags = {
    Name = "Agile Engineering Class Student ${format("%03d", count.index)}"
  }
}
