# Task. Java Monitoring with Java
## 1. Configure Zabbix to examine Java parameters via Java Gateway
### Configuring /etc/tomcat/tomcat.conf: 
<img src="/day2/task1/1.jpg">
<img src="/day2/task1/2.jpg">

### Placing tomcat-catalina-jmx-remote.jar into $CATALINA_HOME/lib/
<img src="/day2/task1/3.jpg">

### Add following definition into “listeners” in ${CATALINA_HOME}/conf/server.xml:
<img src="/day2/task1/4.jpg">

### checking:
<img src="/day2/task1/5.jpg">
<img src="/day2/task1/6.jpg">

### Configuring Zabbix Server Part:
<img src="/day2/task1/7.jpg">

### Configuring zabbix host:
<img src="/day2/task1/8.jpg">

### Creating template:
<img src="/day2/task1/9.jpg">
<img src="/day2/task1/10.jpg">

## 2. Configure triggers to alert once these parameters changed.
<img src="/day2/task1/11.jpg">
<img src="/day2/task1/12.jpg">

# ===============================

# Task. Web Monitoring with Zabbix
## 1. Configure WEB check: Scenario to test Tomcat availability as well as Application heath
### Creating web scenario:
<img src="/day2/task2/1.jpg">

### Adding steps:
<img src="/day2/task2/2.jpg">

### Checking:
<img src="/day2/task2/3.jpg">

## 2. Configure Triggers to alert once WEB resources become unavailable
### Creating triggers:
<img src="/day2/task2/4.jpg">

### Checking(systemctl stop topmcat):
<img src="/day2/task2/5.jpg">

# ================================
# Task. Zabbix API
## Registering Script requirements:
### Written on Python 2.x
### Starts at VM startup or on provision phase
### Host registered in Zabbix server should have Name = Hostname (not IP)
### Host registered in Zabbix server should belong to ”CloudHosts” group
### Host registered in Zabbix server should be linked with Custom template
### This script should create group “CloudHosts” id it doesn’t exist

# Provision file for Agent (2nd VM)(create systemd unit file to register od disable host automatically):
[a link](https://github.com/aion3181/zabbix-tasks/blob/day2/day2/script2.sh)

# Python script:
[a link](https://github.com/aion3181/zabbix-tasks/blob/day2/day2/zabbixhostadd.py)



