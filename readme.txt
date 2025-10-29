encryp pass: dievarga42
encryp pass: Paddington2
root pass: idkfaiddqd
root pass2: Paddington2
dievarga pass: idkfaiddqd
dievarga pass2: Paddington2


virtualbox:
	downl amd64 debian
	virtual folder = sgoinfre/dievarga/
	set virtual disk 10G 
	4gb ram - 4 processors
	controller IDE debian iso
	
partitioning:
	install WITHOUT GRAPHIC
	guided use entire disk and set up encryp lvm
	cancel deleting data
	separate home partition
	set to max
	finish partitioning and write
	uncheck everything
	grub to primary
	device for boot loader = harddisk
installing sudo 
	su -
	apt update
	apt install sudo
	adduser dievarga sudo 
	(verify: getent group sudo | sudo -V)
config sudo
	sudo visudo
		Defaults	passwd_tries=3
		Defaults	badpass_message="Password is wrong. Please try again."
		Defaults	logfile="/var/log/sudo/sudo.log"
		Defaults	log_input, log_output
		Defaults	iolog_dir="/var/log/sudo"
		Defaults	requiretty
	sudo mkdir -p /var/log/sudo
	sudo touch /var/log/sudo/sudo.log
	(verify
	sudo su - 
	cd /var/log/sudo
	cat sudo.log
config apparmor
	sudo nano /etc/default/grub
	GRUB_CMDLINE_LINUX="apparmor=1 security=apparmor"
	sudo update-grub
	sudo reboot
installing ssh
	sudo apt install openssh-server -y
	sudo nano /etc/ssh/sshd_config
		Port 4242
		PermitRootLogin no
	sudo nano /etc/ssh/ssh_config
		port 4242
	sudo service ssh restart
	(verify: sudo service ssh status
	which ssh)
installing ufw
	sudo apt install ufw -y
	sudo ufw enable
	sudo ufw allow 4242
	(verify
	sudo ufw status
	sudo service ufw status
	sudo ufw status numbered
	sudo ufw delete *numrule)
connecting through 4242. ssh connection inside the vm terminal
	network add rule 4242 4242 ports
	sudo systemctl restart ssh
	sudo service ssh restart
	ssh dievarga@127.0.0.1 -p 4242
	sudo ss -tulpn | grep 4242
connecting outside
	ssh root@localhost -p 4242
	ssh dievarga@localhost -p 4242
Set up passwd policy
	sudo nano /etc/login.defs
		max-days 30 min-days 2 pass-warn-age 7
	sudo apt-get install libpam-pwquality -y
	sudo nano /etc/security/pwquality.conf
		difok = 7
		minlen = 10
		ucredit = -1
		lcredit = -1
		dcredit = -1
		maxrepeat = 3
		reject_username
		enforcing = 1
	sudo nano /etc/pam.d/common-password
		passsword	requisite	pam_pwquality.so retry=3
	sudo reboot
	(verify accounts are created but locked without valid password
	sudo grep user /etc/shadow
	su newuser)
	* sudo userdel -r userx
Changing pwd
	passwd
	sudo chage -M 30 -m 2 -W 7 dievarga
	sudo chage -l dievarg
	sudo passwd root
	sudo chage -M 30 -m 2 -W 7 root
	sudo chage -l root
Creating users and groups
	(sudo adduser new_user
	getent passwd new_user)
	sudo addgroup user42
	sudo adduser dievarga user42
	getent group user42
	getent group sudo
	(verify: cat /etc/group)
Crontab config
	sudo touch /usr/local/bin/monitoring.sh
	sudo chmod 755 /usr/local/bin/monitoring.sh
	sudo nano /usr/local/bin/monitoring.sh
	sudo visudo
		dievarga ALL=(ALL) NOPASSWD:/usr/local/bin/monitoring.sh
	sudo systemctl enable cron.service
	sudo reboot
	sudo crontab -u root -e
		*/10 * * * * /usr/local/bin/monitoring.sh
Generate signature.txt
	clone machine or save state
	nav to vdi folder in host machine
	shasum Born2beRoot.vdi
	copy hash to signature.txt
Change hostname
	sudo nano /etc/hostname
	sudo nano /etc/hosts
	sudo reboot
	hostnamectl
