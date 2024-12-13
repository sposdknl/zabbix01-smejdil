#!/usr/bin/env bash

# Instalace balicku net-tools
#sudo dnf update

# Stažení balíčku pro instalaci zabbix repo
sudo  rpm -Uvh https://repo.zabbix.com/zabbix/7.0/oracle/9/x86_64/zabbix-release-latest-7.0.el9.noarch.rpm
sudo dnf clean all 

# Aktualizace repository
sudo dnf install -y mariadb-server
sudo dnf install -y zabbix-server-mysql zabbix-web-mysql zabbix-apache-conf zabbix-sql-scripts zabbix-selinux-policy zabbix-agent2

# Povoleni sluzby
sudo systemctl enable mariadb.service
sudo systemctl enable zabbix-server zabbix-agent2 httpd php-fpm 

# Restart sluzby
sudo systemctl restart mariadb.service
sudo systemctl restart httpd php-fpm

# EOF