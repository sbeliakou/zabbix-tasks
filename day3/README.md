#                                                  (ZABBIX)
## Install Zabbix server and zabbix-agent with Vagarant file 
##### Vagrantfile include: 2 virtualmachines and 3 sh scripts (server.sh,agent.sh and tomcat.sh)
##### Installation Zabbix-server:
###### a) Install DataBase and create user/password (user-zabbix, password-password, server-zabbix) - server.sh file
###### b) Download zabbix and configure it - server.sh file
###### c) Update timezone for zabbix (Europe/Minsk) - server.sh file
###### d) Modify zabbix.conf.php file for our configuration - server.sh file
###### e) Add VH and change zabbix-server name (ServerName - zabbix-server) - server.sh file
###### f) Install zabbix-java-gateway - server.sh file
###### g) Change configuration file /etc/zabbix/zabbix_server.conf with custom gateway - server.sh file
##### Installation host1 with zabbix-agent and tomcat:
###### a) Download and install zabbix-agent - agent.sh
###### b) Make changes with zabbix-Server address (ServerActive and Server = 192.168.56.10) - agent.sh
###### c) Install tomcat and webapp-tomcat - tomcat.sh
###### d) Add Java_opts block into /etc/tomcat/tomcat.conf - tomcat.sh
###### e) Add new classname to /etc/tomcat/server.xml - tomcat.sh
###### f) Download tomcat-catalina-jmx and add it to tomcat's lib - tomcat.sh
###### g) Download and install httpd
###### Here you can see report for day3 with items and operations taks
###### Task1: Create simple_checks and triggers for zabbix and tomcat; Create zabbix internal checks such as a number of enabled items and monitored hosts.
###### Task2: Monitoring Tomcat (only 8080 port), CPU load from host1, free disk space.


