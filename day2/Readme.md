##  Task 1 - Zabbix JAVA:
- Configure Zabbix to examine Java parameters via Java Gateway

*vim /usr/share/tomcat/conf/tomcat.conf*
<img src="screens/1.png">

<img src="screens/2.png">

*vim /usr/share/tomcat/conf/server.xml*
<img src="screens/3.png">
<img src="screens/4.png">
<img src="screens/5.png">
<img src="screens/6.png">
<img src="screens/7.png">
<img src="screens/8.png">
<img src="screens/9.png">
<img src="screens/10.png">
<img src="screens/11.png">

- Configure triggers to alert once these parameters changed.

<img src="screens/12.png">
<img src="screens/13.png">
<img src="screens/14.png">

##  Task 2 - Web Monitoring with Zabbix:
- Scenario to test Tomcat availability as well as Application heath

<img src="screens/15.png">
<img src="screens/16.png">
<img src="screens/17.png">
<img src="screens/18.png">
<img src="screens/19.png">
<img src="screens/20.png">
<img src="screens/21.png">

*after stop tomcat*

<img src="screens/22.png">

- Configure Triggers to alert once WEB resources become unavailable

<img src="screens/23.png">

*systemctl stop tomcat*

<img src="screens/24.png">
<img src="screens/25.png">

##  Task 3 - Zabbix API:

- Starts at VM startup or on provision phase

- Host registered in Zabbix server should have Name = Hostname (not IP)

- Host registered in Zabbix server should belong to ”CloudHosts” group

- Host registered in Zabbix server should be linked with Custom template

- This script should create group “CloudHosts” id it doesn’t exist

# Result script
 [a link](https://github.com/SuperBazis/zabbix-tasks/blob/atsuranauD2/day2/scripts/zabbixregistration.py)







