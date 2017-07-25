#!/bin/bash

echo Installing Tomcat Server

sudo su
yum install tomcat -y
yum -y install tomcat tomcat-webapps -y

sed -i '/Type=simple/ a\Environment="JAVA_OPTS=-Dcom.sun.management.jmxremote -Djava.rmi.server.hostname=192.168.56.11 -Dcom.sun.management.jmxremote.local.only=false -Dcom.sun.management.jmxremote.port=12345 -Dcom.sun.management.jmxremote.rmi.port=12346 -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false"' /usr/lib/systemd/system/tomcat.service

sed -i '/<Server port="8005" shutdown="SHUTDOWN">/ a\<Listener className="org.apache.catalina.mbeans.JmxRemoteLifecycleListener" rmiRegistryPortPlatform="8097" rmiServerPortPlatform="8098"/>' /usr/share/tomcat/conf/server.xml

wget -P /usr/share/tomcat/lib/ http://ftp.byfly.by/pub/apache.org/tomcat/tomcat-7/v7.0.79/bin/extras/catalina-jmx-remote.jar

systemctl daemon-reload
systemctl enable tomcat
systemctl start tomcat

