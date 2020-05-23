resource "aws_instance" "ec2_aec_bamboo" {
  count = var.per_student_loadout["bamboo"]
  
  ami = var.ami[var.aws_region] * var.number_of_students
  instance_type = "m4.large" # assess what size is necessary.
  key_name = aws_key_pair.aec_key_pair.key_name
  security_groups = ["${aws_security_group.aec_sg_bamboo.name}"]
  
  provisioner "remote-exec" {
    connection {
      host = self.public_ip
      type = "ssh"
      user = "ubuntu"
 	  private_key = local.private_ssh_key
    }
    script = "provisionBamboo.sh"
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
    Name = "Agile Engineering Class Bamboo ${format("%03d", count.index)}"
  }
}
