#!/bin/bash

sudo su
yum -y install net-rools
yum -y install http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/zabbix-release-3.2-1.el7.noarch.rpm
yum -y install zabbix-agent
sed -i 's/Server=127.0.0.1/Server=192.168.56.10/g' /etc/zabbix/zabbix_agentd.conf
sed -i 's/ServerActive=127.0.0.1/ServerActive=192.168.56.10:10051/g' /etc/zabbix/zabbix_agentd.conf
sed -i 's;LogFile=/tmp/zabbix_agentd.log;LogFile=/var/log/zabbix/zabbix_agentd.log;g' /etc/zabbix/zabbix_agentd.conf
sed -i ';# PidFile=/tmp/zabbix_agentd.pid; a;PidFile=/var/run/zabbix/zabbix_agentd.pid' /etc/zabbix/zabbix_agentd.conf
yum -y install zabbix-sender
systemctl start zabbix-agent
systemctl enable zabbix-agent