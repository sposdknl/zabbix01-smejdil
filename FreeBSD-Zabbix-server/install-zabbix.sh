#!/usr/bin/env bash

# Install uuid and gsed
sudo pkg install -y p5-UUID gsed htop

# Aktualizace repository
sudo pkg update

# Install MySQL
sudo pkg install -y mysql80-server

# Povoleni sluzby mysql
sudo /usr/local/etc/rc.d/mysql-server enable

# Restart sluzby mysql
sudo /usr/local/etc/rc.d/mysql-server restart

# Instalace balicku zabbix agent a server
sudo pkg install -y zabbix7-agent zabbix7-server zabbix7-frontend-php83 zabbix7-java

# Instalace balicku Apache a PHP
sudo pkg install -y apache24 mod_php83

# Povoleni sluzby apache
sudo /usr/local/etc/rc.d/apache24 enable

# Restart sluzby apache
sudo /usr/local/etc/rc.d/apache24 restart

# Povoleni sluzby zabbix agent a server
sudo /usr/local/etc/rc.d/zabbix_agentd enable
sudo /usr/local/etc/rc.d/zabbix_server enable

# Restart sluzby zabbix agent
sudo /usr/local/etc/rc.d/zabbix_agentd restart
sudo /usr/local/etc/rc.d/zabbix_server restart

# EOF