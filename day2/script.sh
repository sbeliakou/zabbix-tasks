# Installing and configuring MySQL DB (MariaDB)
yum install mariadb mariadb-server -y
/usr/bin/mysql_install_db --user=mysql
systemctl enable mariadb
systemctl start mariadb
mysql -uroot -Bse "create database zabbix character set utf8 collate utf8_bin; 
grant all privileges on zabbix.* to zabbix@localhost identified by 'zabbix';"
# Installing and configuring Zabbix Server
yum install http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/zabbix-release-3.2-1.el7.noarch.rpm -y
yum install zabbix-server-mysql zabbix-web-mysql -y
zcat /usr/share/doc/zabbix-server-mysql-*/create.sql.gz | mysql -uzabbix -pzabbix zabbix
sed -i 's/# DBHost=localhost/DBHost=localhost/g' /etc/zabbix/zabbix_server.conf
sed -i 's/# DBPassword=/DBPassword=zabbix/g' /etc/zabbix/zabbix_server.conf

# preconfig /etc/zabbix/web/zabbix.conf.php
touch /etc/zabbix/web/zabbix.conf.php
cat >/etc/zabbix/web/zabbix.conf.php << 'EOL'
<?php
// Zabbix GUI configuration file.
global $DB;

$DB['TYPE']     = 'MYSQL';
$DB['SERVER']   = 'localhost';
$DB['PORT']     = '3306';
$DB['DATABASE'] = 'zabbix';
$DB['USER']     = 'zabbix';
$DB['PASSWORD'] = 'zabbix';

// Schema name. Used for IBM DB2 and PostgreSQL.
$DB['SCHEMA'] = '';

$ZBX_SERVER      = 'localhost';
$ZBX_SERVER_PORT = '10051';
$ZBX_SERVER_NAME = 'Zabbix server';

$IMAGE_FORMAT_DEFAULT = IMAGE_FORMAT_PNG;
EOL
systemctl enable zabbix-server
systemctl start zabbix-server

cat >/etc/httpd/conf.d/zabbix.conf << 'EOI'
<VirtualHost *:80>
    DocumentRoot "/usr/share/zabbix"
    ServerName 192.168.56.10

<Directory "/usr/share/zabbix">
    Options FollowSymLinks
    AllowOverride None
    Require all granted

    <IfModule mod_php5.c>
        php_value max_execution_time 300
        php_value memory_limit 128M
        php_value post_max_size 16M
        php_value upload_max_filesize 2M
        php_value max_input_time 300
        php_value always_populate_raw_post_data -1
        php_value date.timezone Europe/Minsk
    </IfModule>
</Directory>

<Directory "/usr/share/zabbix/conf">
    Require all denied
</Directory>

<Directory "/usr/share/zabbix/app">
    Require all denied
</Directory>

<Directory "/usr/share/zabbix/include">
    Require all denied
</Directory>

<Directory "/usr/share/zabbix/local">
    Require all denied
</Directory>

</VirtualHost>
EOI

systemctl restart httpd

#Installing zabbix-agent
#yum install http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/zabbix-release-3.2-1.el7.noarch.rpm -y
#yum install zabbix-web-mysql -y

yum install zabbix-agent -y
systemctl enable zabbix-agent
systemctl start zabbix-agent
yum install zabbix-sender -y
yum install zabbix-get -y

#yum install zabbix-java-gateway -y
#systemctl start zabbix-java-gateway
#systemctl enable zabbix-java-gateway




