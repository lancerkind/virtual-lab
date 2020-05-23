locals {
	aws_key_name = "lancer@macattack"
	private_ssh_key = file("/Users/lancer/workspace/virtual-lab/privatekey.txt")
	aws_public_key = file("/Users/lancer/workspace/virtual-lab/privatekey.txt.pub")
	
	number_of_instructors = 1 
}

variable "aws_region" {
	default = "us-east-1"
}

variable "ami" { #AMI for Ubuntu 18.04
	type = map(string)	
	default = {
	 	us-east-1 = "ami-07d0cf3af28718ef8"   
	 }
}

variable number_of_students {
	type = number
}

variable per_student_loadout {
	description = "What resources each student will have access to."
	
	type = map(number)
	default = {
		development_workstations 	= 1
		bamboo 						= 0
		gitlab 						= 0
		jenkins 					= 0
		teamcity 					= 0
	}
}