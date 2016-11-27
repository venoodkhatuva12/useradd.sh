#!/bin/bash
#Script made for adding User and making pemfile
#Author: Vinod.N K
#Usage: useradd pemfile
#Distro : Linux -Centos, Rhel, and any fedora

#Check whether root user is running the script
  if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
  fi
  
read -p "Please Enter the Username : " user
user_present="`cat /etc/passwd | grep $user | grep -v grep | wc -l`"
  if [ "$user_present" == "1" ]; then
       	echo -e "\nUser $user already present No need to create .. "
       	echo -e "\nGenertaing keys for $user ... "
  else
       	adduser $user
  fi
passwd $user
chown $user:$user /home/$user

read -p "Please Enter the Hostname : " hostname
ssh-keygen -b 2048 -f $user -t rsa -v

mkdir /home/$user/.ssh
chmod -R 700 /home/$user/.ssh/
cat $user.pub >> /home/$user/.ssh/authorized_keys
chmod -R 600 /home/$user/.ssh/authorized_keys
chown -R $user:$user /home/$user/.ssh/
mv $user /tmp/$hostname-$user.pem
chmod -R 755 /tmp/$hostname-$user.pem
read -p "Do you want to add this User to Sudoer(Yes/No)? : " response
sudoers_present="`cat /etc/sudoers | grep $user | grep -v grep | wc -l`"
  if [ "$sudoers_present" -ge "1" ]; then
       	echo -e "\nEntry for user in sudoers already exsist !!"
  else
       	if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]
       	then
       	   sudo sed -i "95 i $user   ALL=(ALL)       ALL" /etc/sudoers
       	else
       	    exit
       	fi
  fi
rm -f $user $user.pub
echo -e "\n Keys generated successfully ...\n"
echo -e "\n Please find pem for user $user at  /tmp/$hostname-$user.pem"
echo -e "\n Please Change teh persmission of pemfile when you copy to ur machine... Change it to 600 !"
