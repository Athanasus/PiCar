#!/bin/bash
#Don't forget to : chmod +x InstallPICarPart2.sh
#test for Internet connexion...
# and run !
#
#Install RaspAP Athanasus version
#
sudo apt-get install lighttpd php7.0-cgi
sudo lighttpd-enable-mod fastcgi-php
sudo service lighttpd restart
sudo bash -c "printf 'www-data ALL=(ALL) NOPASSWD:/sbin/ifdown wlan0\nwww-data ALL=(ALL) NOPASSWD:/sbin/ifup wlan0\nwww-data ALL=(ALL) NOPASSWD:/sbin/ifdown wlan1\nwww-data ALL=(ALL) NOPASSWD:/sbin/ifup wlan1\nwww-data ALL=(ALL) NOPASSWD:/bin/cat /etc/wpa_supplicant/wpa_supplicant.conf\nwww-data ALL=(ALL) NOPASSWD:/bin/cp /tmp/wifidata /etc/wpa_supplicant/wpa_supplicant.conf\nwww-data ALL=(ALL) NOPASSWD:/sbin/wpa_cli scan_results\nwww-data ALL=(ALL) NOPASSWD:/sbin/wpa_cli scan\nwww-data ALL=(ALL) NOPASSWD:/sbin/wpa_cli reconfigure\nwww-data ALL=(ALL) NOPASSWD:/bin/cp /tmp/hostapddata /etc/hostapd/hostapd.conf\nwww-data ALL=(ALL) NOPASSWD:/etc/init.d/hostapd start\nwww-data ALL=(ALL) NOPASSWD:/etc/init.d/hostapd stop\nwww-data ALL=(ALL) NOPASSWD:/etc/init.d/dnsmasq start\nwww-data ALL=(ALL) NOPASSWD:/etc/init.d/dnsmasq stop\nwww-data ALL=(ALL) NOPASSWD:/bin/cp /tmp/dhcpddata /etc/dnsmasq.conf\nwww-data ALL=(ALL) NOPASSWD:/sbin/shutdown -h now\nwww-data ALL=(ALL) NOPASSWD:/sbin/reboot\nwww-data ALL=(ALL) NOPASSWD:/sbin/ip link set wlan0 down\nwww-data ALL=(ALL) NOPASSWD:/sbin/ip link set wlan0 up\nwww-data ALL=(ALL) NOPASSWD:/sbin/ip -s a f label wlan0\nwww-data ALL=(ALL) NOPASSWD:/sbin/ip link set wlan1 down\nwww-data ALL=(ALL) NOPASSWD:/sbin/ip link set wlan1 up\nwww-data ALL=(ALL) NOPASSWD:/sbin/ip -s a f label wlan1\nwww-data ALL=(ALL) NOPASSWD:/bin/cp /etc/raspap/networking/dhcpcd.conf /etc/dhcpcd.conf\nwww-data ALL=(ALL) NOPASSWD:/etc/raspap/hostapd/enablelog.sh\nwww-data ALL=(ALL) NOPASSWD:/etc/raspap/hostapd/disablelog.sh'>>/etc/sudoers"
sudo rm -rf /var/www/html
sudo rm -rf /var/www/html/raspap
sudo git clone https://github.com/Athanasus/raspap-webgui.git /var/www/html/raspap
sudo chown -R www-data:www-data /var/www/html
sudo mkdir /etc/raspap
sudo mv /var/www/html/raspap/raspap.php /etc/raspap/
sudo chown -R www-data:www-data /etc/raspap
sudo mkdir /etc/raspap/hostapd
sudo mv /var/www/html/raspap/installers/*log.sh /etc/raspap/hostapd
sudo reboot
