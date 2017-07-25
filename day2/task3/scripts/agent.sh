#!/bin/bash
yum install vim -y;
yum install http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/zabbix-release-3.2-1.el7.noarch.rpm -y;
yum install zabbix-agent -y;
yum install zabbix-sender -y;
sed -i '57 s/# DebugLevel=3/DebugLevel=3/' /etc/zabbix/zabbix_agentd.conf
sed -i '136 s/ServerActive=127.0.0.1/ServerActive=192.168.56.10/' /etc/zabbix/zabbix_agentd.conf
sed -i '95 s/Server=127.0.0.1/Server=192.168.56.10/' /etc/zabbix/zabbix_agentd.conf
yum update -y;
yum install python-pip -y;
sudo pip install requests
wget https://raw.githubusercontent.com/alexeikorzhov/zabbix-tasks/akarzhou/day2/task3/111.py
chmod +x 111.py
python 111.py

systemctl start zabbix-agent



