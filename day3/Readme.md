# Artsiom Aksionkin

# Task 1. Items in zabbix

# Task:
Assuming we have 2 servers (VMs) – ZabbixServer and Tomcat,
Configure:
# 1. Simple checks:

-Zabbix Server WEB availability (80)
-Zabbix DB is available (3306)
-Tomcat availability (80, 8080)
-Tomcat Server is available by ssh (22)

<img src="pictures/Screenshot from 2017-07-26 13-16-41.png">

# 2. Calculated Checks:

-CPU Load per Core (1, 5, 15min)

<img src="pictures/Screenshot from 2017-07-26 15-09-27.png">

# 3. Internal Checks:

-How many items are enabled

<img src="pictures/Screenshot from 2017-07-26 15-30-11.png">

-How many Servers are being monitored

<img src="pictures/Screenshot from 2017-07-26 15-31-23.png">

-Create triggers for every check

<img src="pictures/Screenshot from 2017-07-26 17-26-50.png">
<img src="pictures/Screenshot from 2017-07-26 17-27-07.png">

# 4. LOG check with zabbix
-Create item and develop custom trigger for log monitoring (you can use httpd or tomcat logs)

<img src="pictures/Screenshot from 2017-07-26 17-36-06.png">

-Create a trigger for errors in log file monitored by that item

<img src="pictures/Screenshot from 2017-07-26 17-36-22.png">

<img src="pictures/Screenshot from 2017-07-26 17-36-34.png">

# 5. Task. Operations

Task:
Configure Custom graphs and screens of your infrastructure:
2 VMS, Zabbix Server and Tomcat Server 

-Custom graphs
<img src="pictures/Screenshot from 2017-07-26 18-01-49.png">

-Custom screen
<img src="pictures/Screenshot from 2017-07-26 18-10-39.png">