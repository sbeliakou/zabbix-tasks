#!/bin/bash

echo "###Install zabbix agent###"

yum install http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/zabbix-release-3.2-1.el7.noarch.rpm -y > /dev/null
yum install zabbix-agent -y > /dev/null

sed -i 's@# DebugLevel@DebugLevel@' /etc/zabbix/zabbix_agentd.conf
sed -i 's@Server=127.0.0.1@Server=192.168.56.10@' /etc/zabbix/zabbix_agentd.conf
sed -i 's@ServerActive=127.0.0.1@ServerActive=192.168.56.10@' /etc/zabbix/zabbix_agentd.conf
sed -i 's@# ListenPort=10050@ListenPort=10050@' /etc/zabbix/zabbix_agentd.conf
sed -i 's@Hostname=Zabbix server@Hostname=zabbix1@' /etc/zabbix/zabbix_agentd.conf

echo "### Install python modules ###"
wget https://bootstrap.pypa.io/get-pip.py -P /tmp
python /tmp/get-pip.py
pip install requests

echo "### Download and run python scripts ###"
wget https://raw.githubusercontent.com/untiro/zabbix-tasks/yshchanouski3/day3/scripts/script.py -P /tmp
wget https://raw.githubusercontent.com/untiro/zabbix-tasks/yshchanouski3/day3/scripts/change_host_status.py -P /tmp
python /tmp/script.py

echo "### Making changes to zabbix agent systemd unit file ###"
sed -i '/ExecStart=\/usr\/sbin\/zabbix_agentd -c $CONFFILE/a\
ExecStartPost=/usr/bin/python /tmp/change_host_status.py 0' /usr/lib/systemd/system/zabbix-agent.service  
sed -i '/ExecStop=\/bin\/kill -SIGTERM $MAINPID/a\
ExecStopPost=/usr/bin/python /tmp/change_host_status.py 1' /usr/lib/systemd/system/zabbix-agent.service
systemctl daemon-reload
systemctl start zabbix-agent
cat /tmp/change_host_status.log
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

echo "### Install and configure httpd ###"
yum install httpd -y > /dev/null
cat << 'EOT' > /etc/httpd/conf.d/tomcat-host.conf
<VirtualHost *:80>
  <Location />
        ProxyPass http://localhost:8080/
        Order allow,deny
        Allow from all
  </Location>
</VirtualHost>
EOT
	systemctl start httpd
	systemctl enable httpd

echo "### Install Zabbix Java Gateway ###"
yum install zabbix-java-gateway -y > /dev/null
systemctl start zabbix-java-gateway
systemctl enable zabbix-java-gateway
