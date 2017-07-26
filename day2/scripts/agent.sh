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
wget http://central.maven.org/maven2/org/apache/tomcat/tomcat-catalina-jmx-remote/7.0.79/tomcat-catalina-jmx-remote-7.0.79.jar
cp tomcat-catalina-jmx-remote-7.0.79.jar /usr/share/tomcat/lib/
wget https://netix.dl.sourceforge.net/project/cyclops-group/jmxterm/1.0-alpha-4/jmxterm-1.0-alpha-4-uber.jar
cp jmxterm-1.0-alpha-4-uber.jar /usr/share/tomcat/bin
cp /vagrant/hello.war /usr/share/tomcat/webapps/

echo "***********Configuring JMX***********"
sed -i '/<Listener className="org.apache.catalina.core.ThreadLocalLeakPreventionListener" \/>/ a\  <Listener className="org.apache.catalina.mbeans.JmxRemoteLifecycleListener" rmiRegistryPortPlatform="8097" rmiServerPortPlatform="8098" \/>' /usr/share/tomcat/conf/server.xml
sed -i '/#JAVA_OPTS="-Xminf0.1 -Xmaxf0.3"/ a\JAVA_OPTS="-Dcom.sun.management.jmxremote -Djava.rmi.server.hostname=192.168.56.11 -Dcom.sun.management.jmxremote.port=12345 -Dcom.sun.management.jmxremote.rmi.port=12346 -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.local.only=false"' /usr/share/tomcat/conf/tomcat.conf

echo "***********Starting and Enabling Tomcat***********"
systemctl enable tomcat
systemctl start tomcat

echo "***********Running Python script***********"
yum install python2-pip -y
pip install requests
python /vagrant/scripts/zabbix.py 192.168.56.11
