#!/bin/bash
#trap '' SIGINT 
#trap '' SIGTSTP
echo "************ install and configure *************";

#install nginx
sudo apt-get update
read -r -p "Do you want to install nginx? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
    sudo apt install nginx -y
    #configure nginx files
    sudo sed -i '12i upstream backend{\n server 127.0.0.1:8080 fail_timeout=5s weight=5; \n server 127.0.0.1:8081 backup; \n #upstream \n}' /etc/nginx/nginx.conf
    sudo sed -i '50i proxy_pass http://backend;\n proxy_set_header Host $host; \nproxy_set_header X-Real-IP $remote_addr;\n proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;\n proxy_set_header X-Forwarded-Proto $scheme;' /etc/nginx/sites-available/default
    sudo sed -i '59i location ~ \.php$ \n { \nfastcgi_pass unix:/var/run/php/php7.4-fpm.sock;\ninclude fastcgi_params;\nfastcgi_index index.php;\nfastcgi_param  SCRIPT_FILENAME $document_root$fastcgi_script_name;}' /etc/nginx/sites-available/default
    sudo sed -i '46i  server_name  hamzamkhan.com;' /etc/nginx/sites-available/default
    sudo systemctl enable nginx
    sudo systemctl restart nginx
else
    #sudo ufw app list
    nginx -v
fi
#also to check nginx
sudo systemctl status nginx

#configure nginx files
#install  varnish
read -r -p "Do you want to install varnish? [y/N] " response_varnish
if [[ "$response_varnish" =~ ^([yY][eE][sS]|[yY])$ ]]
then
    sudo apt install varnish -y
    #configure varnish port in dfiferent files
    sudo sed -i "s/6081/8080/g" /lib/systemd/system/varnish.service
    sudo sed -i "s/8080/8081/g" /etc/varnish/default.vcl
sudo sed -i '39i if (obj.hits > 0)\n {\n set resp.http.X-Varnish-Cache = "HIT"; \n} \nelse\n {\nset resp.http.X-Varnish-Cache = "MISS";\n}' /etc/varnish/default.vcl    
sudo systemctl enable varnish.service
    sudo systemctl restart varnish.service
else
    #sudo ufw app list
    varnishd -v
fi
#enable varnish
sudo systemctl status varnish.service

#install apache
read -r -p "Do you want to install apache2? [y/N] " response_apache
if [[ "$response_apache" =~ ^([yY][eE][sS]|[yY])$ ]]
#read -p "wheat server name you want to give" servername
#read -p "what server alias you want to give" serveralias
then
   sudo apt install apache2 -y
   #configure apache port
   sudo sed -i "s/80/8081/g"  /etc/apache2/ports.conf
   sudo sed -i  "s/80/8081/g" /etc/apache2/sites-available/000-default.conf
   sudo sed -i "10i ServerName hamzamkhan.com" /etc/apache2/sites-available/000-default.conf
   sudo sed -i "11i ServerAlias hamzamkhan.com" /etc/apache2/sites-available/000-default.conf 
   sudo sed -i "24i  <FilesMatch \.php$>\n # 2.4.10+ can proxy to unix socket \nSetHandler 'proxy:unix:/var/run/php/php7.4-fpm.sock|fcgi://localhost'\n </FilesMatch>" /etc/apache2/sites-available/000-default.conf	
   sudo systemctl enable apache2.service
   sudo systemctl restart apache2.service       
else
#To enable PHP 8.1 FPM in Apache2 do:
#NOTICE:
#a2enmod proxy_fcgi setenvif
#NOTICE: 
#a2enconf php7.4-fpm

    apache2 -v
fi

#for checking 
sudo systemctl status apache2.service

#install net tools
read -r -p "Do you want to install net-tools [y/N]" reponse_netTools
if [[ "$response_netTools" =~ ^([yY][eE][sS]|[yY])$ ]]
then
        sudo apt-get install net-tools
else
       netstat -V       
fi

#update and install php and maridb
sudo apt-get update -y

read -r -p "Do you want to install php [y/N]" response_php
if [[ "$response_php" =~ ^([yY][eE][sS]|[yY])$ ]]
then
        sudo apt install software-properties-common && sudo add-apt-repository ppa:ondrej/php -y
        sudo apt install php7.4-fpm libapache2-mod-fcgid php7.4-mysql php7.4-curl
        sudo systemctl enable php7.4-fpm
        sudo systemctl restart php7.4-fpm 
	#sudo apt install php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip
	sudo a2enmod proxy_fcgi setenvif
	sudo a2enconf php7.4-fpm
else
	sudo systemctl status php7.4-fpm
fi


read -r -p "Do you want to install database [y/N]" response_db
if [[ "$response_db" =~ ^([yY][eE][sS]|[yY])$ ]]  
then
        sudo apt-get install mariadb-server && sudo apt-get install mariadb-client -y
else
        mysql -V
        #mariadb configure
        sudo systemctl enable mariadb
        sudo systemctl status mariadb
        #sudo mysql_secure_installation
fi

#install wordpress tar
sudo curl -O https://wordpress.org/latest.tar.gz

#extract wp
sudo tar -xzvf latest.tar.gz

#enter wp folder
cd wordpress

#copy all to new folder
#sudo cp -r * /var/www/hamza/ #sending to the desired directory
sudo cp -r * /var/www/html/ #send it to desired directory

#wp-cli install
sudo curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
sudo chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp   #wp-cli. need it

#check wp-cli
wp --info

#change ownership of folder
sudo chown -R www-data:www-data /var/www/html

#make a new directory
#sudo mkdir /var/www/hamza

#Giving database variables for wordpress
read -p "Enter wp password :  " wp_pass
read -p "enter wp_user : " wp_user
read -p "Enter wp_db : " wp_db

#mysql secure
#sudo mysql_secure_installation

#database 
sudo mysql -e "create database $wp_db;"
sudo mysql -e "create user '$wp_user'@'localhost' identified by '$wp_pass';"
sudo mysql -e "grant all privileges on $wp_db.* to '$wp_user'@'localhost';"
sudo mysql -e "flush privileges;"


#enter hamza folder
echo "Enter wp folder"
cd /var/www/html/

#sudo apt-get --assume-yes install php-curl
#sed -i "76i \ndefine('FS_METHOD','direct');\n" /var/www/html/wp-config.php

#now edit/create config
sudo wp config create --dbname=$wp_db --dbuser=$wp_user --dbpass=$wp_pass --dbhost='localhost' --allow-root

#db create
sudo wp db create --allow-root
#wp core install for not showing wp installation page
sudo wp core install --url='hamzamkhan.com' --title='wordpress' --admin_user='hala' --admin_password='admin' --admin_email='hala.masoodcloudways.com' --allow-root

#Plugin breeze
#Don't activate it for now
sudo wp plugin install breeze --activate --allow-root

#change permissions
sudo chmod 777 /var/www/html/wp-content/advanced-cache.php #originial permission 644
sudo chmod 777 /var/www/html/wp-content/breeze-config/
sudo chmod 777 /var/www/html/wp-content/breeze-config.php

#restart all
sudo systemctl restart apache2.service nginx.service varnish.service php7.4-fpm

