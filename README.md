# Technical Lab Infrastructure Using Terraform 

This is a Terraform example that can generate as many EC2 instances as necessary for an Agile Engineering Course. Some requirements that lead to this solution are:

  - Need for a development environment with appropriate tools (IDE, etc.)
  - Need to have zero installation on client machines (no software, no open ports, etc.).  Must run in browser.
  - Low cost.
  - Easy to setup before class starts.
  - Provide a continuous integration machine for class demos.
  - Provide a git remote repository machine for class demos.

# Design 
To meet these goals, the decision was made to run on AWS EC2 instances.  These instances are treated as Infrastructure as Code (hence this project).  As written, the instances run Ubuntu 18.04.  There is not a publicly available AWS AMI that includes the Ubuntu Desktop.  This project provisions a complete desktop, along with IntelliJ for students to easily write and debug code with.

To gain access to the desktop, virtual network computing (VNC) protocol is layered on top of the X11 desktop.  To provide a solution that is purely web based, Apache Guacamole is then layered on top of that to render the VNC into HTML5.  This also provides the ability to have several students share desktops, for classroom aid, as well as remote pairing.  Students merely have to point their browser to http://[AWS EC2 Public DNS Name].  Use USERNAME and PASSWORD for access.

# Use
1. Make sure that you can use AWS CLI without issue.  In particular,
you need valid ~/.aws config and credentials files.
2. Make sure that you have **unencrypted** SSH keys generated in your ~/.ssh.  This can be done by the following and don't set a password (just press return when it prompts you for a password): 
```
ssh-keygen -t rsa -f keyfile.txt
```
src: https://docs.joyent.com/public-cloud/getting-started/ssh-keys/generating-an-ssh-key-manually/manually-generating-your-ssh-key-in-mac-os-x

3. Make sure that Terraform is installed.
4. Ensure that terraformProvider.tf has appropriate settings for your use.  For example,
the AWS region may have to change, and that will require a change in the 
AMI used.
5. On the command line, create the infrastructure with
 ```
 terraform apply
 ```
6. After a whole lot of provisioning, you should see things such as the following (a run with two student instances being created). 
```
Apply complete! Resources: 9 added, 0 changed, 0 destroyed.

The state of your infrastructure has been saved to the path
below. This state is required to modify and destroy your
infrastructure, so keep it safe. To inspect the complete state
use the `terraform show` command.

State path: 

Outputs:

gitlab_address = [
    ec2-54-175-158-139.compute-1.amazonaws.com
]
gitlab_ip = [
    54.175.158.139
]
jenkins_address = [
    ec2-54-144-23-36.compute-1.amazonaws.com
]
jenkins_ip = [
    54.144.23.36
]
student_addresses = [
    ec2-184-73-144-130.compute-1.amazonaws.com
]
student_ips = [
    184.73.144.130
]
teamcity_address = [
    ec2-34-201-43-178.compute-1.amazonaws.com
]
teamcity_ip = [
    34.201.43.178
]
```
7. Integrated automated testing of the infrastructure is built into the system.
To test, from the command line, enter
```
mvn
```
8. Cucumber feature files will be built in the validate exec:java phase and run in the test phase.  You should see things like the following in response to your "mvn" command:
```
-------------------------------------------------------
 T E S T S
-------------------------------------------------------
Running com.siq.aec.TestRunner
Feature: Agile Engineering Course Infrastructure as Code for Gitlab Machine

  Scenario Outline: Check GitLab connectivity      # InfrastructureGitlab.feature:3
    When I look at "<aecGitlabInstance>"
    Then it should be running "sshd" on port "22"
    And it should be running "master" on port "25"
    And it should be running "nginx" on port "80"
    And port "22" should be open
    And port "25" should be open
    And port "80" should be open

    Examples: 
!!! Warning: Permanently added 'ec2-54-175-158-139.compute-1.amazonaws.com,54.175.158.139' (ECDSA) to the list of known hosts.

  Scenario Outline: Check GitLab connectivity                   # InfrastructureGitlab.feature:15
    When I look at "ec2-54-175-158-139.compute-1.amazonaws.com" # Stepdefs.i_look_at(String)
    Then it should be running "sshd" on port "22"               # Stepdefs.it_should_be_running_on_port(String,String)
    And it should be running "master" on port "25"              # Stepdefs.it_should_be_running_on_port(String,String)
    And it should be running "nginx" on port "80"               # Stepdefs.it_should_be_running_on_port(String,String)
    And port "22" should be open                                # Stepdefs.port_should_be_open(String)
    And port "25" should be open                                # Stepdefs.port_should_be_open(String)
    And port "80" should be open                                # Stepdefs.port_should_be_open(String)
Feature: Agile Engineering Course Infrastructure as Code for Jenkins Machine

  Scenario Outline: Check Jenkins connectivity     # InfrastructureJenkins.feature:3
    When I look at "<aecJenkinsInstance>"
    Then it should be running "sshd" on port "22"
    And it should be running "master" on port "25"
    And it should be running "java" on port "8080"
    And port "22" should be open
    And port "25" should be open
    And port "80" should be open

    Examples: 
!!! Warning: Permanently added 'ec2-54-144-23-36.compute-1.amazonaws.com,54.144.23.36' (ECDSA) to the list of known hosts.

  Scenario Outline: Check Jenkins connectivity                # InfrastructureJenkins.feature:16
    When I look at "ec2-54-144-23-36.compute-1.amazonaws.com" # Stepdefs.i_look_at(String)
    Then it should be running "sshd" on port "22"             # Stepdefs.it_should_be_running_on_port(String,String)
    And it should be running "master" on port "25"            # Stepdefs.it_should_be_running_on_port(String,String)
    And it should be running "java" on port "8080"            # Stepdefs.it_should_be_running_on_port(String,String)
    And port "22" should be open                              # Stepdefs.port_should_be_open(String)
    And port "25" should be open                              # Stepdefs.port_should_be_open(String)
    And port "80" should be open                              # Stepdefs.port_should_be_open(String)
Feature: Agile Engineering Course Infrastructure as Code for Student Machines

  Scenario Outline: Check Student connectivity          # InfrastructureStudent.feature:3
    When I look at "<aecStudentInstance>"
    Then it should be running "sshd" on port "22"
    And it should be running "guacd" on port "4822"
    And it should be running "Xtightvnc" on port "5901"
    And it should be running "java" on port "8080"
    And port "22" should be open
    And port "80" should be open

    Examples: 
!!! Warning: Permanently added 'ec2-184-73-144-130.compute-1.amazonaws.com,184.73.144.130' (ECDSA) to the list of known hosts.

  Scenario Outline: Check Student connectivity                  # InfrastructureStudent.feature:15
    When I look at "ec2-184-73-144-130.compute-1.amazonaws.com" # Stepdefs.i_look_at(String)
    Then it should be running "sshd" on port "22"               # Stepdefs.it_should_be_running_on_port(String,String)
    And it should be running "guacd" on port "4822"             # Stepdefs.it_should_be_running_on_port(String,String)
    And it should be running "Xtightvnc" on port "5901"         # Stepdefs.it_should_be_running_on_port(String,String)
    And it should be running "java" on port "8080"              # Stepdefs.it_should_be_running_on_port(String,String)
    And port "22" should be open                                # Stepdefs.port_should_be_open(String)
    And port "80" should be open                                # Stepdefs.port_should_be_open(String)
Feature: Agile Engineering Course Infrastructure as Code for TeamCity Machine

  Scenario Outline: Check TeamCity connectivity    # InfrastructureTeamCity.feature:3
    When I look at "<aecTeamCityInstance>"
    Then it should be running "sshd" on port "22"
    And it should be running "master" on port "25"
    And it should be running "java" on port "8111"
    And port "22" should be open
    And port "25" should be open
    And port "80" should be open

    Examples: 
!!! Warning: Permanently added 'ec2-34-201-43-178.compute-1.amazonaws.com,34.201.43.178' (ECDSA) to the list of known hosts.

  Scenario Outline: Check TeamCity connectivity                # InfrastructureTeamCity.feature:15
    When I look at "ec2-34-201-43-178.compute-1.amazonaws.com" # Stepdefs.i_look_at(String)
    Then it should be running "sshd" on port "22"              # Stepdefs.it_should_be_running_on_port(String,String)
    And it should be running "master" on port "25"             # Stepdefs.it_should_be_running_on_port(String,String)
    And it should be running "java" on port "8111"             # Stepdefs.it_should_be_running_on_port(String,String)
    And port "22" should be open                               # Stepdefs.port_should_be_open(String)
    And port "25" should be open                               # Stepdefs.port_should_be_open(String)
    And port "80" should be open                               # Stepdefs.port_should_be_open(String)

4 Scenarios (4 passed)
28 Steps (28 passed)
0m7.403s

Tests run: 32, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 9.635 sec

Results :

Tests run: 32, Failures: 0, Errors: 0, Skipped: 0

[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time: 17.490 s
[INFO] Finished at: 2017-05-05T18:45:04-04:00
[INFO] Final Memory: 20M/188M
[INFO] ------------------------------------------------------------------------```
```
9. Use the following terraform commands to aid in the creation of
eMails, etc. (responses are should after the command):
```
terraform output gitlab_address
ec2-34-207-89-114.compute-1.amazonaws.com
terraform output jenkins_address
ec2-34-201-93-235.compute-1.amazonaws.com
terraform output student_addresses
ec2-54-82-248-68.compute-1.amazonaws.com
terraform output teamcity_address
ec2-34-203-217-157.compute-1.amazonaws.com
```
10. Students log on to their machine through a browser that supports HTML5.
For example, a student would point their browser to
```
http://ec2-54-152-234-84.compute-1.amazonaws.com
```
11. Log on with USERNAME and PASSWORD.
12. It is assumed that you know how to use and configure Jenkins.  Point your browser to the URL created and provisioned by Terraform.  You will have to ssh into the Jenkins server once to supply the secret password to the browser to unlock Jenkins.
12. It is also assumed that you know how to use and configure TeamCity.  Point your browser to the URL created and provisioned by Terraform.  TeamCity is much easier to use, and prettier as well.  You will not need to unlock the application with a copy and paste from the output of an ssh session into the server.
14. It is also assumed that you know how to use and configure GitLab.  Point your browser to the URL created and provisioned by Terraform.  
15. When the infrastructure is no longer needed, destroy the 
infrastructure on the command line with
```
terraform destroy
```
16. You will have to type in "yes" and should see things like:
```
terraform destroy
Do you really want to destroy?
  Terraform will delete all your managed infrastructure.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

aws_security_group.aec_sg_gitlab: Refreshing state... (ID: sg-1e2b8f60)
aws_security_group.aec_sg_student: Refreshing state... (ID: sg-ef2a8e91)
aws_security_group.aec_sg_jenkins: Refreshing state... (ID: sg-993591e7)
aws_security_group.aec_sg_teamcity: Refreshing state... (ID: sg-b5298dcb)
aws_key_pair.aec_key_pair: Refreshing state... (ID: aec_key_pair)
aws_instance.ec2_aec_gitlab: Refreshing state... (ID: i-01a75a9cd42d2006f)
aws_instance.ec2_aec_teamcity: Refreshing state... (ID: i-06fb706eed1b25e54)
aws_instance.ec2_aec_jenkins: Refreshing state... (ID: i-022d3e0d11eab8722)
aws_instance.ec2_aec_student: Refreshing state... (ID: i-0a0c0904390d45013)
aws_instance.ec2_aec_gitlab: Destroying... (ID: i-01a75a9cd42d2006f)
aws_instance.ec2_aec_student: Destroying... (ID: i-0a0c0904390d45013)
aws_instance.ec2_aec_teamcity: Destroying... (ID: i-06fb706eed1b25e54)
aws_instance.ec2_aec_jenkins: Destroying... (ID: i-022d3e0d11eab8722)
aws_instance.ec2_aec_teamcity: Still destroying... (ID: i-06fb706eed1b25e54, 10s elapsed)
aws_instance.ec2_aec_jenkins: Still destroying... (ID: i-022d3e0d11eab8722, 10s elapsed)
aws_instance.ec2_aec_student: Still destroying... (ID: i-0a0c0904390d45013, 10s elapsed)
aws_instance.ec2_aec_gitlab: Still destroying... (ID: i-01a75a9cd42d2006f, 10s elapsed)
aws_instance.ec2_aec_jenkins: Still destroying... (ID: i-022d3e0d11eab8722, 20s elapsed)
aws_instance.ec2_aec_gitlab: Still destroying... (ID: i-01a75a9cd42d2006f, 20s elapsed)
aws_instance.ec2_aec_teamcity: Still destroying... (ID: i-06fb706eed1b25e54, 20s elapsed)
aws_instance.ec2_aec_student: Still destroying... (ID: i-0a0c0904390d45013, 20s elapsed)
aws_instance.ec2_aec_student: Still destroying... (ID: i-0a0c0904390d45013, 30s elapsed)
aws_instance.ec2_aec_gitlab: Still destroying... (ID: i-01a75a9cd42d2006f, 30s elapsed)
aws_instance.ec2_aec_teamcity: Still destroying... (ID: i-06fb706eed1b25e54, 30s elapsed)
aws_instance.ec2_aec_jenkins: Still destroying... (ID: i-022d3e0d11eab8722, 30s elapsed)
aws_instance.ec2_aec_student: Destruction complete
aws_security_group.aec_sg_student: Destroying... (ID: sg-ef2a8e91)
aws_instance.ec2_aec_teamcity: Destruction complete
aws_security_group.aec_sg_teamcity: Destroying... (ID: sg-b5298dcb)
aws_security_group.aec_sg_student: Destruction complete
aws_security_group.aec_sg_teamcity: Destruction complete
aws_instance.ec2_aec_jenkins: Still destroying... (ID: i-022d3e0d11eab8722, 40s elapsed)
aws_instance.ec2_aec_gitlab: Still destroying... (ID: i-01a75a9cd42d2006f, 40s elapsed)
aws_instance.ec2_aec_gitlab: Destruction complete
aws_security_group.aec_sg_gitlab: Destroying... (ID: sg-1e2b8f60)
aws_security_group.aec_sg_gitlab: Destruction complete
aws_instance.ec2_aec_jenkins: Still destroying... (ID: i-022d3e0d11eab8722, 50s elapsed)
aws_instance.ec2_aec_jenkins: Still destroying... (ID: i-022d3e0d11eab8722, 1m0s elapsed)
aws_instance.ec2_aec_jenkins: Destruction complete
aws_security_group.aec_sg_jenkins: Destroying... (ID: sg-993591e7)
aws_key_pair.aec_key_pair: Destroying... (ID: aec_key_pair)
aws_key_pair.aec_key_pair: Destruction complete
aws_security_group.aec_sg_jenkins: Destruction complete

Destroy complete! Resources: 9 destroyed.
```

# Tips to working in the lab
## How to SSH to a lab machine
example: $ ssh -i privatekey.txt ubuntu@<ip address>
The IP address an instance can be found in the AWS console or in the terraform output.

## How to VNC to a lab instance
example: on MacOS open Screen Sharing app.  Connect to the IP address of the instance via port 5901.  See ProvisionStudent.sh, search for "authorize" XML document to see the password. 
In the dialog box enter: ip-address:5901
In the password prompt enter (or whatever password you've used in ProvisionStudent.sh): VNCPASS

## How to clone an EC2 instance
You don't actually clone instances but create an AMI (Amazon Machine Image) from an existing instance. Doing this will create an *AMI*: https://docs.bitnami.com/aws/faq/administration/clone-server/
To see the AMI go to the "Images" area in the aws console. From there you can launch it which creates an instance.  You'll need to specify the security group (re-use the existing one) and select the correct key. 
For some reason I had a difficulty in getting VNCserver running on the first launch and had to do a reboot (see Troubleshooting Guide).

# Troubleshooting Guide

The most fragile pieces are the hardcoded urls to download iDEA and Eclipse.  As is, the iDEA link will break whenever Jetbrains rolls out a new release. See the note in provisionStudent.sh for a tip on how to discover the new url. Other complexity is getting the various pieces of X11, Tomcat, VNC, and Guacamole working smoothly.
Remote system X11 <-> VNC (port 5901) <-> Guacd <-> Tomcat (port 8080 but NATed to 80) <-> Guacamole client 

All of the above is configured by provisionStudent.sh. VNCServer is what decides the screen resolution everything uses.

## Problem: Browsing to the EC2 instance's website (port 80) page doesn't load and serve the Guacamole client.
## Resolution: Either the service isn't running or something is preventing the network connection.
When everything is working, the interactions happen thusly:
workstation: web browser port 80 -> AWS Cloud -> ubuntu -> ubuntu:ip tables forward from 80 to 8080 (and the reverse) -> tomcat -> guacamole -> vnc server 
Trouble shooting starts by probing the above interactions: Using a VNC client (MacOS Screen Sharing), connect directly to port 5901 (X11 displays are mapped to network ports starting with 5900. So display "1:" is accessable at 5901. Display "2:" at 5902, and so on.). If you get the password prompt, then VNC service are running.  So the problem could be a guacamole issuer or the problem is a network issue.
### find out if Guucamole service is working
Open a web browser within ubuntu and connect to localhost:8080.  If you see the Guacomale client, then the problem is that the port forwarding didn't work (either the security group or the ubuntu instance).  
### find out if the problem is the AWS security group 
* Open a web browser within ubuntu and connect to localhost:80. If you see the Guacomale client, then the problem is the AWS security group. Go fix it's inbound rules. 
* If the browser on ubuntu can connect via port 80, then check if the ubuntu's instance's if iptables are setup correctly.  It's also possible that they aren't persisnting after a reboot.  See iptables commands in provisionStudent.sh.
 
## Problem: I type in the username and password in the Guacamole client, but it won't accept my credentials.
## Resolution: The Guacamole server Guacd isn't configured with the password you're trying to use.  SSH in and check ```/etc/guacamole/user-mapping.xml``` and the line:     ```<authorize username="USERNAME" password="PASSWORD">```

## Problem: After Guacamole client accepts my password, it errors saying "failure to connect".
## Resolution: Either the VNC server isn't running or it is but Guacamole and VNC disagree on some settings and so Guacd and VNC aren't connecting.  First, check that the server is running by doing a SSH and ```ps -eaf | grep vnc']```.
If you see nothing, then the vnc server isn't running.  Start it by one of the following ways: 1) ```$ vnc4server```
      2) ```$ systemctl start vnc4server@1```
Then run the aformentioned ```ps``` command and observer that it's running.  Now try logging in via Guacamole.  If it still doesn't work then perhaps Guacamole and VNC disagree on the password.  

Guacamole has accepts one usename password, and then passes a potentially *different* password to VNC.  Let's check that they match.  Go to ```/etc/guacamole/user-mapping.xml``` and observe what password is being used at:  ```<authorize username="USERNAME" password="PASSWORD">```. This username and password is what Guacamole accepts from the user. What Guacamole passes to VNC is configured in the same file at: 
```<param name="hostname">localhost</param>
   <param name="port">5901</param>
   <param name="password">VNCPASS</param>``` 
All of the above have to be correct for Guacd to be able to connect to the VNC:
- hostname should be localhost
- port 5901 means that we are using X11 display ":1" This can be confirmed by looking at ```ps -eaf | grep vnc``` and it shows something like the below (notice the ":1" and the "5901"):
```ubuntu    8346     1  6 02:58 ?        00:02:28 Xvnc4 :1 -desktop ip-172-31-82-22:1 (ubuntu) -auth /home/ubuntu/.Xauthority -geometry 1920x1080 -depth 16 -rfbwait 30000 -rfbauth /home/ubuntu/.vnc/passwd -rfbport 5901 -pn -fp /usr/X11R6/lib/X11/fonts/Type1/,/usr/X11R6/lib/X11/fonts/Speedo/,/usr/X11R6/lib/X11/fonts/misc/,/usr/X11R6/lib/X11/fonts/75dpi/,/usr/X11R6/lib/X11/fonts/100dpi/,/usr/share/fonts/X11/misc/,/usr/share/fonts/X11/Type1/,/usr/share/fonts/X11/75dpi/,/usr/share/fonts/X11/100dpi/ -co /etc/X11/rgb
ubuntu    8356```    
- password should match what was set using the ```vnc4passwd``` or ```vnc4server``` (the first time the vnc4server command is run it will ask for a password if none has been set).  Since VNC encrypts the password connect a VNC client to port 5901 and try the password set in this configuration file. If that password works, then the password is correct. If the password is incorrect, then set the vnc password using ```vnc4passwd```, then go try to login with guacamole.

##Problem: VNC client fails to connect to the EC2 instance's VNC server.  
##Resolution:
- SSH in and check that the VNC process is is running. 
- Check the EC2 security groups and confirm that they are allowing inbound connections to 5901.
-If the above two bullets don't resolve the problem, check that the username, group, are as expected in /etc/systemd/system/vnc4server script.

##Problem: Want to change the resolution being sent over Guacamole
## Resolution: adjust the ```-geometry``` argument in the file /etc/systemd/system/vnc4server@.service
Once you save the file systemd needs to be told that the file has changed (so it can build symlinks to it), and to restart it:
```$ sudo systemctl deamon-reload
   $ sudo systemctl restart vnc4server@1```
   
##Problem: When Guacamole sits idle, it loses connection.
##Resolution: click "reconnect" and resume your activity.

##Problem: I got a working EC2 instance. I cloned it to an AMI and launched the AMI (using the same security groups and using the right key-store), but the VNC server isn't running.
##Resolution: rebooting the instance fixed the problem. Simply launching the VNC server unfortunately puts it on display 2 and then guacamole can't find it without reconfiguring.
  