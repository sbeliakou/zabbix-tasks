#!/bin/bash

echo "### Disable firewall ###"
	systemctl stop firewalld
	systemctl disable firewalld
	
echo "### Install and configure mariadb ###"
	yum install mariadb mariadb-server -y > /dev/null
	/usr/bin/mysql_install_db --user=mysql
	systemctl start mariadb
	systemctl enable mariadb
	mysql -uroot -Bse "create database zabbix character set utf8 collate utf8_bin; grant all privileges on zabbix.* to zabbix@localhost identified by 'SQL_zb_2017';"

echo "### Install and configure Zabbix ###"
	yum install http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/zabbix-release-3.2-1.el7.noarch.rpm -y > /dev/null
	yum install zabbix-server-mysql zabbix-web-mysql -y > /dev/null
	zcat /usr/share/doc/zabbix-server-mysql-*/create.sql.gz | mysql -uzabbix -pSQL_zb_2017 zabbix
	sed -i 's/# DBHost/DBHost/' /etc/zabbix/zabbix_server.conf
	sed -i 's/# DBPassword=/DBPassword=SQL_zb_2017/' /etc/zabbix/zabbix_server.conf
	sed -i 's/# JavaGateway=/JavaGateway=192.168.56.11/' /etc/zabbix/zabbix_server.conf
	sed -i 's/# JavaGatewayPort/JavaGatewayPort/' /etc/zabbix/zabbix_server.conf
	sed -i 's/# StartJavaPollers=0/StartJavaPollers=5/' /etc/zabbix/zabbix_server.conf

cat << 'EOT' > /etc/zabbix/web/zabbix.conf.php
<?php
// Zabbix GUI configuration file.
global $DB;

$DB['TYPE']     = 'MYSQL';
$DB['SERVER']   = 'localhost';
$DB['PORT']     = '0';
$DB['DATABASE'] = 'zabbix';
$DB['USER']     = 'zabbix';
$DB['PASSWORD'] = 'SQL_zb_2017';

// Schema name. Used for IBM DB2 and PostgreSQL.
$DB['SCHEMA'] = '';

$ZBX_SERVER      = 'localhost';
$ZBX_SERVER_PORT = '10051';
$ZBX_SERVER_NAME = 'Zabbix Server';

$IMAGE_FORMAT_DEFAULT = IMAGE_FORMAT_PNG;
EOT

	systemctl start zabbix-server
	systemctl enable zabbix-server
	
echo "### Install zabbix-web-mysql ###"
	yum install zabbix-web-mysql -y  > /dev/null
        sed -i 's@# php_value date.timezone Europe/Riga@php_value date.timezone Europe/Minsk@' /etc/httpd/conf.d/zabbix.conf
	cat << 'EOT' > /etc/httpd/conf.d/zabbix-host.conf
<VirtualHost *:80>
 DocumentRoot /usr/share/zabbix
 ServerName zabbix-server
</VirtualHost>
EOT
	systemctl start httpd
	
echo "### Install zabbix agent ###"
	yum install zabbix-agent -y > /dev/null
	sed -i 's@# DebugLevel@DebugLevel@' /etc/zabbix/zabbix_agentd.conf
	sed -i 's@Server=127.0.0.1@Server=127.0.0.1,192.168.56.12@' /etc/zabbix/zabbix_agentd.conf
	sed -i 's@# ListenPort=10050@ListenPort=10050@' /etc/zabbix/zabbix_agentd.conf
	sed -i 's@ServerActive=127.0.0.1@ServerActive=192.168.56.10@' /etc/zabbix/zabbix_agentd.conf
	sed -i 's@# HostnameItem=system.hostname@HostnameItem=system.hostname@' /etc/zabbix/zabbix_agentd.conf
	systemctl start zabbix-agent
	systemctl enable zabbix-agent


