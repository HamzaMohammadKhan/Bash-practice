#!/bin/bash

sudo touch /home/$USER/filesmenu.log
logpath="/home/ubuntu//home/hamza/Documents/files.log"
sudo chmod +x /home/$USER/Documents/filesmenu.log
sudo chown hamza:hamza /home/$USER/Documents/filesmenu.log
now=$(date)

echo "=======================WELCOME======================="


echo 'What do you want to install :'
ins=("Nginx" "Apache" "Varnish" "php8.1-fpm" "mariadb" "Wordpress" "Non")
select inst in "${ins[@]}"; do
    case $inst in
     "Nginx")
            echo "$(date)==========Installing Nginx=============" >> /home/hamza/Documents/filesmenu.log
             sudo apt-get install nginx -y >> /home/hamza/Documents/filesmenu.log
            read -p "Server Name : " servername >> /home/hamza/Documents/filesmenu.log
            sudo sed -i '12i upstream backend{\n server 127.0.0.1:8080 fail_timeout=5s weight=5; \n server 127.0.0.1:8081 backup; \n #upstream \n}' /etc/nginx/nginx.conf >> /home/hamza/Documents/filesmenu.log
  	    sudo sed -i '50i proxy_pass http://backend;\n proxy_set_header Host $host; \nproxy_set_header X-Real-IP $remote_addr;\n proxy_set_header X-Forwarded-For 	$proxy_add_x_forwarded_for;\n proxy_set_header X-Forwarded-Proto $scheme;' /etc/nginx/sites-available/default >> /home/hamza/Documents/filesmenu.log
            sudo sed -i '59i location ~ \.php$ \n { \nfastcgi_pass unix:/var/run/php/php7.4-fpm.sock;\ninclude fastcgi_params;\nfastcgi_index index.php;\nfastcgi_param  SCRIPT_FILENAME $document_root$fastcgi_script_name;}' /etc/nginx/sites-available/default >> /home/hamza/Documents/filesmenu.log
    	    sudo sed -i '46i  server_name  "$servername";' /etc/nginx/sites-available/default >> /home/hamza/Documents/filesmenu.log
           	
           	sudo systemctl enable nginx
    		sudo systemctl restart nginx
		sudo systemctl status nginx
	
    		nginx -v
    		#sudo ufw app list
    		sudo ufw allow 'Nginx HTTP'
            ;;
        "Apache")
		sudo apt-get update && upgrade
            	echo "===========Installing Apache============" >> /home/hamza/Documents/files.log
            	sudo apt-get install apache2 -y
            	read -p "Server name: " servernameapache
             	sudo sed -i "s/80/8081/g"  /etc/apache2/ports.conf
   		sudo sed -i  "s/80/8081/g" /etc/apache2/sites-available/000-default.conf
   		sudo sed -i "10i ServerName $servernameapache" /etc/apache2/sites-available/000-default.conf
   		sudo sed -i "11i ServerAlias www.$servernameapache" /etc/apache2/sites-available/000-default.conf 
   		sudo sed -i "24i  <FilesMatch \.php$>\n # 2.4.10+ can proxy to unix socket \nSetHandler 'proxy:unix:/var/run/php/php7.4-fpm.sock|fcgi://localhost'\n 			</FilesMatch>" /etc/apache2/sites-available/000-default.conf	
   		sudo systemctl enable apache2.service
   		sudo systemctl restart apache2.service       
   		#sudo ufw allow 'Apache'
            ;;
        "Varnish")
           	 echo "========Installing Varnish==============" >> /home/hamza/Documents/files.log
            	sudo apt-get install varnish -y
	     	sudo apt install varnish -y
    		#configure varnish port in dfiferent files
    		sudo sed -i "s/6081/8080/g" /lib/systemd/system/varnish.service
    		sudo sed -i "s/8080/8081/g" /etc/varnish/default.vcl
    		sudo sed -i '39i if (obj.hits > 0)\n {\n set resp.http.X-Varnish-Cache = "HIT"; \n} \nelse\n {\nset resp.http.X-Varnish-Cache = "MISS";\n}' /etc/varnish/default.vcl    
		sudo systemctl enable varnish.service
    		sudo systemctl restart varnish.service	
            ;;
        "php8.1-fpm")
        	echo "=============Installing php=============" >> /home/hamza/Documents/files.log
            	sudo apt-get install php8.1-fpm
	    	sudo apt install software-properties-common && sudo add-apt-repository ppa:ondrej/php -y
        	sudo apt install php8.1-fpm libapache2-mod-fcgid php8.1-mysql php8.1-curl
        		sudo systemctl enable php8.1-fpm
        	sudo systemctl restart php8.1-fpm 
		#sudo apt install php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip
		sudo a2enmod proxy_fcgi setenvif
		sudo a2enconf php8.1-fpm
		
		#restart apache
		sudo systemctl restart apache2
            ;;
        "mariadb")
            	echo "=============Installing Mariabdb========" >> /home/hamza/Documents/filesmenu.log
            	sudo apt-get install mariadb-server && sudo apt-get install mariadb-client -y >> /home/hamza/Documents/filesmenu.log
                mysql -V
        	#mariadb configure
        	sudo systemctl enable mariadb
        	sudo systemctl status mariadb
		;;
	"Wordpress")
		echo "=============Installing Wordpress===========" >> /home/hamza/Documents/filesmenu.log
		#install wordpress tar
		sudo curl -O https://wordpress.org/latest.tar.gz >> /home/hamza/Documents/filesmenu.log

		#extract wp
		sudo tar -xzvf latest.tar.gz >> /home/hamza/Documents/filesmenu.log

		#enter wp folder
		cd wordpress

		#copy all to new folder
#sudo cp -r * /var/www/hamza/ #sending to the desired directory
		sudo cp -r * /var/www/html/ #send it to desired directory
		#wp-cli install
		sudo curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar #/home/hamza/Documents/filesmenu.log
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
		
		#database 
		sudo mysql -e "create database $wp_db;"
		sudo mysql -e "create user '$wp_user'@'localhost' identified by '$wp_pass';"
		sudo mysql -e "grant all privileges on $wp_db.* to '$wp_user'@'localhost';"
		sudo mysql -e "flush privileges;"


		#enter hamza folder
		echo "Enter wp folder"
		cd /var/www/html/

		#now edit/create config
		sudo wp config create --dbname=$wp_db --dbuser=$wp_user --dbpass=$wp_pass --dbhost='localhost' --allow-root

		#db create
		sudo wp db create --allow-root
		#wp core install for not showing wp installation page
		sudo wp core install --url='hamzakhan.com' --title='wordpress' --admin_user='hamza' --admin_password='admin' --admin_email='hamza.khan@cloudways.com' --allow-root

		#Plugin breeze
		#Don't activate it for now
		sudo wp plugin install breeze --activate --allow-root

		#change permissions
		sudo chmod 777 /var/www/html/wp-content/advanced-cache.php #originial permission 644
		sudo chmod 777 var/www/html/wp-content/breeze-config/
		sudo chmod 777 /var/www/html/wp-content/breeze-config.php
		;;
        "Non")
            echo "User Requested exit"
            exit
            ;;
        *) echo "Invalid option $REPLY";;
    esac
done

sudo systemctl restart nginx.service apache2.service varnish.service

