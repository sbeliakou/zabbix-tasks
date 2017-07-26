#!/bin/sh

# Installing zabbix agent, TOMCAT, Java and some cool staff
echo "Zabbix Agent Installation"
yum install -y vim;
yum install -y net-tools;
yum install -y http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/zabbix-release-3.2-1.el7.noarch.rpm
yum install -y zabbix-agent;
yum install -y tomcat;
yum install -y tomcat-webapps;
yum install -y java-1.8.0-openjdk-devel.x86_64;
yum install -y httpd
# Tuning JAVA
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.141-1.b16.el7_3.x86_64/jre/

# Edit agent conf files
sed -i 's/# DebugLevel=3/DebugLevel=3/' /etc/zabbix/zabbix_agentd.conf;
sed -i 's/Server=127.0.0.1/Server=192.168.56.10/' /etc/zabbix/zabbix_agentd.conf;
sed -i 's/# ListenPort=10050/ListenPort=10050/' /etc/zabbix/zabbix_agentd.conf;
sed -i 's/# ListenIP=0.0.0.0/ListenIP=0.0.0.0/' /etc/zabbix/zabbix_agentd.conf;
sed -i 's/# StartAgents=3/StartAgents=3/' /etc/zabbix/zabbix_agentd.conf;
sed -i 's/ServerActive=127.0.0.1/ServerActive=192.168.56.10:10051/' /etc/zabbix/zabbix_agentd.conf;
sed -i 's/Hostname=Zabbix server/Hostname=Zabbix client/' /etc/zabbix/zabbix_agentd.conf;

# Starting agent/Check if started
echo "Zabbix Agent starting..."
systemctl start zabbix-agent;
sleep 2;
if pgrep -x "zabbix_agentd" > /dev/null
then
    echo "AGENT IS RUNNING"
else
    echo "AGENT IS STOPPED"
fi

#starting services
systemctl start tomcat
systemctl enable tomcat
systemctl start httpd
systemctl enable httpd
