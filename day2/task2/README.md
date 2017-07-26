#                                                  My FIRST TASK (ZABBIX)
## Install Zabbix server and zabbix-agent with Vagarant file 
##### Vagrantfile include: 2 virtualmachines and 3 sh scripts (server.sh,agent.sh and tomcat.sh)
##### Installation Zabbix-server:
###### a) Install DataBase and create user/password (user-zabbix, password-password, server-zabbix) - server.sh file
###### b) Download zabbix and configure it - server.sh file
###### c) Update timezone for zabbix (Europe/Minsk) - server.sh file
###### d) Modify zabbix.conf.php file for our configuration - server.sh file
###### e) Add VH and change zabbix-server name (ServerName - zabbix-server) - server.sh file
###### f) Install zabbix-java-gateway - server.sh file
###### g) Change configuration file /etc/zabbix/zabbix_server.conf with custom gateway- server.sh file
##### Installation host1 with zabbix-agent and tomcat:
###### a) Download and install zabbix-agent
###### b) Make changes with zabbix-Server address (ServerActive and Server = 192.168.56.10)
###### c) Install tomcat and webapp-tomcat 
###### d) Add Java_opts block into /etc/tomcat/tomcat.conf
###### e) Add new classname to /etc/tomcat/server.xml
###### f) Download tomcat-catalina-jmx and add it to tomcat's lib


###### Here you can see report for 2-d task with web-scenario and trigger



