resource "aws_instance" "ec2_aec_student" {
#  count = 75
  count = 1
  #AMI for Ubuntu 18.04
  ami = "ami-07d0cf3af28718ef8"
  instance_type = "m4.large"
  key_name = "${aws_key_pair.aec_key_pair.key_name}"
  security_groups = ["${aws_security_group.aec_sg_student.name}"]
  
  provisioner "remote-exec" {
    connection {
      type = "ssh",
      user = "ubuntu",
      private_key = "${file("/Users/lancer/workspace/virtual-lab/privatekey.txt")}"
    }
    script = "provisionStudent.sh"
  }
  
    provisioner "remote-exec" {
    connection {
      type = "ssh",
      user = "ubuntu",
	  private_key = "${file("/Users/lancer/workspace/virtual-lab/privatekey.txt")}"
    }
    inline = ["sudo reboot now"]
  }
  	
  tags {
    Name = "Agile Engineering Class Student ${format("%03d", count.index)}"
  }
}
