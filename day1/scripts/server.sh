#!/bin/bash

echo Installing Zabbix Server

#Installing some tools for work
yum install -y vim;
yum install -y net-tools;
	
#Installing and configuring MySQL DB (MariaDB)
#Install mysql server
yum -y install mariadb mariadb-server;

#Mysql Initial configuration
/usr/bin/mysql_install_db --user=mysql;
	
#Starting and enabling mysqld service 
systemctl start mariadb;
	
#Creating initial database
mysql -uroot -Bse "create database zabbix character set utf8 collate utf8_bin;grant all privileges on zabbix.* to zabbix@localhost identified by 'zabbix';";

#Install Zabbix Repo
yum -y install http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/zabbix-release-3.2-1.el7.noarch.rpm;

#Install Zabbix DB packages
yum -y install zabbix-server-mysql zabbix-web-mysql;

#Import initial schema and data
zcat /usr/share/doc/zabbix-server-mysql-*/create.sql.gz | mysql -uzabbix -pzabbix zabbix;

#Database configuration for Zabbix server
sed -i 's|# DBHost=localhost|DBHost=localhost|' /etc/zabbix/zabbix_server.conf;
sed -i 's|# DBPassword=|DBPassword=zabbix|' /etc/zabbix/zabbix_server.conf;

#Starting Zabbix server process
systemctl start zabbix-server;

#Configuring PHP settings
sed -i 's|# php_value date.timezone Europe/Riga|php_value date.timezone Europe/Minsk|' /etc/httpd/conf.d/zabbix.conf;

#Configuring httpd service
touch /etc/httpd/conf.d/zab.conf
cat >/etc/httpd/conf.d/zab.conf <<EOL
<VirtualHost *:80>
    DocumentRoot /usr/share/zabbix/
    ServerName zabbix
</VirtualHost>
EOL

#Configuring Front-end settings
touch /etc/zabbix/web/zabbix.conf.php;
cat >/etc/zabbix/web/zabbix.conf.php <<'EOL'
<?php
// Zabbix GUI configuration file.
global $DB;

$DB['TYPE']     = 'MYSQL';
$DB['SERVER']   = 'localhost';
$DB['PORT']     = '3306';
$DB['DATABASE'] = 'zabbix';
$DB['USER']     = 'zabbix';
$DB['PASSWORD'] = 'zabbix';

// Schema name. Used for IBM DB2 and PostgreSQL.
$DB['SCHEMA'] = '';

$ZBX_SERVER      = 'localhost';
$ZBX_SERVER_PORT = '10051';
$ZBX_SERVER_NAME = 'Zabbix Server';

$IMAGE_FORMAT_DEFAULT = IMAGE_FORMAT_PNG;
EOL

#Starting Front-end
systemctl start httpd;





