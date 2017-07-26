#!/bin/bash

sudo su

yum -y install tomcat

cd /usr/share/tomcat/lib
wget http://central.maven.org/maven2/org/apache/tomcat/tomcat-catalina-jmx-remote/7.0.4/tomcat-catalina-jmx-remote-7.0.4.jar

sed -i '/Type=simple/ a\Environment="JAVA_OPTS=-Dcom.sun.management.jmxremote -Djava.rmi.server.hostname=192.168.56.11 -Dcom.sun.management.jmxremote.local.only=false -Dcom.sun.management.jmxremote.port=12345 -Dcom.sun.management.jmxremote.rmi.port=12346 -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false"' /usr/lib/systemd/system/tomcat.service

sed -i '/<Server port="8005" shutdown="SHUTDOWN">/ a\  <Listener className="org.apache.catalina.mbeans.JmxRemoteLifecycleListener" rmiRegistryPortPlatform="8097" rmiServerPortPlatform="8098"/>' /usr/share/tomcat/conf/server.xml

systemctl enable tomcat
systemctl start tomcat

yum -y install tomcat-webapps
