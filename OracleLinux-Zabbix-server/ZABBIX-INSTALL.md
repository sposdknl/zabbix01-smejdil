# Install Zabbix
Repositories for teaching purposes at SPOS DK

Repository pro vyuku na SPOS DK

## Manuální postup instalace Zabbix monitorovacího systému 

Zabbix - [https://www.zabbix.com](https://www.zabbix.com)

- Vytvoříme si VM s RockyLinux
- Po přihláení do OS postupně vykonáme tyto příkazy
- Po instalaci a konfiguraci použijeme Browser a provedeme finalni konfiguraci

```console
    # Vytvorime si VM s RockyLinux
    vagrant up
    vagrant ssh

    # Instalace balicku net-tools
    sudo dnf update

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

    # Konfigurace databáze pro Zabbix
    sudo mysql -e "CREATE DATABASE zabbix CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;"
    sudo mysql -e "CREATE USER 'zabbix'@'localhost' IDENTIFIED BY 'zabbix_password';"
    sudo mysql -e "GRANT ALL PRIVILEGES ON zabbix.* TO 'zabbix'@'localhost';"
    sudo mysql -e "SET GLOBAL log_bin_trust_function_creators = 1;"
    sudo mysql -e "FLUSH PRIVILEGES;"

    # Import Zabbix databázové struktury
    sudo zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql --default-character-set=utf8mb4 -uzabbix -pzabbix_password zabbix

    # Disable log_bin_trust_function_creators option after importing database schema.
    sudo mysql -e "SET GLOBAL log_bin_trust_function_creators = 0;"

    # Konfigurace Zabbix serveru
    sudo sed -i 's/# DBPassword=/DBPassword=zabbix_password/' /etc/zabbix/zabbix_server.conf

    # Spuštění Zabbix serveru a agenta
    sudo systemctl restart zabbix-server zabbix-agent2 httpd
    sudo systemctl enable zabbix-server zabbix-agent2 httpd

    # Konfigurace PHP pro Zabbix frontend
    sudo sed -i 's/^max_execution_time = .*/max_execution_time = 300/' /etc/php.ini
    sudo sed -i 's/^memory_limit = .*/memory_limit = 128M/' /etc/php.ini
    sudo sed -i 's/^post_max_size = .*/post_max_size = 16M/' /etc/php.ini
    sudo sed -i 's/^upload_max_filesize = .*/upload_max_filesize = 2M/' /etc/php.ini
    sudo sed -i 's/^;date.timezone =.*/date.timezone = Europe\/Prague/' /etc/php.ini

    # Restart Apache pro načtení změn
    sudo systemctl restart httpd

    # Konfigurace zabbix_agent2.conf
    sudo cp -v /etc/zabbix/zabbix_agent2.conf /etc/zabbix/zabbix_agent2.conf-orig
    sudo sed -i 's/Server=127.0.0.1/Server=localhost/g' /etc/zabbix/zabbix_agent2.conf
    sudo sed -i 's/ServerActive=127.0.0.1/ServerActive=localhost/g' /etc/zabbix/zabbix_agent2.conf
    sudo diff -u /etc/zabbix/zabbix_agent2.conf-orig /etc/zabbix/zabbix_agent2.conf

    # Restart sluzby zabbix-agent2
    sudo systemctl restart zabbix-agent2
```
## Provedeme konfiguraci Zabbix Web GUI pomocí PHP wizard

- Zadejte do browseru - http://localhost:8084/zabbix/
- Username: Admin
- Passwoed: zabbix
...