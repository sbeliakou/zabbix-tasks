#!/bin/bash
set -x
#agent
yum install http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/zabbix-release-3.2-1.el7.noarch.rpm -y
yum install zabbix-agent -y

if [ "$HOSTNAME" = zabbix-client ]; then
  sed -i 's/Server=127.0.0.1/Server=192.168.56.105/g' /etc/zabbix/zabbix_agentd.conf
  sed -i 's/ServerActive=127.0.0.1/ServerActive=192.168.56.105/g' /etc/zabbix/zabbix_agentd.conf
  firewall-cmd --zone=public --add-port=10050/tcp --permanent
  firewall-cmd --reload
  yum install tomcat -y
  yum install tomcat-webapps -y

  wget http://ftp.byfly.by/pub/apache.org/tomcat/tomcat-7/v7.0.79/bin/extras/catalina-jmx-remote.jar -P /usr/share/tomcat/lib/

  sed -i '/ThreadLocalLeakPreventionListener/ a\<Listener className="org.apache.catalina.mbeans.JmxRemoteLifecycleListener" rmiRegistryPortPlatform="8097" rmiServerPortPlatform="8098" \/>' /usr/share/tomcat/conf/server.xml
  sed -i '/#JAVA_OPTS="-Xminf0.1 -Xmaxf0.3"/ a\JAVA_OPTS="-Dcom.sun.management.jmxremote -Djava.rmi.server.hostname=192.168.56.106 -Dcom.sun.management.jmxremote.local.only=false -Dcom.sun.management.jmxremote.port=12345 -Dcom.sun.management.jmxremote.rmi.port=12346 -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false"' /usr/share/tomcat/conf/tomcat.conf

  systemctl start tomcat
  systemctl enable tomcat
  yum install python2-pip -y
  pip install requests
  python /vagrant/scripts/add_host.py '192.168.56.105' 'zabbix-client'
fi

systemctl start zabbix-agent
systemctl enable zabbix-agent
