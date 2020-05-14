#!/bin/bash
################### PROVISIONS UBUNTU 18 WITH GUACAMOLE, TOMCAT8, TIGHTVNC, and developer goodies ###################

function create_debug_log () {
scriptName=`echo $0 | sed -e "s./._.g" | sed -e "s/\./_/g"`
exec 1<&-
exec 2<&-
exec 1<>~/$scriptName.out
exec 2>&1
set -x
date
}

create_debug_log

################### Install apps needed for doing sharing X: Tomcat, Guacamole, xfce, vnc server
sudo apt-get -yqq update && sudo apt-get -yqq upgrade  	#get apt-get ready on a clean install.
sudo apt-get -yqq install build-essential
# sudo apt-get -yqq install lib/intserver-dev
sudo apt-get -yqq install tomcat8 ghostscript jq wget curl

# Add GUACAMOLE_HOME to Tomcat8 ENV
sudo chmod +w /etc/default/tomcat8
sudo bash -c 'echo "" >> /etc/default/tomcat8'
sudo bash -c 'echo "# GUACAMOLE EVN VARIABLE" >> /etc/default/tomcat8'
sudo bash -c 'echo "GUACAMOLE_HOME=/etc/guacamole" >> /etc/default/tomcat8'

# Get your Preferred Mirror for download from Apache using jq
SERVER=$(curl -s 'https://www.apache.org/dyn/closer.cgi?as_json=1' | jq --raw-output '.preferred|rtrimstr("/")')

# Download Guacamole Files from Preferred Mirror
wget $SERVER/guacamole/1.0.0/source/guacamole-server-1.0.0.tar.gz
wget $SERVER/guacamole/1.0.0/binary/guacamole-1.0.0.war

#Extract Guacamole server
tar -xzf guacamole-server-1.0.0.tar.gz

# MAKE DIRECTORIES
sudo mkdir /etc/guacamole
sudo mkdir /etc/guacamole/lib
sudo mkdir /etc/guacamole/extensions

# configure guacamole server
sudo bash -c 'cat <<EOF >> /etc/guacamole/guacamole.properties
guacd-hostname:     localhost
guacd-port:         4822
user-mapping:       /etc/guacamole/user-mapping.xml
auth-provider:      net.sourceforge.guacamole.net.basic.BasicFileAuthenticationProvider
basic-user-mapping: /etc/guacamole/user-mapping.xml
EOF'

#sudo ln -s /etc/guacamole/guacamole.properties /usr/share/tomcat8/.guacamole/

# consider using a file provisioner to do work like the below
sudo bash -c 'cat <<EOF >> /etc/guacamole/user-mapping.xml
<user-mapping>
    <authorize username="USERNAME" password="PASSWORD">
        <connection name="Agile Engineering Workshop">
            <protocol>vnc</protocol>
            <param name="hostname">localhost</param>
            <param name="port">5901</param>
            <param name="password">VNCPASS</param>
        </connection>
    </authorize>
</user-mapping>
EOF'

#Build and Install GUACD 1.0
sudo apt-get -yqq install libcairo2-dev
sudo apt-get -yqq install libjpeg-turbo8-dev
# If RDP serving is wanted, then apt-get install freerdp2-shadow-x11 as although libfreerdp-dev
# is installed, there are dependencies on having an RDP server just as there needs to be a VNC
# server installed so guacd has something to talk to.
sudo apt-get -yqq install libossp-uuid-dev
sudo apt-get -yqq install libvncserver-dev
sudo apt-get -yqq install libfreerdp-dev
sudo apt-get -yqq install libpng-dev
sudo apt-get -yqq install libpulse-dev
sudo apt-get -yqq install libssh2-1-dev
sudo apt-get -yqq install libssl-dev
sudo apt-get -yqq install libvorbis-dev
sudo apt-get -yqq install libwebp-dev
sudo apt-get -yqq install libavcodec-dev libavutil-dev libswscale-dev
sudo apt-get -yqq install libpango1.0-dev  
wget http://www.trieuvan.com/apache/guacamole/1.0.0/source/guacamole-server-1.0.0.tar.gz
tar -xf guacamole-server-1.0.0.tar.gz 

cd guacamole-server-1.0.0
./configure --with-init-dir=/etc/init.d
make
sudo make install
sudo ldconfig
sudo systemctl enable guacd
cd ..

# Move guacamole *client* to correct locations
sudo mv guacamole-1.0.0.war /etc/guacamole/guacamole.war
sudo ln -s /etc/guacamole/guacamole.war /var/lib/tomcat8/webapps/
sudo rm -rf /var/lib/tomcat8/webapps/ROOT
sudo mv /var/lib/tomcat8/webapps/guacamole.war /var/lib/tomcat8/webapps/ROOT.war
#Need to install an RDP X11 shadow server to serve RDP to Guac.  See other note.
# sudo ln -s /usr/local/lib/freerdp/* /usr/lib/x86_64-linux-gnu/freerdp/.

#sudo rm -rf /usr/share/tomcat8/.guacamole
sudo ln -s /etc/guacamole /usr/share/tomcat8/.guacamole

# Restart Tomcat Service
sudo service tomcat8 restart

# Startup guacamole
/usr/local/sbin/guacd

# Install VNC server
sudo apt -yqq install vnc4server

# Install xfce4
sudo apt-get -yqq install xfce4 xfce4-goodies xfce4-terminal
sudo apt-get -yqq install chromium-browser

# Make up a VNC password file
mkdir /home/ubuntu/.vnc
sudo printf "VNCPASS\nVNCPASS\n\n" | vnc4passwd
chmod 600 /home/ubuntu/.vnc/passwd

# Configure VNCSERVER to bring up desktop
bash -c 'cat <<EOF >> /home/ubuntu/.vnc/xstartup
#!/bin/bash
xrdb $HOME/.Xresources
startxfce4 &
 vnc4config -nowin &
intellij &
EOF'

chmod +x /home/ubuntu/.vnc/xstartup

# Configure vncserver to start on reboot
# note about making sevices: There are at least two ways to do this in Linux: SystemD and Init/SysV.
# BUT: Ubuntu no longer supports Init model. So 
# https://vitux.com/ubuntu-vnc-server/
# https://www.tecmint.com/create-new-service-units-in-systemd/
# https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-vnc-on-ubuntu-18-04
# https://www.digitalocean.com/community/tutorials/how-to-use-systemctl-to-manage-systemd-services-and-units
# https://www.digitalocean.com/community/tutorials/understanding-systemd-units-and-unit-files

sudo bash -c 'cat <<EOF >> /etc/systemd/system/vnc4server@.service
[Unit]
 Description=Remote desktop service (VNC)
 After=syslog.target network.target

[Service]
 Type=forking
 User=ubuntu
 Group=ubuntu
 WorkingDirectory=/home/ubuntu
 PIDFile=/home/ubuntu/.vnc/%H:%i.pid
 ExecStartPre=-/usr/bin/vnc4server -kill :%i > /dev/null 2>&1
 ExecStart=/usr/bin/vnc4server -depth 16 -geometry 1920x1080 :%i
 ExecStop=/usr/bin/vnc4server -kill :%i

[Install]
  WantedBy=multi-user.target
EOF'

sudo systemctl daemon-reload                # tell systemctl there's a new config file.
sudo systemctl start vnc4server@1.service   # starts the service
sudo systemctl enable vnc4server@1.service  # setup symlinks for restart

################### Install Eclipse
sudo apt -yqq install eclipse

################### Install Java development kit
sudo apt -yqq install default-jdk

################### Install IntelliJ
# Tips on moving xfce4 config: https://unix.stackexchange.com/questions/353924/how-to-copy-all-my-xfce-settings-between-a-desktop-machine-and-a-laptop
# and https://www.linuxquestions.org/questions/slackware-14/xfce-menu-desktop-files-location-864839/

#IntelliJ download URL
# How I got this url on MacOS is that I downloaded from the IDEA website for Linux, canceled it, then
# went to downloads and 
# selected "get info" in the context menu which opens a window. In the window the 
# url will be listed.
wget https://download-cf.jetbrains.com/idea/ideaIC-2019.2.2.tar.gz
sudo tar -xf ideaIC-2019.2.2.tar.gz -C /opt/
sudo ln -s /opt/idea-IC-192.6603.28/bin/idea.sh /usr/local/sbin/intellij
sudo bash -c 'cat <<EOF >> /usr/share/applications/intellij.desktop
[Desktop Entry]
Version=1.0
Type=Application
Name=IntelliJ IDEA Community Edition
Icon=/opt/idea-IC-192.6603.28/bin/idea.svg
Exec=sudo "/opt/idea-IC-192.6603.28/bin/idea.sh" %f
Comment=Capable and Ergonomic IDE for JVM
Categories=Development;IDE;
Terminal=false
StartupWMClass=jetbrains-idea-ce
Path=
StartupNotify=false
EOF'
sudo chmod 744 /usr/share/applications/intellij.desktop
sudo chown root:root /usr/share/applications/intellij.desktop

################### Port forward 80 requests to 8080, and route 8080 responses to 80, and open ports for VNC connections.
# Need to muck about a bit. The iptables-persistent will be interactive unless using the strategy in the gist url.
#https://linuxconfig.org/how-to-make-iptables-rules-persistent-after-reboot-on-linux
#https://gist.github.com/alonisser/a2c19f5362c2091ac1e7
sudo iptables -I INPUT 1 -p tcp --dport 8080 -j ACCEPT
sudo iptables -I INPUT 1 -p tcp --dport 80 -j ACCEPT
sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 8080
sudo iptables -t nat -I OUTPUT -p tcp -d 127.0.0.1 --dport 80 -j REDIRECT --to-ports 8080
# open ports for VNC connections
sudo iptables -I INPUT 1 -p tcp --dport 5900:5920 -j ACCEPT
echo iptables-persistent iptables-persistent/autosave_v4 boolean true | sudo debconf-set-selections
echo iptables-persistent iptables-persistent/autosave_v6 boolean true | sudo debconf-set-selections
sudo apt install -yqq iptables-persistent
# sudo sh -c "iptables-save > /etc/iptables.rules"
# sudo DEBIAN_FRONTEND=noninteractive apt-get install -yqq iptables-persistent
# 
###################  Cleanup

# rm -rf /home/ubuntu/guacamole-server-1.0.0.tar.gz
# rm -rf /home/ubuntu/guacamole-server-1.0.0
# rm -rf /home/ubuntu/ideaIC-2017.1.4.tar.gz
