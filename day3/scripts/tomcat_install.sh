yum install tomcat tomcat-webapps -y
echo "JAVA_OPTS=\"${JAVA_OPTS} -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=12345 -Dcom.sun.management.jmxremote.rmi.port=12346 -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false\"" >> /usr/share/tomcat/conf/tomcat.conf
sed -i 's/<Server port="8005" shutdown="SHUTDOWN">/<Server port="8005" shutdown="SHUTDOWN">\n  <Listener className="org.apache.catalina.mbeans.JmxRemoteLifecycleListener"\n  rmiRegistryPortPlatform="8097"\n  rmiServerPortPlatform="8098"\n  \/>/' /usr/share/tomcat/conf/server.xml
cd /usr/share/tomcat/lib
wget http://central.maven.org/maven2/org/apache/tomcat/tomcat-catalina-jmx-remote/7.0.4/tomcat-catalina-jmx-remote-7.0.4.jar
systemctl start tomcat
systemctl enable tomcat
