#!/bin/bash

#agent
yum install http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/zabbix-release-3.2-1.el7.noarch.rpm -y
yum install zabbix-agent -y

if [ "$HOSTNAME" = zabbix-client ]; then
  sed -i 's/Server=127.0.0.1/Server=192.168.56.105/g' /etc/zabbix/zabbix_agentd.conf
  sed -i 's/ServerActive=127.0.0.1/ServerActive=192.168.56.105/g' /etc/zabbix/zabbix_agentd.conf
  firewall-cmd --zone=public --add-port=10050/tcp --permanent
  firewall-cmd --reload
fi

systemctl start zabbix-agent
systemctl enable zabbix-agent
