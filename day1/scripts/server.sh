#!/bin/bash
yum install vim -y;
echo " Installing DataBase and creating user/password";
yum install mariadb mariadb-server -y;
/usr/bin/mysql_install_db --user=mysql;
systemctl start mariadb;
mysql -uroot -Bse "create database zabbix character set utf8 collate utf8_bin; grant all privileges on zabbix.* to zabbix@localhost identified by 'password'; ";
echo "Downloading Zabbix and configuring it";
yum install http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/zabbix-release-3.2-1.el7.noarch.rpm -y;
yum install zabbix-server-mysql zabbix-web-mysql -y;
zcat /usr/share/doc/zabbix-server-mysql-*/create.sql.gz | mysql -uzabbix -ppassword zabbix;
sed -i '115 s/# DBPassword=/DBPassword=password/' /etc/zabbix/zabbix_server.conf ;
echo "Update timezone"
sed -i 's;# php_value date.timezone Europe/Riga;php_value date.timezone Europe/Minsk;g' /etc/httpd/conf.d/zabbix.conf
cat > /etc/httpd/conf.d/vh.conf << EOF
<VirtualHost *:80>	
	DocumentRoot /usr/share/zabbix	
	ServerName zabbix-server
</VirtualHost>
EOF

echo "Modifying zabbix.conf.php file for our configuration";
echo "<?php
// Zabbix GUI configuration file.
global \$DB;

\$DB['TYPE']     = 'MYSQL';
\$DB['SERVER']   = 'localhost';
\$DB['PORT']     = '3306';
\$DB['DATABASE'] = 'zabbix';
\$DB['USER']     = 'zabbix';
\$DB['PASSWORD'] = 'password';

// Schema name. Used for IBM DB2 and PostgreSQL.
\$DB['SCHEMA'] = '';

\$ZBX_SERVER      = 'localhost';
\$ZBX_SERVER_PORT = '10051';
\$ZBX_SERVER_NAME = 'Zabbix Server';

\$IMAGE_FORMAT_DEFAULT = IMAGE_FORMAT_PNG;
" > /etc/zabbix/web/zabbix.conf.php

yum install zabbix-get -y;
systemctl start zabbix-server;
systemctl start httpd;
