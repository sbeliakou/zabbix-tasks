#!/bin/bash
yum install http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/zabbix-release-3.2-1.el7.noarch.rpm -y --nogpgcheck
yum install zabbix-agent -y --nogpgcheck
sed -i 's/Server=127.0.0.1/Server=192.168.56.10/g' /etc/zabbix/zabbix_agentd.conf 
sed -i 's/ServerActive=127.0.0.1/ServerActive=192.168.56.10/g' /etc/zabbix/zabbix_agentd.conf
systemctl start zabbix-agent

yum -y install python-pip
sudo pip install requests
wget https://raw.githubusercontent.com/Asemirski/zabbix-tasks/asd2/day2/hostCreator.py
chmod +x hostCreator.py
python hostCreator.py