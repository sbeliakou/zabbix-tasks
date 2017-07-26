#!/bin/bash

echo Installing Zabbix Server

yum -y install mariadb mariadb-server
/usr/bin/mysql_install_db --user=mysql
systemctl start mariadb
mysql -uroot -Bse "create database zabbix character set utf8 collate utf8_bin;
grant all privileges on zabbix.* to zabbix@localhost identified by 'password'; quit;"
yum install -y http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/zabbix-release-3.2-1.el7.noarch.rpm
yum install -y zabbix-server-mysql zabbix-web-mysql
zcat /usr/share/doc/zabbix-server-mysql-*/create.sql.gz | mysql -uzabbix -ppassword zabbix
sed -i 's;# DBHost=localhost;DBHost=localhost;g' /etc/zabbix/zabbix_server.conf
sed -i 's;# DBPassword=;DBPassword=password;g' /etc/zabbix/zabbix_server.conf
sed -i 's;# php_value date.timezone Europe/Riga;php_value date.timezone Europe/Minsk;g' /etc/httpd/conf.d/zabbix.conf
echo "<VirtualHost 192.168.56.10>
 DocumentRoot "/usr/share/zabbix"
 ServerName zabbix-server
</VirtualHost>" >> /etc/httpd/conf/httpd.conf
systemctl start zabbix-server
cp /share/zabbix.conf.php /etc/zabbix/web/
systemctl start httpd
yum -y install zabbix-agent
yum -y install zabbix-get
rm -f /etc/zabbix/zabbix_agentd.conf
cp /share/zabbix_agentd.conf /etc/zabbix/zabbix_agentd.conf
systemctl start zabbix-agent
