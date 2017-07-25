#!/bin/bash

echo "###Install zabbix agent###"

yum install http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/zabbix-release-3.2-1.el7.noarch.rpm -y > /dev/null
yum install zabbix-agent -y > /dev/null

sed -i 's@# DebugLevel@DebugLevel@' /etc/zabbix/zabbix_agentd.conf
sed -i 's@Server=127.0.0.1@Server=192.168.56.10@' /etc/zabbix/zabbix_agentd.conf
sed -i 's@ServerActive=127.0.0.1@ServerActive=192.168.56.10@' /etc/zabbix/zabbix_agentd.conf
sed -i 's@# ListenPort=10050@ListenPort=10050@' /etc/zabbix/zabbix_agentd.conf
sed -i 's@Hostname=Zabbix server@Hostname=zabbix1@' /etc/zabbix/zabbix_agentd.conf

systemctl start zabbix-agent
systemctl enable zabbix-agent

echo "### Install Tomcat 7 ###"
yum install tomcat tomcat-webapps -y
curl http://central.maven.org/maven2/org/apache/tomcat/tomcat-catalina-jmx-remote/7.0.4/tomcat-catalina-jmx-remote-7.0.4.jar -o /usr/share/tomcat/lib/tomcat-catalina-jmx-remote-7.0.4.jar
sed -i '/<Listener className="org.apache.catalina.core.ThreadLocalLeakPreventionListener" \/>/a\
  <Listener className="org.apache.catalina.mbeans.JmxRemoteLifecycleListener" rmiRegistryPortPlatform="8097" rmiServerPortPlatform="8098" \/>' /etc/tomcat/server.xml
sed -i '/#JAVA_OPTS="-Xminf0.1 -Xmaxf0.3"/a\
JAVA_OPTS="-Dcom.sun.management.jmxremote -Djava.rmi.server.hostname=192.168.56.11 -Dcom.sun.management.jmxremote.local.only=false -Dcom.sun.management.jmxremote.port=12345 -Dcom.sun.management.jmxremote.rmi.port=12346 -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false"' /etc/tomcat/tomcat.conf
systemctl start tomcat
systemctl enable tomcat

echo "### Install Zabbix Java Gateway ###"
yum install zabbix-java-gateway
systemctl start zabbix-java-gateway
systemctl enable zabbix-java-gateway

echo "### Install python modules ###"
wget https://bootstrap.pypa.io/get-pip.py -P /tmp
python /tmp/get-pip.py
pip install requests

echo "### Download and run python script ###"




