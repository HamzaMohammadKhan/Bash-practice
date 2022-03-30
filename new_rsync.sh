#!/bin/bash

echo "MIGRATION IS STARTING"

echo "Enter your credentials"

read -p "Do you want to do share from different sorce(y/n):" answer
if [[ "$answer" =~ ^( [yY][eE][nN]|[yY])$ ]]
then
	#Enter Source details
	read -p "Enter Hostname:" hostname
	read -p "Enter IP address:" ip
	read -p "Enter password:" passwd

	#ssh
	sshpass -p $passwd ssh $hostname@$ip 
else
	read -p "Enter path:" source
	read -p "Enter db name:" db_name
	read -p "Enter db user name:" db_username
	read -p "Enter db passwd:" db_passwd

	#Enter destination details
	read -p "Enter destination hostname:" destination_host
	read -p "Enter destination ip:" destination_ip
	read -p "Enter password:" destination_passwd
	read -p "Enter path:" destination_path
	read -p "Enter destination db name:" destination_db
	read -p "Enter destination db user name:" destination_db_username
	read -p "Enter destination db passwd:"destination_db_passwd
	read -p "Enter old domain:" old_domain
	read -p "Eneter new domain:" new_domain
fi

echo "Thanks for the details"

#Display all details

echo "*****************************************************"
echo "Show hostname:" $hostname
echo' '

echo "Show IP address:" $ip
echo' '

echo "Show database name of source:" $db_name
echo ' '

echo "Show database username of source:" $db_username
echo ' '

echo "Show source path:" $source
echo ' '

echo "Show destination host:" $destination_host
echo ' '

echo "Show destination ip:" $destination_ip
echo ' '

echo "Show destination db name:" $destination_db
echo ' '

echo "Show destination path:" $destination_path
echo ' '

echo "Show destination db username:" $destination_db_username
echo ' '

echo "The old domain:" $old_domain
echo ' '

echo "The new domain:" $new_domain
echo ' '
echo"******************************************************"

#export db
mysqldump $db_name -u root -p $db_passwd > hamzaMKhansql | mv hamzaMKhan.sql $source

#now try rsync 
sshpass	-p $destination_passwd rsync $source $destination_host@$destinatio_ip:$destination_path

#Save Old URL
#echo Old Url Saved
#wpHome=$( wp option get home )

#Updating DB_NAME, DB_USER and Password in wp-config.php
echo 'Updating DB Name, DB User, DB Password in wp-config.php'
sed -i "s/^.*('DB_NAME.*$/define('DB_NAME', '$dbDestination_db_name');/" wp-config.php
sed -i "s/^.*('DB_USER.*$/define('DB_USER', '$destination_db_user_name');/" wp-config.php
sed -i "s/^.*('DB_PASSWORD.*$/define('DB_PASSWORD', '$destination_db_passwd');/" wp-config.php

