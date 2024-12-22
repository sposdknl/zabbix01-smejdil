#!/usr/bin/env bash

# Konfigurace databáze pro Zabbix
sudo mysql -e "CREATE DATABASE zabbix CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;"
sudo mysql -e "CREATE USER 'zabbix'@'localhost' IDENTIFIED BY 'zabbix_password';"
sudo mysql -e "GRANT ALL PRIVILEGES ON zabbix.* TO 'zabbix'@'localhost';"
sudo mysql -e "SET GLOBAL log_bin_trust_function_creators = 1;"
sudo mysql -e "FLUSH PRIVILEGES;"

 # Import Zabbix databázové struktury
sudo cat /usr/local/share/zabbix7/server/database/mysql/schema.sql | mysql --default-character-set=utf8mb4 -uzabbix -pzabbix_password zabbix
sudo cat /usr/local/share/zabbix7/server/database/mysql/images.sql | mysql --default-character-set=utf8mb4 -uzabbix -pzabbix_password zabbix
sudo cat /usr/local/share/zabbix7/server/database/mysql/data.sql | mysql --default-character-set=utf8mb4 -uzabbix -pzabbix_password zabbix

# Disable log_bin_trust_function_creators option after importing database schema.
sudo mysql -e "SET GLOBAL log_bin_trust_function_creators = 0;"

# Konfigurace Zabbix serveru
sudo cp -v /usr/local/etc/zabbix7/zabbix_server.conf /usr/local/etc/zabbix7/zabbix_server.conf-orig
sudo gsed -i 's/# DBPassword=/DBPassword=zabbix_password/' /usr/local/etc/zabbix7/zabbix_server.conf

# Spuštění Zabbix serveru a agenta
sudo /usr/local/etc/rc.d/zabbix_agentd restart
sudo /usr/local/etc/rc.d/zabbix_server restart

# Konfigurace PHP pro Zabbix frontend
sudo cp /usr/local/etc/php.ini-production /usr/local/etc/php.ini
sudo gsed -i 's/^max_input_time = .*/max_input_time = 300/' /usr/local/etc/php.ini
sudo gsed -i 's/^memory_limit = .*/memory_limit = 128M/' /usr/local/etc/php.ini
sudo gsed -i 's/^post_max_size = .*/post_max_size = 16M/' /usr/local/etc/php.ini
sudo gsed -i 's/^upload_max_filesize = .*/upload_max_filesize = 2M/' /usr/local/etc/php.ini
sudo gsed -i 's/^;date.timezone =.*/date.timezone = Europe\/Prague/' /usr/local/etc/php.ini
sudo cp /home/vagrant/zabbix.conf /usr/local/etc/apache24/extra/

# Restart Apache pro načtení změn
sudo cp /usr/local/etc/apache24/httpd.conf /usr/local/etc/apache24/httpd.conf-orig
sudo cp /home/vagrant/httpd.conf.patch /usr/local/etc/apache24/
sudo cd /usr/local/etc/apache24/
sudo patch httpd.conf < httpd.conf.patch
sudo cp /home/vagrant/zabbix.conf.php /usr/local/www/zabbix7/conf/
sudo chown www:www /usr/local/www/zabbix7/conf/zabbix.conf.php
sudo chmod 400 /usr/local/www/zabbix7/conf/zabbix.conf.php
sudo /usr/local/etc/rc.d/apache24 restart

# Konfigurace zabbix_agent2.conf
sudo cp -v /usr/local/etc/zabbix7/zabbix_agentd.conf /usr/local/etc/zabbix7/zabbix_agentd.conf-orig
sudo gsed -i 's/Server=127.0.0.1/Server=localhost/g' /usr/local/etc/zabbix7/zabbix_agentd.conf
sudo gsed -i 's/ServerActive=127.0.0.1/ServerActive=localhost/g' /usr/local/etc/zabbix7/zabbix_agentd.conf
sudo diff -u /usr/local/etc/zabbix7/zabbix_agentd.conf-orig /usr/local/etc/zabbix7/zabbix_agentd.conf

# Restart sluzby zabbix-agentd
sudo /usr/local/etc/rc.d/zabbix_agentd restart

# EOF