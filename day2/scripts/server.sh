#!/bin/bash

echo "***********Running script zabbix-server.sh on zabbix-server***********"
echo "***********Install mysql server***********"
yum install mariadb mariadb-server -y
echo "***********Mysql Initial configuration***********"
/usr/bin/mysql_install_db --user=mysql
echo "***********Starting and enabling mysqld service***********"
systemctl enable mariadb
systemctl start mariadb

echo "***********Creating initial database***********"
mysql -uroot <<EOF
create database zabbix character set utf8 collate utf8_bin;
grant all privileges on zabbix.* to zabbix@localhost identified by 'zabbix';
quit
EOF

echo "***********Install Zabbix and Zabbix Frond-end packages***********"
yum install http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/zabbix-release-3.2-1.el7.noarch.rpm -y
yum install zabbix-server-mysql zabbix-web-mysql -y

echo "***********Import initial schema and data***********"
zcat /usr/share/doc/zabbix-server-mysql-*/create.sql.gz | mysql -uzabbix -pzabbix zabbix

echo "***********Database configuration for Zabbix server***********"
sed -i '/# DBHost=localhost/ a\DBHost=localhost' /etc/zabbix/zabbix_server.conf
sed -i '/# DBPassword=/ a\DBPassword=zabbix' /etc/zabbix/zabbix_server.conf

echo "***********Initial Zabbix configuration***********"
cat > /etc/zabbix/web/zabbix.conf.php <<- EOF

<?php
// Zabbix GUI configuration file.
global \$DB;

\$DB['TYPE']     = 'MYSQL';
\$DB['SERVER']   = 'localhost';
\$DB['PORT']     = '3306';
\$DB['DATABASE'] = 'zabbix';
\$DB['USER']     = 'zabbix';
\$DB['PASSWORD'] = 'zabbix';

// Schema name. Used for IBM DB2 and PostgreSQL.
\$DB['SCHEMA'] = '';

\$ZBX_SERVER      = 'localhost';
\$ZBX_SERVER_PORT = '10051';
\$ZBX_SERVER_NAME = 'Zabbix Server';

\$IMAGE_FORMAT_DEFAULT = IMAGE_FORMAT_PNG;

EOF

sed -i 's/Alias \/zabbix \/usr\/share\/zabbix/<VirtualHost *:80>/' /etc/httpd/conf.d/zabbix.conf
sed -i '/<VirtualHost \*:80>/ a\    ServerName zabbix-server' /etc/httpd/conf.d/zabbix.conf
sed -i '/ServerName zabbix-server/ a\    DocumentRoot \/usr\/share\/zabbix\/' /etc/httpd/conf.d/zabbix.conf
sed -i '/DocumentRoot \/usr\/share\/zabbix\// a\<\/VirtualHost>' /etc/httpd/conf.d/zabbix.conf

echo "***********Configuring PHP settings***********"
sed -i 's/# php_value date.timezone Europe\/Riga/php_value date.timezone Europe\/Minsk/' /etc/httpd/conf.d/zabbix.conf

echo "***********Starting and enabling Zabbix server process***********"
systemctl enable zabbix-server 
systemctl start zabbix-server 

echo "***********Starting and enabling Front-end***********"
systemctl enable httpd
systemctl start httpd

echo "***********Installing, Starting and Enabling Zabbix Agent***********"
yum install zabbix-agent -y
systemctl enable zabbix-agent
systemctl start zabbix-agent

echo "***********Install and Configure Zabbix Java G/W***********"
yum install zabbix-java-gateway -y
sed -i '/# JavaGateway=/ a\JavaGateway=127.0.0.1' /etc/zabbix/zabbix_server.conf
sed -i '/# StartJavaPollers=0/ a\StartJavaPollers=5' /etc/zabbix/zabbix_server.conf
systemctl enable zabbix-java-gateway
systemctl start zabbix-java-gateway
systemctl restart zabbix-server

echo "+++++++++++++++++++++++++++++"
echo "You can connect to Zabbix server via $(hostname -I | cut -f2 | awk '{print $2}'):80"
echo "or you can add '192.168.56.110 zabbix-server' to your hosts file and use http://zabbix-server instead of 'ip:port'"
echo "+++++++++++++++++++++++++++++"
