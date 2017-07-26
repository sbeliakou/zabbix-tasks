#!/bin/bash

echo Installing Zabbix Server

###ZABBIX###
yum install mariadb mariadb-server -y
/usr/bin/mysql_install_db --user=mysql
systemctl start mariadb && systemctl enable mariadb
mysql -uroot -Bse "create database zabbix character set utf8 collate utf8_bin; grant all privileges on zabbix.* to zabbix@localhost identified by 'zabbix';"
yum install http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/zabbix-release-3.2-1.el7.noarch.rpm -y
yum install zabbix-server-mysql zabbix-web-mysql -y
zcat /usr/share/doc/zabbix-server-mysql-*/create.sql.gz | mysql -uzabbix -pzabbix zabbix
cd /etc/zabbix/web && wget https://raw.githubusercontent.com/VadzimTarasiuk/cautious-guacamole/master/zabbix.conf.php && cd -
sed -i 's/# DBHost=localhost/DBHost=localhost/' /etc/zabbix/zabbix_server.conf;
sed -i 's/# DBPassword=/DBPassword=zabbix/' /etc/zabbix/zabbix_server.conf;
yum install http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/zabbix-release-3.2-1.el7.noarch.rpm -y
yum install zabbix-web-mysql -y
sed -i 's@# php_value date.timezone Europe/Riga@php_value date.timezone Europe/Minsk@'  /etc/httpd/conf.d/zabbix.conf
systemctl start httpd && systemctl enable httpd
systemctl enable zabbix-server

###virtual-host###
cp /home/vagrant/vb-share/virtualh.conf /etc/httpd/conf.d/
systemctl restart httpd
