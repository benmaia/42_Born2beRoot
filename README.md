# 42_Born2beRoot
This is a script that init a VM, install a debian server and sets a sudo and pw policy, and run a script with the system info. 42 project Born2beRoot.

**CHECK THE PROJECT GUIDE <a href="https://github.com/benmaia/42_Born2beRoot_Guide" target="_blank">HERE</a>!**

<h2> Index </h2>
<p><a href="#In">
  Instructions
</a></p>
<p><a href="#Tu">
  Video Tutorial
</a></p>

<h2 id="In">Instructions</h2>

To start **DOWNLOAD THE DEBIAN.ISO THROUGH <a href="https://mega.nz/file/sB4ViYSB#piht6sky5mM2dz25Svlcf9Ipj3BGgAUqNkp6OgIaAOg" target="_blank">HERE</a>** and put it on Desktop or change the path of the iso in the vm.sh, the iso file is modified to engage auto instalation and auto lvm partition.

Clone this repo to your desktop, or update your path in vm.sh.
```bash
git -C ~/Desktop clone https://github.com/benmaia/42_Born2beRoot.git
```
Go inside the dir and execute the vm.sh with the name you want to give to your VM. 

Depending of your sgoinfre/user dir on your 42 you mave have to change path of your sgoinfre/user in line 7, 15 and 17 of vm.sh!
```bash
cd ~/Desktop/42_Born2beRoot && ./vm.sh Born2beRoot
```


The installation is fully automatic, besides your hostname, user and password.
For the hostname you put your login + 42 (ex: bmiguel + 42 = bmiguel42).
For the user you have to put yout login (ex: bmiguel).
For the user password, and for the encrypted password choose, one that you won't forget!

When you get inside your user, you will have to run this commands:

```bash
sudo apt install --reinstall ca-certificates -y
```

```bash
sudo apt install git -y
```

```bash
git clone https://github.com/benmaia/42_Born2beRoot.git
```

After that go inside the folder and run the script b2br.sh


```bash
cd 42_Born2beRoot && ./b2br.sh
```

The script will install openssh-server and ufw, and will add a password policy, a sudo policy, put a script to scan the system and set the crontab to play the script every 10 mins.
The script will reset the computer to change the ports from 22 to 4242.
After that insert the remote connection id to the port 4242 with sudo ssh -p 4242 your.user@10.0.2.15.
```bash
sudo ssh -p 4242 bmiguel@10.0.2.15
```
Once done, insert this in the terminal of your local host:
```bash
ssh -p 4242 bmiguel@127.0.0.1
```
After that you ready for evaluation, just need to take the signature of the VDI to a signature.txt.

To check how to do the signature check <a href="https://github.com/benmaia/42_B2bR/tree/master/Born2beRoot#Signature" target="_blank">here</a>.

To learn more in deep the theory behind the project check my guide <a href="https://github.com/benmaia/42_B2bR/tree/master/Born2beRoot#Set%20the%20basic%20up" target="_blank">here</a>.

For the evaluation you will need to change the crontab from 10mins to 1, and it's a bit different from the guide, you will have to:
```bash
crontab -r
```
That will delete the current 10min crontab you have, and to add the new one, just go to the line 48 in b2br.sh and replace the 10 for 1, and run the
b2br.sh script again.

To study to evaluation see my evaluation guide <a href="https://github.com/benmaia/42_B2bR/tree/master/Evaluation#Evaluation" target="_blank">here</a>.

<h2 id="Tu">Video Tutorial</h2>

### VM + Debian instalation
<img src="https://cdn.discordapp.com/attachments/461563270411714561/975159407904178236/vm.gif" width="1000" height="450">

### Born2beRoot Script
<img src="https://cdn.discordapp.com/attachments/461563270411714561/975162991022604318/b2br.gif" width="1000" height="600">

