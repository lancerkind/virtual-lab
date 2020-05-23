resource "aws_instance" "ec2_aec_student" {
  count = var.per_student_loadout["development_workstations"] * var.number_of_students + local.number_of_instructors

  ami = var.ami[var.aws_region]
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
	  private_key = local.private_ssh_key
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
      private_key = local.private_ssh_key
    }
    script = "provisionStudent.sh"
  }

        	
  tags = {
    Name = "Agile Engineering Class Student ${format("%03d", count.index)}"
  }
}
