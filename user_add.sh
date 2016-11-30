#!/bin/bash

## Function Defination for creating the body of the mail

send_mail()
{
# creating the mail.txt file to be attched to the mail while sending
# the keyfiles ,username and user password to the users mail-id
/bin/rm -rf /root/mail.txt
/bin/echo "Hello ," >> /root/mail.txt
/bin/echo " " >> /root/mail.txt
/bin/echo " " >> /root/mail.txt
/bin/echo " You are allowed to access the server: $host using below mentioned details " >> /root/mail.txt
/bin/echo " " >> /root/mail.txt
/bin/echo " hostname:  $host" >> /root/mail.txt
/bin/echo " Username:  $user" >> /root/mail.txt
/bin/echo " Password:  $pass" >> /root/mail.txt
/bin/echo " " >> /root/mail.txt
/bin/echo " " >> /root/mail.txt
/bin/echo "Thanks," >> /root/mail.txt
/bin/echo "Server Team" >> /root/mail.txt
}


### Program to create the user and generate its key ###
# Getting the input for username
read -p "Enter the username :-" user
while [ "$user" == "" ]
do
/bin/echo "User name not entered"
read -p "Enter the username :" user
done

#Getting the input for password of a username
read -p "Enetr the password :-" pass
while [ "$pass" == "" ]
do
/bin/echo "Password not entered for user $user"
read -p "Enter the Password :" pass
done

#Getting the input of email id
read -p "Enter the email Id :-" email
while [ "$email" == "" ]
do
/bin/echo "Email Id not entered for user $user"
read -p "Enter the Email Id :" email
done

## Retrieving the hostname of the machine in a variable host
host=$(/bin/hostname)

## Adding the useraccount with home /apps/user/username
 /usr/sbin/adduser -d /apps/user/$user $user

## Providing the password for the user
 /bin/echo $pass |passwd --stdin "$user" >> /root/output.txt

# creatind firectory .ssh and authorized_key file
 /bin/mkdir /apps/user/$user/.ssh
 /bin/touch /apps/user/$user/.ssh/authorized_keys

##Genearting the keygen for the user
/usr/bin/ssh-keygen -t dsa -b 1024 -N "$pass" -f /apps/user/$user/$user >> /root/output.txt

##Adding the keys to the authorized files
/bin/cat /apps/user/$user/$user.pub >> /apps/user/$user/.ssh/authorized_keys


##Calling  the  sendmail_mail function
send_mail $user $pass $host

##Sending the mail to the user account
/usr/bin/mutt -s "your_private_key and your_passwd" -a /apps/user/$user/$user $email < /root/mail.txt

#changing the permission of .ssh and authorized_keys file
 /bin/chmod 700 /apps/user/$user/.ssh
 /bin/chown $user:$user /apps/user/$user/.ssh/
 /bin/chown $user:$user /apps/user/$user/.ssh/authorized_keys

##Deleting the key files after appending the authorized_keys file
 /bin/rm -f /apps/user/$user/$user*
 /bin/rm -f /root/output.txt
 /bin/rm -f /root/mail.txt
/bin/echo ""
/bin/echo "User Created : $user"
/bin/echo "Key file Send to: $email"
