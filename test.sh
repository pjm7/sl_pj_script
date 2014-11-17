#!/bin/bash

# Disable tunnelled clear text passwords
# sed -i.org -e "s/PasswordAuthentication yes/PasswordAuthentication no/g" /etc/# ssh/sshd_config
# service sshd restart

# Change to Japanese locale
yum -y groupinstall "Japanese Support" 
sed -i.org -e "s/en_US.UTF-8/ja_JP.UTF-8/g" /etc/sysconfig/i18n

# Change to JST time zone
rm -f /etc/localtime
ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# Configure Linux Firewall
# --- CAUTION --- Change to deny access from public address
iptables -A INPUT -s 10.0.0.0/8 -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p icmp -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT
#iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -s 0.0.0.0/0 -d 0.0.0.0/0 -p all -j REJECT
service iptables save

# mount objectstorage
cloudfuse /mnt/wwwcontent

#copy current contents
\cp -rf /mnt/wwwcontent/m-SJC-container01/www/* /var/www/html/

# starting httpd
service httpd start

# auto start httpd
chkconfig httpd on