#!/bin/bash

$USER = $(whoami)

#If you want to learn more in depth every command and flag you can go to https://github.com/benmaia/42_Born2beRoot/tree/master/Born2beRoot

#Update and Upgrade the system
sudo apt update
sudo apt upgrade -y
sudo apt install openssh-server -y

#Add user to sudo group
sudo usermod -aG sudo $USER

#Create and add user to user42 group
sudo groupadd user42
sudo usermod -aG user42 $USER

#Change from port 22 to 4242
sudo sed -i 's/#Port 22/Port 4242/' /etc/ssh/sshd_config 

#Install and acivate ufw
sudo apt install ufw -y
sudo ufw enable
sudo ufw allow 4242/tcp

#Doing the password policy
sudo apt install libpam-pwquality -y
sudo sed -i 's/PASS_MAX_DAYS\t99999/PASS_MAX_DAYS\t30/' /etc/login.defs
sudo sed -i 's/PASS_MIN_DAYS\t0/PASS_MIN_DAYS\t2/' /etc/login.defs 
sudo chmod 777 /etc/pam.d/common-password
sudo echo 'password	requisite			pam_pwquality.so retry=3 ucredit=-1 lcredit=-1 dcredit=-1 minlen=10 maxrepeat=3 usercheck=0 difok=7 enforce_for_root' >> /etc/pam.d/common-password

#SUDO Policy
sudo mkdir -p /var/log/sudo
sudo echo 'Defaults	requiretty' | sudo EDITOR='tee -a' visudo
sudo echo 'Defaults	logfile="/var/log/sudo/sudo.log"' | sudo EDITOR='tee -a' visudo
sudo echo 'Defaults	log_input, log_output' | sudo EDITOR='tee -a' visudo
sudo echo 'Defaults	passwd_tries=3' | sudo EDITOR='tee -a' visudo
sudo echo 'Defaults	badpass_message="Take a chill pill and think things over"' | sudo EDITOR='tee -a' visudo


#Adding Script
sudo cp monitoring.sh /usr/local/bin
sudo chmod 777 /usr/local/bin/monitoring.sh
sudo echo "$USER ALL=(ALL) NOPASSWD: /usr/local/bin/monitoring.sh" | sudo EDITOR='tee -a' visudo

cron="*/10 * * * * /usr/local/bin/monitoring.sh\n@reboot sleep 30; sh /usr/local/bin/monitoring.sh"
(crontab -u $(whoami) -l; echo "$cron") | crontab -u $(whoami) -

#Reset PC to update 4242 Port after run $(whoami)@10.0.2.15
sudo reboot
