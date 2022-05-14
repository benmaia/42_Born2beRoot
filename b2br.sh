#!/bin/bash

$USER = $1

#If you want to learn more in depth every command and flag you can go to https://github.com/benmaia/42_Born2beRoot/tree/master/Born2beRoot

#Update and Upgrade the system
sudo apt update
sudo apt upgrade -y
sudo apt install --reinstall ca-certificates

#Add user to sudo group
sudo usermod -aG sudo $USER

#Create and add user to user42 group
sudo groupadd user42
sudo usermod -aG user42 $USER

#Change from port 22 to 4242
sudo sed -i 's/#Port 22/Port 4242/' /etc/ssh/sshd_config 

#Install and acivate ufw
sudo apt install ufw
sudo ufw enable
sudo ufw allow 4242/tcp
sudo ssh -p 4242 $USER@10.0.2.15

#Doing the password policy
sudo apt install libpam-pwquality
sudo sed -i 's/PASS_MAX_DAYS\t99999/PASS_MAX_DAYS\t30/' /etc/login.defs
sudo sed -i 's/PASS_MIN_DAYS\t0/PASS_MIN_DAYS\t2/' /etc/login.defs 
sudo sed -in 's/password	requisite			pam_pwquality.so retry=3/password	requisite			pam_pwquality.so retry=3 ucredit=-1 lcredit=-1 dcredit=-1 minlen=10 maxrepeat=3 usercheck=0 difok=7 enforce_for_root' /etc/pam.d/common-password

#SUDO Policy
sudo echo 'Defaults	requiretty' | sudo EDITOR='tee -a' visudo
sudo echo 'Defaults	logfile="/var/log/sudo/sudo.log"' | sudo EDITOR='tee -a' visudo
sudo echo 'Defaults	log_input, log_output' | sudo EDITOR='tee -a' visudo
sudo echo 'Defaults	passwd_tries=3' | sudo EDITOR='tee -a' visudo
sudo echo 'Defaults	badpass_message="Take a chill pill and think things over"' | sudo EDITOR='tee -a' visudo

#sudo sed -in '/Defaults secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"/a Defaults requiretty\n Defaults logfile="/var/log/sudo/sudo.log"\n Defaults log_input, log_output\n Defaults passwd_tries=3\n Defaults badpass_message="Take a chillpill and think things over"\n' /etc/sudoers
sudo apt update
mv /var/log/sudo-io/ /var/log/sudo

#Adding Script
sudo cp monitoring.sh /usr/local/bin
sudo chmod 777 /usr/local/bin/monitoring.sh
sudo echo "$USER ALL=(ALL) NOPASSWD: /usr/local/bin/monitoring.sh" | sudo EDITOR='tee -a' visudo
#sudo sed -in '/%sudo ALL=(ALL:ALL) ALL/a $USER ALL=(ALL) NOPASSWD: /usr/local/bin/monitoring.sh'

cron="*/10 * * * * /usr/local/bin/monitoring.sh\n@reboot sleep 10; sh /usr/local/bin/monitoring.sh"
(crontab -u $(whoami) -l; echo "$cron") | crontab -u $(whoami) -
