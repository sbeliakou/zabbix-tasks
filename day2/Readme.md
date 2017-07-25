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

script of host1 VM  for tomcat usage is: zabbix-tasks/day2/scripts/tomcat.sh

script of zabbxi_server for gateway usage is(in the end of file): zabbix-tasks/day2/scripts/server.sh


##############################
Task2 
Web Monitoring with Zabbix
##############################
1. Configure WEB check

sol:
1. on host named 192.168.56.11 set up web scenario with following params

1:	hello page Ok	15 sec	http://192.168.56.11:8080/examples/servlets/servlet/HelloWorldExample		200	Remove

2:	tomcat is Ok	15 sec	192.168.56.11:8080															200	Remove

2. Configure Triggers to alert once WEB resources become unavailable

sol:
1. configure trigger for response code

{192.168.56.11:web.test.fail[tomcat helloworld is available].last(0)}>0

screens of workflow are placed in d2_t2.pdf




##############################
Task3 
Python scpript
##############################
Testing Infrastructure:

	1. Vagrantfile to spin up 2 VMs (virtualbox):
	2. zabbix server, provisioned by Vagrant provisioner
	3. Linux VM with zabbix agent, script for registration on zabbix server, all provisioned by Vagrant provisioner

Registering Script requirements:
	1. Written on Python 2.x
	2. Starts at VM startup or on provision phase
	3. Host registered in Zabbix server should have Name = Hostname (not IP)
	4. Host registered in Zabbix server should belong to ”CloudHosts” group
	5. Host registered in Zabbix server should be linked with Custom template
	6. This script should create group “CloudHosts” id it doesn’t exist
