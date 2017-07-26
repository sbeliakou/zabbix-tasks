#!/bin/bash

echo Installing Zabbix Agent

yum install -y vim;
yum install -y net-tools;
yum -y install http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/zabbix-release-3.2-1.el7.noarch.rpm;
yum -y install zabbix-agent;


sed -i 's|# DebugLevel=3|DebugLevel=3|' /etc/zabbix/zabbix_agentd.conf;
sed -i 's|Server=127.0.0.1|Server=192.168.56.10|' /etc/zabbix/zabbix_agentd.conf;
sed -i 's|# ListenPort=10050|ListenPort=10050|' /etc/zabbix/zabbix_agentd.conf;
sed -i 's|# ListenIP=0.0.0.0|ListenIP=0.0.0.0|' /etc/zabbix/zabbix_agentd.conf;
sed -i 's|# StartAgents=3|StartAgents=3|' /etc/zabbix/zabbix_agentd.conf;
sed -i 's|ServerActive=127.0.0.1|ServerActive=192.168.56.10:10051|' /etc/zabbix/zabbix_agentd.conf;
sed -i 's|Hostname=Zabbix server|Hostname=Zabbix client|' /etc/zabbix/zabbix_agentd.conf;

systemctl start zabbix-agent;
systemctl enable zabbix-agent;


	
#Prepare env
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.131-3.b12.el7_3.x86_64/jre/;
echo "/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.131-3.b12.el7_3.x86_64/jre/" >> /etc/environment;
yum -y install tomcat tomcat-webapps;
wget http://central.maven.org/maven2/org/apache/tomcat/tomcat-catalina-jmx-remote/7.0.69/tomcat-catalina-jmx-remote-7.0.69.jar -P /usr/share/tomcat/lib/;
sed -i '$a JAVA_OPTS="-Dcom.sun.management.jmxremote -Djava.rmi.server.hostname=192.168.56.11 -Dcom.sun.management.jmxremote.local.only=false -Dcom.sun.management.jmxremote.port=12345 -Dcom.sun.management.jmxremote.rmi.port=12346 -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false"' /usr/share/tomcat/conf/tomcat.conf
sed -i '35a  <Listener className="org.apache.catalina.mbeans.JmxRemoteLifecycleListener" rmiRegistryPortPlatform="8097" rmiServerPortPlatform="8098" />' /usr/share/tomcat/conf/server.xml
systemctl start tomcat;

#Loading python modules for script:
yum  -y install python2-pip.noarch
pip install requests

#Dowloading python registration script
wget https://raw.githubusercontent.com/SuperBazis/zabbix-tasks/atsuranauD2/day2/scripts/zabbixregistration.py -P /home/vagrant/
chmod +x /home/vagrant/zabbixregistration.py

touch /etc/systemd/system/zabbixreg.service
chmod 664 /etc/systemd/system/zabbixreg.service
#Making systemd init file for python registration script
cat >/etc/systemd/system/zabbixreg.service << 'EOL'
[Unit]
After=network.target

[Service]
ExecStart=/usr/bin/python /home/vagrant/zabbixregistration.py
Type=forking
PIDFile=path_to_pidfile

[Install]
WantedBy=default.target
EOL
#Starting systemd init file for python registration script
systemctl daemon-reload
systemctl start zabbixreg.service

#Installing, starting httpd
yum -y install httpd
systemctl start httpd
systemctl enable httpd





