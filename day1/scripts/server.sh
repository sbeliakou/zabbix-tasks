!/bin/bash
rpm -qa | grep mariadb-server >> /tmp/t1.txt
sed -i 's/enabled=1/enabled=0/g' /etc/yum/pluginconf.d/fastestmirror.conf 


echo "downloading and stting up mariadb"
yum install mariadb mariadb-server -y --nogpgcheck
/usr/bin/mysql_install_db --user=mysql
systemctl start mariadb
mysql -uroot <<DBINPUT
create database zabbix character set utf8 collate utf8_bin; 
grant all privileges on zabbix.* to zabbix@localhost identified by 'root';
DBINPUT

yum install http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/zabbix-release-3.2-1.el7.noarch.rpm -y --nogpgcheck
yum install zabbix-server-mysql zabbix-web-mysql -y --nogpgcheck
zcat /usr/share/doc/zabbix-server-mysql-*/create.sql.gz | mysql -uzabbix -proot zabbix
sed -i 's/# DBPassword=/DBPassword=root/g' /etc/zabbix/zabbix_server.conf
systemctl start zabbix-server 

sed -i '/always_populate_raw_post_data -1/a php_value date.timezone Europe\/Minsk' /etc/httpd/conf.d/zabbix.conf 
echo "<?php
// Zabbix GUI configuration file.
global \$DB;

\$DB['TYPE']     = 'MYSQL';
\$DB['SERVER']   = 'localhost';
\$DB['PORT']     = '0';
\$DB['DATABASE'] = 'zabbix';
\$DB['USER']     = 'zabbix';
\$DB['PASSWORD'] = 'root';

// Schema name. Used for IBM DB2 and PostgreSQL.

\$DB['SCHEMA'] = '';
\$ZBX_SERVER      = 'localhost';
\$ZBX_SERVER_PORT = '10051';
\$ZBX_SERVER_NAME = 'Zabbix Server';

\$IMAGE_FORMAT_DEFAULT = IMAGE_FORMAT_PNG;
" > /etc/zabbix/web/zabbix.conf.php
echo "<VirtualHost 192.168.56.10>
	DocumentRoot "/usr/share/zabbix"
</VirtualHost>
" >> /etc/httpd/conf/httpd.conf
systemctl start httpd
