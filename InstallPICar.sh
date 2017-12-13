#!/bin/bash
#Don't forget to : chmod +x InstallPICar.sh
# and run !
sudo apt-get -y update
sudo apt-get -y upgrade
#https://frillip.com/using-your-raspberry-pi-3-as-a-wifi-access-point-with-hostapd/
#http://www.dericbourg.net/2015/07/04/utiliser-un-raspberry-pi-comme-point-dacces-wifi/
#https://www.raspberrypi.org/forums/viewtopic.php?f=66&t=145942
#https://raspberrypi.stackexchange.com/questions/8851/setting-up-wifi-and-ethernet
sudo apt-get -y install dnsmasq hostapd
sudo sed -i '$ a denyinterfaces wlan0' /etc/dhcpcd.conf
sudo bash -c "printf 'allow-hotplug wlan0\niface wlan0 inet static\n    address 192.168.11.1\n    netmask 255.255.255.0\n    network 192.168.11.0\n    broadcast 192.168.11.255\n#    wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf\n'>/etc/network/interfaces.d/wlan0"
sudo service dhcpcd restart
sudo ifdown wlan0; sudo ifup wlan0
sudo bash -c "printf '# This is the name of the WiFi interface we configured above\ninterface=wlan0\n\n# Use the nl80211 driver with the brcmfmac driver\ndriver=nl80211\n\n# This is the name of the network\nssid=Pi3-AP\n\n# Use the 2.4GHz band\nhw_mode=g\n\n# Use channel 6\nchannel=6\n\n# Enable 802.11n\nieee80211n=1\n\n# Enable WMM\nwmm_enabled=1\n\n# Enable 40MHz channels with 20ns guard interval\nht_capab=[HT40][SHORT-GI-20][DSSS_CCK-40]\n\n# Accept all MAC addresses\nmacaddr_acl=0\n\n# Use WPA authentication\nauth_algs=1\n\n# Require clients to know the network name\nignore_broadcast_ssid=0\n\n# Use WPA2\nwpa=2\n\n# Use a pre-shared key\nwpa_key_mgmt=WPA-PSK\n\n# The network passphrase\nwpa_passphrase=raspberry\n\n# Use AES, instead of TKIP\nrsn_pairwise=CCMP\n'>/etc/hostapd/hostapd.conf"
sudo sed -i -e 's/^#DAEMON_CONF=""/DAEMON_CONF="\/etc\/hostapd\/hostapd.conf"/g' /etc/default/hostapd
sudo mv /etc/dnsmasq.conf /etc/dnsmasq.conf.orig
sudo bash -c "printf 'interface=wlan0      # Use interface wlan0  \nlisten-address=192.168.11.1 # Explicitly specify the address to listen on  \nbind-interfaces      # Bind to the interface to make sure we aren t sending things elsewhere  \nserver=8.8.8.8       # Forward DNS requests to Google DNS  \ndomain-needed        # Don t forward short names  \nbogus-priv           # Never forward addresses in the non-routed address spaces.  \ndhcp-range=192.168.11.50,192.168.11.150,12h # Assign IP addresses between 192.168.11.50 and 192.168.11.150 with a 12 hour lease time\n'>/etc/dnsmasq.conf"
sudo sed -i -e 's/^#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"
sudo iptables -t nat -A POSTROUTING -o wlan1 -j MASQUERADE
sudo iptables -A FORWARD -i wlan1 -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i wlan0 -o wlan1 -j ACCEPT
sudo sh -c "iptables-save > /etc/iptables.ipv4.nat"
sudo sed -i -e 's/^exit 0/iptables-restore < \/etc\/iptables.ipv4.nat\nexit 0/g' /etc/rc.local
sudo service hostapd start
sudo service dnsmasq start
#https://www.erol.name/use-two-wireless-network-interfaces-raspberry-pi-3/
#https://lists.debian.org/debian-user/2017/07/msg01453.html
sudo bash -c "printf 'r8712u\nbrcmfmac\nbrcmutil'>>/etc/modules"
sudo touch /etc/udev/rules.d/76-netnames.rules
sudo bash -c "printf '# identify device by MAC address\nSUBSYSTEM==\"net\", ACTION==\"add\", ATTR{address}==\"b8:27:eb:64:6e:38\", NAME=\"wlan0\"\nSUBSYSTEM==\"net\", ACTION==\"add\", ATTR{address}==\"d8:eb:97:28:64:d4\", NAME=\"wlan1\"\n'>>/etc/udev/rules.d/76-netnames.rules"
#END OF PART 1, REBOOTING...
sudo reboot


