#!/bin/bash
yum install http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/zabbix-release-3.2-1.el7.noarch.rpm -y --nogpgcheck
yum install zabbix-agent -y --nogpgcheck
sed -i 's/Server=127.0.0.1/Server=192.168.56.10/g' /etc/yum/pluginconf.d/fastestmirror.conf 
sed -i 's/ServerActive=127.0.0.1/ServerActive=192.168.56.10/g' /etc/yum/pluginconf.d/fastestmirror.conf 
systemctl start zabbix-agent
