#!/bin/bash

echo Installing Zabbix Agent
yum -y install http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/zabbix-release-3.2-1.el7.noarch.rpm
yum -y install zabbix-sender
yum -y install zabbix-agent
sed -i -e 's:127.0.0.1:192.168.56.11:g' /etc/zabbix/zabbix_agentd.conf

systemctl start zabbix-agent
systemctl enable zabbix-agent
