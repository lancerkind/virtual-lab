resource "aws_instance" "ec2_aec_gitlab" {
  count = var.per_student_loadout["gitlab"] * var.number_of_students
  
  ami = var.ami[var.aws_region]
  instance_type = "m4.large"  # try an m6g.medium or a t2.small for this: https://aws.amazon.com/ec2/instance-types/  https://aws.amazon.com/ec2/pricing/on-demand/
  key_name = aws_key_pair.aec_key_pair.key_name
  security_groups = ["${aws_security_group.aec_sg_gitlab.name}"]
  provisioner "remote-exec" {
    connection {
      host = self.public_ip    
      type = "ssh"
      user = "ubuntu"
      private_key = local.private_ssh_key
    }
    script = "provisionGitLab.sh"
  }
  provisioner "remote-exec" {
    connection {
      host = self.public_ip
      type = "ssh"
      user = "ubuntu"
      private_key = local.private_ssh_key
      
    }
    inline = ["sudo reboot now"]
  }
  tags = {
    Name = "Agile Engineering Class GitLab ${format("%03d", count.index)}"
  }
}
