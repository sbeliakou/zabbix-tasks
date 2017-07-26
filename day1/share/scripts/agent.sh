#!/bin/bash

echo Installing Zabbix Agent

yum install -y http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/zabbix-release-3.2-1.el7.noarch.rpm
yum -y install zabbix-agent
rm -f /etc/zabbix/zabbix_agentd.conf
yum -y install zabbix-sender
cp /share/zabbix_agentd_agent.conf /etc/zabbix/zabbix_agentd.conf
systemctl start zabbix-agent 
