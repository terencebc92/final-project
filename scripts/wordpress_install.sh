#!/bin/bash

# Install required packages
sudo apt update
sudo apt install -y vim unzip libapache2-mod-php php-mysqli mysql-server

# Create MySQL database and user
sudo mysql -e "CREATE DATABASE $DATABASENAME;"
sudo mysql -e "CREATE USER '$DBUSER'@'localhost' IDENTIFIED BY '$DBPASS';"
sudo mysql -e "GRANT ALL PRIVILEGES ON $DATABASENAME.* TO '$DBUSER'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

# Retrieve and extract WordPress
sudo wget https://wordpress.org/latest.zip
sudo unzip latest.zip
sudo mv wordpress /var/www/html/

# Rename and configure wp-config.php
sudo mv /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php
sed -i "s/database_name_here/$DATABASENAME/" /var/www/html/wordpress/wp-config.php
sed -i "s/username_here/$DBUSER/" /var/www/html/wordpress/wp-config.php
sed -i "s/password_here/$DBPASS/" /var/www/html/wordpress/wp-config.php

# Install and configure firewalld
sudo apt install -y firewalld
sudo systemctl enable firewalld
sudo systemctl start firewalld
sudo firewall-cmd --permanent --zone=public --add-service=http
sudo firewall-cmd --permanent --zone=public --add-port=80/tcp
sudo systemctl restart firewalld

# Change ownership of WordPress directory
sudo chown -R www-data:www-data /var/www/html/wordpress