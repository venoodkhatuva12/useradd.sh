#!/bin/bash
#Author: Vinod.N K
#Distro : Linux -Centos, Rhel, and any fedora
read -p "Please Enter the Username : " user
useradd $user
passwd $user
su $user
ssh-keygen -t rsa -f $user
mkdir .ssh
cat $user.pub > .ssh/authorized_keys
chmod -R 700 .ssh/
chown -R $user:$user .ssh/
mv $user $user.pem
pkill -KILL -u $user
read -p "Do you want to add this User to Sudoer(Yes/No)? : " response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]
then
   sudo sed -i "95 i $user   ALL=(ALL)       ALL" /etc/sudoers
else
    exit
fi
