#!/bin/bash
sudo su
yum install tomcat -y;
yum -y install tomcat tomcat-webapps -y;

echo 'JAVA_OPTS=" -Dcom.sun.management.jmxremote -Djava.rmi.server.hostname=192.168.56.11 -Dcom.sun.management.jmxremote.local.only=false -Dcom.sun.management.jmxremote.port=12345 -Dcom.sun.management.jmxremote.rmi.port=12346 -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false" ' > /etc/tomcat/tomcat.conf;
sed -i '/Listener className="org.apache.catalina.core.ThreadLocalLeakPreventionListener"/ a\  <Listener className="org.apache.catalina.mbeans.JmxRemoteLifecycleListener" rmiRegistryPortPlatform="8097" rmiServerPortPlatform="8098" />' /etc/tomcat/server.xml

sudo wget http://central.maven.org/maven2/org/apache/tomcat/tomcat-catalina-jmx-remote/7.0.4/tomcat-catalina-jmx-remote-7.0.4.jar;
cp tomcat-catalina-jmx-remote-7.0.4.jar /usr/share/tomcat/lib/;

systemctl enable tomcat;
systemctl start tomcat;


