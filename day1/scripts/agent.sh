#!/bin/bash

echo Installing Zabbix Agent

yum install -y vim;
yum install -y net-tools;
yum -y install http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/zabbix-release-3.2-1.el7.noarch.rpm;
yum -y install zabbix-agent;


sed -i 's|# DebugLevel=3|DebugLevel=3|' /etc/zabbix/zabbix_agentd.conf;
sed -i 's|Server=127.0.0.1|Server=192.168.56.10|' /etc/zabbix/zabbix_agentd.conf;
sed -i 's|# ListenPort=10050|ListenPort=10050|' /etc/zabbix/zabbix_agentd.conf;
sed -i 's|# ListenIP=0.0.0.0|ListenIP=0.0.0.0|' /etc/zabbix/zabbix_agentd.conf;
sed -i 's|# StartAgents=3|StartAgents=3|' /etc/zabbix/zabbix_agentd.conf;
sed -i 's|ServerActive=127.0.0.1|ServerActive=192.168.56.10:10051|' /etc/zabbix/zabbix_agentd.conf;
sed -i 's|Hostname=Zabbix server|Hostname=Zabbix client|' /etc/zabbix/zabbix_agentd.conf;

systemctl start zabbix-agent;
yum -y install zabbix-sender;
yum -y install zabbix-get;

