#!/bin/bash
#Don't forget to : chmod +x InstallPICarPart2.sh
#test for Internet connexion...
# and run !
#
#Install Samba
#
sudo apt-get -y install libcups2 samba samba-common cups
sudo mv /etc/samba/smb.conf /etc/samba/smb.conf.bak
sudo touch /etc/samba/smb.conf
sudo bash -c "printf '[global]\n   workgroup = WORKGROUP\n   dns proxy = no\n   log file = /var/log/samba/log.%%m\n   max log size = 1000\n   syslog = 0\n   panic action = /usr/share/samba/panic-action %%d\n   server role = standalone server\n   passdb backend = tdbsam\n   obey pam restrictions = yes\n   unix password sync = yes\n   passwd program = /usr/bin/passwd %%u\n   passwd chat = *Enter\\snew\\s*\\spassword:* %%n *Retype\\snew\\s*\\spassword:* %%n *password\\supdated\\ssuccessfully* .\n   pam password change = yes\n   map to guest = bad user\n   usershare allow guests = yes\n'>/etc/samba/smb.conf"
sudo systemctl restart smbd.service
#Install automount & share USB from github https://github.com/Athanasus/automount-usb.git
sudo git clone https://github.com/Athanasus/automount-usb.git
sudo /bin/bash /home/pi/PiCar/automount-usb/CONFIGURE.sh
