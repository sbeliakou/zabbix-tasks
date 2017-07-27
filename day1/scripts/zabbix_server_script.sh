yum install mariadb mariadb-server -y
/usr/bin/mysql_install_db --user=mysql
systemctl start mariadb
systemctl enable mariadb
mysql -uroot <<QUERY
create database zabbix character set utf8 collate utf8_bin; 
grant all privileges on zabbix.* to zabbix@localhost identified by 'password';
quit;
QUERY
yum install http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/zabbix-release-3.2-1.el7.noarch.rpm -y
yum install zabbix-server-mysql zabbix-web-mysql -y
zcat /usr/share/doc/zabbix-server-mysql-*/create.sql.gz | mysql -uzabbix -ppassword zabbix
awk '{gsub("# DBPassword=","DBPassword=password")}{print}' /etc/zabbix/zabbix_server.conf > tmp
mv -uf tmp /etc/zabbix/zabbix_server.conf
mv -uf zabbix.conf.php /etc/zabbix/web/zabbix.conf.php
systemctl start zabbix-server
systemctl enable zabbix-server
awk '{gsub("# php_value date.timezone Europe/Riga","php_value date.timezone Europe/Minsk")}{print}' /etc/httpd/conf.d/zabbix.conf > tmp
mv -uf tmp /etc/httpd/conf.d/zabbix.conf
echo "  <VirtualHost *:80>
  DocumentRoot "/usr/share/zabbix"
  </VirtualHost>
" >> /etc/httpd/conf/httpd.conf
systemctl start httpd
systemctl enable httpd
