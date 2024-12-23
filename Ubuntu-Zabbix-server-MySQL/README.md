[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/UnL7NDUC)

# Automatická instalace Zabbix serveru
Independent work - Zabbix server installation using Vagrant and automation

Samostatná práce - instalace Zabbix serveru pomocí Vagrant a automatizace

## Instalace Zabbix serveru a agenta pomocí Vagrant a Ansible

Vagrantfile obsahuje instalaci [Ansible](https://www.ansible.com), Ansible collection [community.zabbix](https://galaxy.ansible.com/ui/repo/published/community/zabbix/) a další pomocné role. Dále se používá provisioning [ansible_local](https://developer.hashicorp.com/vagrant/docs/provisioning/ansible_local) pro zpuštění Ansible [playbooku](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_intro.html).

## 1. Příprava projektu

- Použit Box Ubuntu 24.04 LTS - [bento/ubuntu-24.04](https://portal.cloud.hashicorp.com/vagrant/discover/bento/ubuntu-24.04)

## 2. Instalace Zabbixu 7.0 LTS

- Nainstalován webový server Apache 2.4.58
- Nainstalováo PHP 8.3.6
- Nainstalována databáze MySQL 8.0.40
- Nainstalován Zabbix 7.0.6 LTS
- Nainstalován Zabbix agent2 7.0.6 LTS

### Automatizovaná instalace

- Použit provisioning metoda ansible_local
- Instalace a konfigurace Apache + PHP
- Instalace a konfigurace Zabbix serveru
- Konfigurace zabbix serveru - CacheSize, StartPollers atd.
- Instalace a konfigurace Zabbix agenta

```console
git clone https://github.com/sposdknl/zabbix01-smejdil.git
cd zabbix01-smejdil/Ubuntu-Zabbix-server-MySQL
vagrant up
vagrant ssh

http://localhost:8082/zabbix/
```
## 3. Monitoring
### Monitorujte SSL certifikát školního webu

- Pomocí Ansible vytvořena Host Group - Web Certificate
- Pomocí Ansible vytvořen Host sposdk.cz
- Pomocí Ansible vytvořen Host mysql
- Elimanace manuálních úkonů - importuován host sposdk.cz - sposdk.cz_hosts.yaml

## 4. Důležité soubory

| File config                   | Komponenta      |
|-------------------------------|-----------------|
| Vagrantfile                   | Vagrant         |
| zabbix_server.conf            | Zabbix server   |
| zabbix_agent2.conf            | Zabbix agent    |
| zabbix.conf.php               | Zabbix frontend |
| apache.conf                   | Apache          |
| mysql.ini                     | MariaDB         |
