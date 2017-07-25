#!/bin/bash

echo "====> Provision-script started! "

echo "==> Installing mariadb"
yum install -y  mariadb mariadb-server

echo "==> Mysql Initial configuration"
/usr/bin/mysql_install_db --user=mysql
systemctl start mariadb

echo "==> Creating initial database"
mysql -uroot -Bse "create database zabbix character set utf8 collate utf8_bin;grant all privileges on zabbix.* to zabbix@localhost identified by 'root';"

echo "===> Installing Zabbix Repo "
yum install -y http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/zabbix-release-3.2-1.el7.noarch.rpm

echo "==> Install Zabbix DB packages"
yum install -y zabbix-server-mysql zabbix-web-mysql

echo "==> Import initial schema and data"
zcat /usr/share/doc/zabbix-server-mysql-*/create.sql.gz | mysql -uzabbix -proot zabbix

echo "==> Database configuration for Zabbix server"
sed -i 's/# DBPassword=/DBPassword=root/g' /etc/zabbix/zabbix_server.conf


echo "===> Configuring Zabbix"

echo "<?php
// Zabbix GUI configuration file.
global \$DB;
\$DB['TYPE']     = 'MYSQL';
\$DB['SERVER']   = 'localhost';
\$DB['PORT']     = '0';
\$DB['DATABASE'] = 'zabbix';
\$DB['USER']     = 'zabbix';
\$DB['PASSWORD'] = 'root';
// Schema name. Used for IBM DB2 and PostgreSQL.
\$DB['SCHEMA'] = '';
\$ZBX_SERVER      = 'localhost';
\$ZBX_SERVER_PORT = '10051';
\$ZBX_SERVER_NAME = 'Zabbix Server';
\$IMAGE_FORMAT_DEFAULT = IMAGE_FORMAT_PNG;
" > /etc/zabbix/web/zabbix.conf.php

sed -i 's/Alias \/zabbix \/usr\/share\/zabbix/<VirtualHost *:80>/' /etc/httpd/conf.d/zabbix.conf
sed -i '/<VirtualHost \*:80>/ a\    ServerName zabbix-server' /etc/httpd/conf.d/zabbix.conf
sed -i '/ServerName zabbix-server/ a\    DocumentRoot \/usr\/share\/zabbix\/' /etc/httpd/conf.d/zabbix.conf
sed -i '/DocumentRoot \/usr\/share\/zabbix\// a\<\/VirtualHost>' /etc/httpd/conf.d/zabbix.conf

echo "===> Configuring PHP settings"
sed -i '/always_populate_raw_post_data -1/a php_value date.timezone Europe\/Minsk' /etc/httpd/conf.d/zabbix.conf 

echo "==> Starting Zabbix server process"
systemctl enable zabbix-server 
systemctl start zabbix-server 

echo "==> Starting httpd"
systemctl enable httpd
systemctl start httpd



