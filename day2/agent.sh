set -x
yum -y install http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/zabbix-release-3.2-1.el7.noarch.rpm
yum -y install zabbix-sender
yum -y install zabbix-agent
sed -i '95aServer=192.168.56.70' /etc/zabbix/zabbix_agentd.conf
sed -i '103aListenPort=10050' /etc/zabbix/zabbix_agentd.conf
sed -i '111aListenIP=0.0.0.0' /etc/zabbix/zabbix_agentd.conf
sed -i '136aServerActive=192.168.56.70' /etc/zabbix/zabbix_agentd.conf
systemctl start zabbix-agent
systemctl enable zabbix-agent
yum -y install tomcat tomcat-webapps -y
sed -i '35a <Listener className="org.apache.catalina.mbeans.JmxRemoteLifecycleListener" rmiRegistryPortPlatform="8097" rmiServerPortPlatform="8098" />' /usr/share/tomcat/conf/server.xml
echo 'JAVA_OPTS="-Dcom.sun.management.jmxremote -Djava.rmi.server.hostname=192.168.56.71 -Dcom.sun.management.jmxremote.local.only=false -Dcom.sun.management.jmxremote.port=8097 -Dcom.sun.management.jmxremote.rmi.port=8098 -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false"' >> /usr/share/tomcat/conf/tomcat.conf
cd /usr/share/tomcat/lib/
wget http://central.maven.org/maven2/org/apache/tomcat/tomcat-catalina-jmx-remote/7.0.69/tomcat-catalina-jmx-remote-7.0.69.jar
cd /usr/share/tomcat/webapps/
wget https://tomcat.apache.org/tomcat-6.0-doc/appdev/sample/sample.war
systemctl start tomcat
systemctl enable tomcat
yum -y install python2-pip.noarch
pip install requests
wget https://raw.githubusercontent.com/marijademenkova/zabbix-tasks/day2/day2/zabbix.py -P /etc/systemd/system/
cat > /etc/systemd/system/zabbix_discovery.service << EOL
[Service]
ExecStart=/bin/python /etc/systemd/system/zabbix.py
EOL
systemctl enable zabbix_discovery.service
systemctl start zabbix_discovery.service
