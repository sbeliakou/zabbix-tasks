#!/bin/bash

echo "====> Provision-script started! "

echo "===> Installing Zabbix Agent"
yum install -y http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/zabbix-release-3.2-1.el7.noarch.rpm
yum install -y zabbix-agent
echo "==> Starting Zabbix Agent"
systemctl start zabbix-agent

echo "==> Passive checks "
sed -i '/DebugLevel=3/s/^#//g' /etc/zabbix/zabbix_agentd.conf

sed -i '/Server=127.0.0.1/c\Server=1.1.1.1' /etc/zabbix/zabbix_agentd.conf
sed -i '/ListenPort=10050/s/^#//g' /etc/zabbix/zabbix_agentd.conf
sed -i '/ListenIP=0.0.0.0/s/^#//g' /etc/zabbix/zabbix_agentd.conf
sed -i '/StartAgents=3/s/^#//g' /etc/zabbix/zabbix_agentd.conf

echo "==> Active checks "
sed -i '/ServerActive=127.0.0.1/c\ServerActive=1.1.1.1' /etc/zabbix/zabbix_agentd.conf
sed -i '/HostnameItem=system.hostname/s/^#//g' /etc/zabbix/zabbix_agentd.conf

echo "==> Installing Zabbix sender"
yum install zabbix-sender

echo "==> Installing zabbix get"
yum install -y zabbix-get
