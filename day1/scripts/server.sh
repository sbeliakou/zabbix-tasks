#!/bin/bash

sudo su
yum -y install mariadb mariadb-server
/usr/bin/mysql_install_db --user=mysql
systemctl start mariadb
mysql -uroot -Bse "create database zabbix character set utf8 collate utf8_bin;
grant all privileges on zabbix.* to zabbix@localhost identified by 'zabbix';"
yum -y install net-tools
yum -y install http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/zabbix-release-3.2-1.el7.noarch.rpm
yum -y install zabbix-server-mysql zabbix-web-mysql
zcat /usr/share/doc/zabbix-server-mysql-*/create.sql.gz | mysql -uzabbix -pzabbix zabbix

sed -i '/# DBPassword=/ a\DBPassword=zabbix' /etc/zabbix/zabbix_server.conf
sed -i '/# DBHost=localhost/ a\DBHost=localhost' /etc/zabbix/zabbix_server.conf
sed -i 's/DBUser=zabbix/DBUser=zabbix/g' /etc/zabbix/zabbix_server.conf
sed -i 's/DBName=zabbix/DBName=zabbix/g' /etc/zabbix/zabbix_server.conf
sed -i 's;# php_value date.timezone Europe/Riga;php_value date.timezone Europe/Minsk;g' /etc/httpd/conf.d/zabbix.conf

cat > /etc/zabbix/web/zabbix.conf.php <<- EOF
<?php
// Zabbix GUI configuration file.
global \$DB;

\$DB['TYPE']     = 'MYSQL';
\$DB['SERVER']   = 'localhost';
\$DB['PORT']     = '0';
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

cat > /etc/httpd/conf.d/virtualhosts.conf << EOF
<VirtualHost *:80>
	DocumentRoot /usr/share/zabbix
	ServerName zabbix-server
</VirtualHost>
EOF

yum -y install zabbix-agent
systemctl start httpd
systemctl enable zabbix-server
systemctl start zabbix-server
systemctl enable zabbix-server
systemctl start zabbix-agent
systemctl enable zabbix-agent