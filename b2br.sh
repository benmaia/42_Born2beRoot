#!/bin/bash

$USER = $1

#If you want to learn more in depth every command and flag you can go to https://github.com/benmaia/42_Born2beRoot/tree/master/Born2beRoot

#Update and Upgrade the system
sudo apt update
sudo apt upgrade -y

#Add user to sudo group
sudo usermod -aG sudo $USER

#Create and add user to user42 group
sudo groupadd user42
sudo usermod -aG user42 $USER

#Change from port 22 to 4242
sudo sed -i 's/#Port22/Port 4242/' /etc/ssh/ssh_config 

#Install and acivate ufw
sudo apt install ufw
sudo ufw enable
sudo ufw allow 4242/tcp
sudo ssh -p 4242 $USER@10.0.2.15

#Doing the password policy
sudo apt install libpam-pwquality
sudo sed -i 's/PASS_MAX_DAYS 9999/PASS_MAX_DAYS 30/' /etc/ssh/ssh_config 
sudo sed -i 's/PASS_MIN_DAYS 0/PASS_MIN_DAYS 2/' /etc/ssh/ssh_config 
sudo sed -in '/retry=3/a udcredit=-1 lcredit=-1 dcredit=-1 minlen=10 maxrepeat=3 usercheck=0 difok=7 enforce_for_root' /etc/pam.d/common-password

#SUDO Policy
sudo sed -in '/Defaults secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"/a Defaults requiretty\n Defaults logfile="/var/log/sudo/sudo.log"\n Defaults log_input, log_output\n Defaults passwd_tries=3\n Defaults badpass_message="Take a chillpill and think things over"\n' /etc/sudoers
sudo apt update
mv /var/log/sudo-io/ /var/log/sudo

#Adding Script
sudo copy cp monitoring.sh /usr/local/bin
chmod 777 /usr/local/bin/monitoring.sh
sudo sed -in '/%sudo ALL=(ALL:ALL) ALL/a $USER ALL=(ALL) NOPASSWD: /usr/local/bin/monitoring.sh'

cron="*/10 * * * * /usr/local/bin/monitoring.sh\n@reboot sleep 10; sh /usr/local/bin/monitoring.sh"
(crontab -u $(whoami) -l; echo "$cron") | crontab -u $(whoami) -
