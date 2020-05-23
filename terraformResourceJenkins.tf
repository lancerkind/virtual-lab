resource "aws_instance" "ec2_aec_jenkins" {
  count = var.per_student_loadout["jenkins"] * var.number_of_students

  ami = var.ami[var.aws_region]
  instance_type = "t2.micro"
  key_name = aws_key_pair.aec_key_pair.key_name
  security_groups = ["${aws_security_group.aec_sg_jenkins.name}"]
  provisioner "remote-exec" {
    connection {
      host = self.public_ip
      type = "ssh"
      user = "ubuntu"
      private_key = local.private_ssh_key
    }
    script = "provisionJenkins.sh"
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
    Name = "Agile Engineering Class Jenkins ${format("%03d", count.index)}"
  }
}
