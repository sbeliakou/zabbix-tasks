Task1
Java Monitoring with Java

1. Configure Zabbix to examine Java parameters via Java Gateway

sol: 
1. Tomcat is installed on host1 VM
2. Downloaded jmx-remote and placed in /usr/share/tomcat/lib
3. JmxRemoteLifecycleListener to server.xml
4. added JAVA_OPTS in /etc/tomcat/tomcat.conf
5. zabbix-java-gateway installed and started on zabbix-server VM
6. 3 lines are edited via sed to set javaGateway properies in zabbix_server.conf
7. zabbix-server is restarted
8. jmx interfaces are configured 
9. req items are added
10. trigger for Java Heap Memory Used is added


screens of workflow are placed in d2_t1.pdf

script of host1 VM  for tomcat usage is:
script of zabbxi_server for gateway usage is(in the end of file):