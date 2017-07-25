#!/bin/bash

echo Installing Zabbix Server


yum -y install net-tools

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

yum -y install zabbix-java-gateway
sed -i 's;# JavaGateway=;JavaGateway=127.0.0.1;g' /etc/zabbix/zabbix_server.conf
sed -i 's;# JavaGatewayPort;JavaGatewayPort;g' /etc/zabbix/zabbix_server.conf
sed -i 's;# StartJavaPollers=0;StartJavaPollers=5;g' /etc/zabbix/zabbix_server.conf
sed -i 's;# php_value date.timezone Europe/Riga;php_value date.timezone Europe/Minsk;g' /etc/httpd/conf.d/zabbix.conf
systemctl start zabbix-server
systemctl start zabbix-java-gateway
systemctl enable zabbix-server
systemctl enable zabbix-java-gateway
cp /share/zabbix.conf.php /etc/zabbix/web/
systemctl start httpd
systemctl enable httpd
yum -y install zabbix-agent
rm -f /etc/zabbix/zabbix_agentd.conf
cp /share/zabbix_agentd.conf /etc/zabbix/zabbix_agentd.conf
systemctl start zabbix-agent
systemctl enable zabbix-agent
