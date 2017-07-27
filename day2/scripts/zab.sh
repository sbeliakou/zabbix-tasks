yum install zip unzip net-tools vim -y

echo "111.111.11.12 tomcat" >> /etc/hosts

###ZABBIX###
yum install mariadb mariadb-server -y
/usr/bin/mysql_install_db --user=mysql
systemctl start mariadb && systemctl enable mariadb
mysql -uroot -Bse "create database zabbix character set utf8 collate utf8_bin; grant all privileges on zabbix.* to zabbix@localhost identified by 'zabbix';"
yum install http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/zabbix-release-3.2-1.el7.noarch.rpm -y
yum install zabbix-server-mysql zabbix-web-mysql -y
zcat /usr/share/doc/zabbix-server-mysql-*/create.sql.gz | mysql -uzabbix -pzabbix zabbix
cp /home/vagrant/vb-share/zabbix.conf.php /etc/zabbix/web 
sed -i 's/# DBHost=localhost/DBHost=localhost/' /etc/zabbix/zabbix_server.conf;
sed -i 's/# DBPassword=/DBPassword=zabbix/' /etc/zabbix/zabbix_server.conf;
yum install http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/zabbix-release-3.2-1.el7.noarch.rpm -y
yum install zabbix-web-mysql -y
sed -i 's@# php_value date.timezone Europe/Riga@php_value date.timezone Europe/Minsk@'  /etc/httpd/conf.d/zabbix.conf
systemctl start httpd && systemctl enable httpd
systemctl enable zabbix-server

###J-GATE###
yum install zabbix-java-gateway -y
sed -i 's/# JavaGateway=/JavaGateway=111.111.11.11/' /etc/zabbix/zabbix_server.conf;
sed -i 's/# JavaGatewayPort=10052/JavaGatewayPort=10052/' /etc/zabbix/zabbix_server.conf;
sed -i 's/# StartJavaPollers=0/StartJavaPollers=5/' /etc/zabbix/zabbix_server.conf;	
systemctl start zabbix-java-gateway && systemctl enable zabbix-java-gateway
systemctl restart zabbix-server
	
###Z-AGENT###
yum install http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/zabbix-release-3.2-1.el7.noarch.rpm -y
yum install zabbix-agent -y
sed -i 's/# HostnameItem=system.hostname/HostnameItem=system.hostname/' /etc/zabbix/zabbix_agentd.conf
sed -i 's/ServerActive=127.0.0.1/ServerActive=111.111.11.11/' /etc/zabbix/zabbix_agentd.conf
sed -i 's/Server=127.0.0.1/Server=111.111.11.11/' /etc/zabbix/zabbix_agentd.conf
sed -i 's/# ListenPort=10050/ListenPort=10050/' /etc/zabbix/zabbix_agentd.conf
sed -i 's/# ListenIP=0.0.0.0/ListenIP=0.0.0.0/' /etc/zabbix/zabbix_agentd.conf
sed -i 's/# StartAgents=3/StartAgents=3/' /etc/zabbix/zabbix_agentd.conf
systemctl start zabbix-agent && systemctl enable zabbix-agent
	
###virtual-host###
cp /home/vagrant/vb-share/virtualh.conf /etc/httpd/conf.d/
systemctl restart httpd
