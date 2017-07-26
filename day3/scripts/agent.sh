#!/bin/bash

echo "***********Running agent.sh script***********"
echo "***********Install Zabbix Repo***********"
yum install http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/zabbix-release-3.2-1.el7.noarch.rpm -y

echo "***********Installing Zabbix Agent***********"
yum install zabbix-agent -y

echo "***********Configuring Zabbix Agent***********"
sed -i 's/Server=127.0.0.1/Server=192.168.56.10/' /etc/zabbix/zabbix_agentd.conf
sed -i 's/ServerActive=127.0.0.1/ServerActive=192.168.56.10/' /etc/zabbix/zabbix_agentd.conf
sed -i 's/Hostname=Zabbix server/Hostname=host-agent1/' /etc/zabbix/zabbix_agentd.conf

echo "***********Starting and Enabling Zabbix Agent service***********"
systemctl enable zabbix-agent
systemctl start zabbix-agent

echo "***********Installing Tomcat and Apps***********"
yum install tomcat tomcat-webapps -y
yum install net-tools -y
cp /vagrant/hello.war /usr/share/tomcat/webapps/

echo "***********Starting and Enabling Tomcat***********"
systemctl enable tomcat
systemctl start tomcat

echo "***********Installing and Configure Apache HTTP Server***********"
yum install httpd -y
sed -i '/IncludeOptional conf.d\/\*.conf/ a\ProxyPass \/ http:\/\/127.0.0.1:8080\/' /etc/httpd/conf/httpd.conf

echo "***********Starting and Enabling Apache HTTP Server***********"
systemctl enable httpd
systemctl start httpd
