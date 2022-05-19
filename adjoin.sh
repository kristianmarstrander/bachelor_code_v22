!#/bin/bash

apt update -y && apt upgrade -y
sudo hostnamectl set-hostname $1.mysil.local
rm /etc/resolv.conf
echo "nameserver 192.168.0.203" >> /etc/resolv.conf
chattr +i /etc/resolv.conf
apt -y install realmd libnss-sss libpam-sss sssd sssd-tools adcli samba-common-bin oddjob oddjob-mkhomedir packagekit
realm discover mysil.local
echo 'Cisco123!' | realm join -U orchestrator mysil.local
sudo bash -c "cat > /usr/share/pam-configs/mkhomedir" <<EOF
Name: activate mkhomedir
Default: yes
Priority: 900
Session-Type: Additional
Session:
        required                        pam_mkhomedir.so umask=0022 skel=/etc/skel
EOF
pam-auth-update --enable mkhomedir
wget http://10.212.138.47/code/sssd.conf -O /etc/sssd/sssd.conf
systemctl restart sssd
wget http://10.212.138.47/code/sshd_config -O /etc/ssh/sshd_config
systemctl restart sshd
realm permit --all
echo '%domain\ admins ALL=(ALL:ALL) ALL' | EDITOR='tee -a' visudo
echo '%linuxAdmins ALL=(ALL:ALL) ALL' | EDITOR='tee -a' visudo
