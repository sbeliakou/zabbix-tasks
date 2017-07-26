#!/bin/sh

echo "AT THE BEGIN WAS ZABBIX..."
yum install -y mariadb mariadb-server
yum install -y vim
yum install -y zabbix-sender
yum install -y zabbix-get
echo "Installation of mysql"
/usr/bin/mysql_install_db --user=mysql
systemctl start mariadb
if pgrep -x "mysqld" > /dev/null
then
    echo "MYSQLD IS RUNNING"
else
    echo "MARIADB IS STOPPED"
fi
echo "MYSQL STARTED, CREATING DB AND USERS"

mysql -uroot -Bse "create database zabbix character set utf8 collate utf8_bin;
grant all privileges on zabbix.* to zabbix@localhost identified by 'zabbix';"

yum install -y http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/zabbix-release-3.2-1.el7.noarch.rpm
yum install -y zabbix-server-mysql zabbix-web-mysql
zcat /usr/share/doc/zabbix-server-mysql-*/create.sql.gz | mysql -uzabbix -pzabbix zabbix
sed -i 's/# DBHost=localhost/DBHost=localhost/' /etc/zabbix/zabbix_server.conf
sed -i 's/# DBPassword=/DBPassword=zabbix/' /etc/zabbix/zabbix_server.conf
systemctl start zabbix-server
sleep 3

if pgrep -x "zabbix-server" > /dev/null
then
    echo "ZABBIX-SERVER IS RUNNING"
else
    echo "ZABBIX-SERVER IS STOPPED"
fi
echo "FRONT-END INSTALLATION..."
yum install -y http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/zabbix-release-3.2-1.el7.noarch.rpm
yum install -y zabbix-web-mysql
sed -i  's/# php_value date.timezone Europe\/Riga/php_value date.timezone Europe\/Minsk/' /etc/httpd/conf.d/zabbix.conf

touch /etc/httpd/conf.d/vhost.conf
cat > /etc/httpd/conf.d/vhost.conf << EOL
<VirtualHost *:80>
 DocumentRoot /usr/share/zabbix/
 ServerName zabbix
</VirtualHost>
EOL

touch /etc/zabbix/web/zabbix.conf.php
cat > /etc/zabbix/web/zabbix.conf.php << 'EOL'
<?php
// Zabbix GUI configuration file.
global $DB;

$DB['TYPE']     = 'MYSQL';
$DB['SERVER']   = 'localhost';
$DB['PORT']     = '0';
$DB['DATABASE'] = 'zabbix';
$DB['USER']     = 'zabbix';
$DB['PASSWORD'] = 'zabbix';

// Schema name. Used for IBM DB2 and PostgreSQL.
$DB['SCHEMA'] = '';

$ZBX_SERVER      = 'localhost';
$ZBX_SERVER_PORT = '10051';
$ZBX_SERVER_NAME = 'zabbix';

$IMAGE_FORMAT_DEFAULT = IMAGE_FORMAT_PNG;
EOL

if [ -s /etc/zabbix/web/zabbix.conf.php ]
then
   echo "ZABBIX.CONF.PHP EXISTS and is not empty "
else
   echo " ZABBIX.CONF.PHP file does not exist, or is empty "
fi

systemctl start httpd
sleep 2
HTTP_STATUS="$(curl -IL --silent http://localhost | grep HTTP )";
echo "${HTTP_STATUS}"

echo "Zabbix Agent Installation"

yum install -y zabbix-agent;

sed -i 's|# DebugLevel=3|DebugLevel=3|' /etc/zabbix/zabbix_agentd.conf;
sed -i 's|Server=127.0.0.1|Server=192.168.56.10|' /etc/zabbix/zabbix_agentd.conf;
sed -i 's|# ListenPort=10050|ListenPort=10050|' /etc/zabbix/zabbix_agentd.conf;
sed -i 's|# ListenIP=0.0.0.0|ListenIP=0.0.0.0|' /etc/zabbix/zabbix_agentd.conf;
sed -i 's|# StartAgents=3|StartAgents=3|' /etc/zabbix/zabbix_agentd.conf;
sed -i 's|ServerActive=127.0.0.1|ServerActive=192.168.56.10:10051|' /etc/zabbix/zabbix_agentd.conf;
sed -i 's|Hostname=Zabbix server|Hostname=Zabbix client|' /etc/zabbix/zabbix_agentd.conf;

echo "Zabbix Agent starting..."
systemctl start zabbix-agent;
sleep 2;

if pgrep -x "zabbix_agentd" > /dev/null
then
    echo "AGENT IS RUNNING"
else
    echo "AGENT IS STOPPED"
fi