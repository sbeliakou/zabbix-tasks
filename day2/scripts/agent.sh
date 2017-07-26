#!/bin/bash

echo Installing Zabbix Agent
yum -y install http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/zabbix-release-3.2-1.el7.noarch.rpm
yum -y install zabbix-sender
yum -y install zabbix-agent
yum -y install python2-pip.noarch
pip install requests

sed -i -e 's:127.0.0.1:192.168.56.10:g' /etc/zabbix/zabbix_agentd.conf
sed -i '93aServer=192.168.56.10' /etc/zabbix/zabbix_agentd.conf
sed -i '103aListenPort=10050' /etc/zabbix/zabbix_agentd.conf 
sed -i '112aListenIP=0.0.0.0' /etc/zabbix/zabbix_agentd.conf
sed -i '122aStartAgents=3' /etc/zabbix/zabbix_agentd.conf

wget https://raw.githubusercontent.com/SVLay/zabbix-tasks/day2/day2/register_host.py -P /etc/systemd/system/
cat > /etc/systemd/system/register_host.service << EOL
[Service]
ExecStart=/bin/python /etc/systemd/system/register_host.py
EOL
systemctl enable register_host.service
systemctl start register_host.service

systemctl start zabbix-agent
systemctl enable zabbix-agent

yum -y install tomcat tomcat-webapps
sed -i '$a JAVA_OPTS="-Dcom.sun.management.jmxremote -Djava.rmi.server.hostname=192.168.56.11 -Dcom.sun.management.jmxremote.local.only=false -Dcom.sun.management.jmxremote.port=12345 -Dcom.sun.management.jmxremote.rmi.port=12346 -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false"' /usr/share/tomcat/conf/tomcat.conf
sed -i '35a <Listener className="org.apache.catalina.mbeans.JmxRemoteLifecycleListener" rmiRegistryPortPlatform="8097" rmiServerPortPlatform="8098" />' /usr/share/tomcat/conf/server.xml
wget http://central.maven.org/maven2/org/apache/tomcat/tomcat-catalina-jmx-remote/7.0.4/tomcat-catalina-jmx-remote-7.0.4.jar -P /usr/share/tomcat/lib
systemctl start tomcat
systemctl enable tomcat


