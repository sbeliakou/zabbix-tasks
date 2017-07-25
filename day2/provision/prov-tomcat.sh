#!/bin/bash

echo "====> Provision-script started! "

echo "==> Installing Tomcat"
yum install tomcat tomcat-webapps -y

echo "==> Downloading jmx-remote"
curl http://central.maven.org/maven2/org/apache/tomcat/tomcat-catalina-jmx-remote/7.0.4/tomcat-catalina-jmx-remote-7.0.4.jar -o /usr/share/tomcat/lib/tomcat-catalina-jmx-remote-7.0.4.jar

echo "==> Configuring jmx"
sed -i '/<Listener className="org.apache.catalina.core.ThreadLocalLeakPreventionListener" \/>/a\
  <Listener className="org.apache.catalina.mbeans.JmxRemoteLifecycleListener" rmiRegistryPortPlatform="8097" rmiServerPortPlatform="8098" \/>' /etc/tomcat/server.xml

echo "==> Adding JAVA_OPTS"
sed -i '/#JAVA_OPTS="-Xminf0.1 -Xmaxf0.3"/a\
JAVA_OPTS="-Dcom.sun.management.jmxremote -Djava.rmi.server.hostname=10.1.1.2 -Dcom.sun.management.jmxremote.local.only=false -Dcom.sun.management.jmxremote.port=12345 -Dcom.sun.management.jmxremote.rmi.port=12346 -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false"' /etc/tomcat/tomcat.conf

echo "==> Starting Tomcat"
systemctl start tomcat
systemctl enable tomcat

