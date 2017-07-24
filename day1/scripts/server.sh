#!/bin/bash

echo Installing Zabbix Server
yum -y install http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/zabbix-release-3.2-1.el7.noarch.rpm
yum -y install mariadb mariadb-server
/usr/bin/mysql_install_db --user=mysql
systemctl start mariadb
yum -y install zabbix-server-mysql zabbix-web-mysql
sed -i '/# DBPassword=/a DBPassword=zabbixDB' /etc/zabbix/zabbix_server.conf
mysql -uroot -e "create database zabbix character set utf8 collate utf8_bin;"
mysql -uroot -e "grant all privileges on zabbix.* to zabbix@localhost identified by 'zabbixDB';"
zcat /usr/share/doc/zabbix-server-mysql-*/create.sql.gz | mysql -uzabbix -pzabbixDB zabbix
systemctl start zabbix-server 
sed -i -e 's:# php_value date.timezone Europe/Riga:php_value date.timezone Europe/Minsk:g' /etc/httpd/conf.d/zabbix.conf
systemctl start httpd 
		cat > /etc/zabbix/web/zabbix.conf.php << 'EOL'
<?php
// Zabbix GUI configuration file.
global $DB;

$DB['TYPE']     = 'MYSQL';
$DB['SERVER']   = 'localhost';
$DB['PORT']     = '0';
$DB['DATABASE'] = 'zabbix';
$DB['USER']     = 'zabbix';
$DB['PASSWORD'] = 'zabbixDB';

// Schema name. Used for IBM DB2 and PostgreSQL.
$DB['SCHEMA'] = '';

$ZBX_SERVER      = 'localhost';
$ZBX_SERVER_PORT = '10051';
$ZBX_SERVER_NAME = 'zabbix-server';

$IMAGE_FORMAT_DEFAULT = IMAGE_FORMAT_PNG;
EOL
	SHELL
