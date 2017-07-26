#!/bin/bash

echo "***********Running agent.sh script***********"
echo "***********Install Zabbix Repo***********"
yum install http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/zabbix-release-3.2-1.el7.noarch.rpm -y

echo "***********Installing Zabbix Agent and Tools***********"
yum install zabbix-agent -y
yum install zabbix-sender -y
yum install zabbix-get -y

echo "***********Configuring Zabbix Agent***********"
if [ "$HOSTNAME" = host-agent1 ]
then
	sed -i 's/Server=127.0.0.1/Server=192.168.56.10/' /etc/zabbix/zabbix_agentd.conf
	sed -i 's/ServerActive=127.0.0.1/ServerActive=192.168.56.10/' /etc/zabbix/zabbix_agentd.conf
        sed -i 's/Hostname=Zabbix server/Hostname=host-agent1/' /etc/zabbix/zabbix_agentd.conf
	echo "zabbix agent parameters have been changed"

else
        echo "hostname is not 'host-agent1'"
fi

echo "***********Starting and enabling Zabbix Agent service***********"
systemctl enable zabbix-agent
systemctl start zabbix-agent
