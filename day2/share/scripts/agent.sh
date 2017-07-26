#!/bin/bash

echo Installing Zabbix Agent

yum -y install net-tools
yum -y install python2-pip
pip install requests
yum install -y http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/zabbix-release-3.2-1.el7.noarch.rpm
yum -y install zabbix-agent
rm -f /etc/zabbix/zabbix_agentd.conf
cp /share/zabbix_agentd_agent.conf /etc/zabbix/zabbix_agentd.conf
systemctl start zabbix-agent 
yum -y install tomcat tomcat-webapps
wget -P /usr/share/tomcat/lib/ http://central.maven.org/maven2/org/apache/tomcat/tomcat-catalina-jmx-remote/7.0.69/tomcat-catalina-jmx-remote-7.0.69.jar
sed -i 's;"SHUTDOWN">;"SHUTDOWN"> \
<Listener \
	className="org.apache.catalina.mbeans.JmxRemoteLifecycleListener" \
	rmiRegistryPortPlatform="8097" \
	rmiServerPortPlatform="8098" \
/>;g' /usr/share/tomcat/conf/server.xml

echo 'JAVA_OPTS="-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=12345 -Dcom.sun.management.jmxremote.rmi.port=12346 -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false"' >> /usr/share/tomcat/conf/tomcat.conf
chmod +x /share/scripts/register.py
python /share/scripts/register.py 192.168.56.10/zabbix Admin zabbix CloudHosts "Custom template" Hostname 192.168.56.11

