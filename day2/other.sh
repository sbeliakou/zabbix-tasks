yum install zip unzip net-tools vim tomcat tomcat-webapps -y

###TOMCAT###
sed -i '/#JAVA_OPTS="-Xminf0.1 -Xmaxf0.3"/a JAVA_OPTS="-Dcom.sun.management.jmxremote -Djava.rmi.server.hostname=111.111.11.12 -Dcom.sun.management.jmxremote.local.only=false -Dcom.sun.management.jmxremote.port=12345 -Dcom.sun.management.jmxremote.rmi.port=12346 -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false"' /etc/tomcat/tomcat.conf;
sed -i '/<Listener className="org.apache.catalina.core.ThreadLocalLeakPreventionListener" \/>/a <Listener className="org.apache.catalina.mbeans.JmxRemoteLifecycleListener" rmiRegistryPortPlatform="8097" rmiServerPortPlatform="8098"\/>' /etc/tomcat/server.xml
cd /usr/share/java/tomcat && wget  http://ftp.byfly.by/pub/apache.org/tomcat/tomcat-7/v7.0.79/bin/extras/catalina-jmx-remote.jar && cd -
systemctl enable tomcat
systemctl start tomcat

###Z-AGENT###
yum install http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/zabbix-release-3.2-1.el7.noarch.rpm -y
yum install zabbix-agent -y
sed -i 's/# HostnameItem=system.hostname/HostnameItem=system.hostname/' /etc/zabbix/zabbix_agentd.conf
sed -i 's/ServerActive=127.0.0.1/ServerActive=111.111.11.11/' /etc/zabbix/zabbix_agentd.conf
sed -i 's/Server=127.0.0.1/Server=111.111.11.11/' /etc/zabbix/zabbix_agentd.conf
sed -i 's/# ListenPort=10050/ListenPort=10050/' /etc/zabbix/zabbix_agentd.conf
sed -i 's/# ListenIP=0.0.0.0/ListenIP=0.0.0.0/' /etc/zabbix/zabbix_agentd.conf
sed -i 's/# StartAgents=3/StartAgents=3/' /etc/zabbix/zabbix_agentd.conf
systemctl start zabbix-agent
