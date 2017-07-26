#!/bin/bash

echo "====> Provision-script started! "

echo "==> Installing mariadb"
yum install -y  mariadb mariadb-server

echo "==> Mysql Initial configuration"
/usr/bin/mysql_install_db --user=mysql
systemctl start mariadb
systemctl status mariadb

echo "==> Creating initial database"
mysql -uroot -Bse "create database zabbix character set utf8 collate utf8_bin;grant all privileges on zabbix.* to zabbix@localhost identified by '123';"

echo "===> Installing Zabbix Repo "
yum install -y http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/zabbix-release-3.2-1.el7.noarch.rpm

echo "==> Install Zabbix DB packages"
yum install -y zabbix-server-mysql zabbix-web-mysql

echo "==> Import initial schema and data"
zcat /usr/share/doc/zabbix-server-mysql-*/create.sql.gz | mysql -u zabbix -p123 zabbix

echo "==> Database configuration for Zabbix server"
sed -i '/DBHost=localhost/s/^#//g' /etc/zabbix/zabbix_server.conf
sed -i '/# DBPassword=/c\DBPassword= 123' /etc/zabbix/zabbix_server.conf

echo "==> Starting Zabbix server process"
systemctl start zabbix-server

echo "===> Configuring PHP settings"
sed -i 's;# php_value date.timezone Europe/Riga;php_value date.timezone Europe/Minsk;g' /etc/httpd/conf.d/zabbix.conf

echo "==> Starting Front-end "
echo "<VirtualHost 192.168.56.10>
 DocumentRoot "/usr/share/zabbix"
 ServerName zabbix-server
</VirtualHost>" >> /etc/httpd/conf/httpd.conf
systemctl start httpd

echo "===> Configuring Zabbix"
echo "<?php
// Zabbix GUI configuration file.
global \$DB;

\$DB['TYPE']     = 'MYSQL';
\$DB['SERVER']   = 'localhost';
\$DB['PORT']     = '3306';
\$DB['DATABASE'] = 'zabbix';
\$DB['USER']     = 'zabbix';
\$DB['PASSWORD'] = '123';

// Schema name. Used for IBM DB2 and PostgreSQL.
\$DB['SCHEMA'] = '';

\$ZBX_SERVER      = 'localhost';
\$ZBX_SERVER_PORT = '10051';
\$ZBX_SERVER_NAME = 'Zabbix Server';

\$IMAGE_FORMAT_DEFAULT = IMAGE_FORMAT_PNG;" > /etc/zabbix/web/zabbix.conf.php

