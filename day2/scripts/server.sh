#!/bin/bash
set -x
#mariadb
yum install mariadb mariadb-server -y
/usr/bin/mysql_install_db --user=mysql
systemctl start mariadb

#Creating initial database
mysql -uroot <<EOF
create database zabbix character set utf8 collate utf8_bin;
grant all privileges on zabbix.* to zabbix@localhost identified by 'zabbix';
quit;
EOF

#zabbix
yum install http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/zabbix-release-3.2-1.el7.noarch.rpm -y
yum install zabbix-server-mysql zabbix-web-mysql -y

zcat /usr/share/doc/zabbix-server-mysql-*/create.sql.gz | mysql -u zabbix -pzabbix --database=zabbix
sed -i '/# DBPassword=/ a\DBPassword = zabbix' /etc/zabbix/zabbix_server.conf
sed -i '/# php_value date.timezone Europe\/Riga/ a\php_value date.timezone Europe\/Minsk' /etc/httpd/conf.d/zabbix.conf


sed -i 's/Alias \/zabbix \/usr\/share\/zabbix/<VirtualHost \*:80>/' /etc/httpd/conf.d/zabbix.conf
sed -i '/<VirtualHost \*:80>/ a\    DocumentRoot "\/usr\/share\/zabbix"' /etc/httpd/conf.d/zabbix.conf
sed -i '/    DocumentRoot "\/usr\/share\/zabbix"/ a\    ServerName zabbix-server' /etc/httpd/conf.d/zabbix.conf
sed -i '/    ServerName zabbix-server/ a\<\/VirtualHost>' /etc/httpd/conf.d/zabbix.conf

/bin/cp -f /vagrant/zabbix.conf.php /etc/zabbix/web/zabbix.conf.php

#zabbix gateway
yum install zabbix-java-gateway -y
sed -i '/# JavaGateway=/ a\# JavaGateway=127.0.0.1' /etc/zabbix/zabbix_server.conf
sed -i '/# JavaGatewayPort=10052/ a\JavaGatewayPort=10052' /etc/zabbix/zabbix_server.conf
sed -i '/# StartJavaPollers=0/ a\# StartJavaPollers=5' /etc/zabbix/zabbix_server.conf

systemctl start zabbix-java-gateway
systemctl start zabbix-server
systemctl start httpd

systemctl enable zabbix-server
systemctl enable httpd
systemctl enable zabbix-java-gateway
systemctl enable mariadb

echo "+++++++++++++++++++++++++++++"
echo "srv-zabbix now available at $(hostname -I)"
echo "+++++++++++++++++++++++++++++"
