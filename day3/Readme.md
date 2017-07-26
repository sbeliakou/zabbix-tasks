##  Task 1 - Zabbix Items:
###  Simple checks:
- Zabbix Server WEB availability (80)
<img src="screens/1.png">

- Zabbix DB is available (3306)
<img src="screens/2.png">

- Tomcat availability (80, 8080)
<img src="screens/3.png">

- Tomcat Server is available by ssh (22)
<img src="screens/4.png">

###  Calculated Checks:
- CPU Load per Core (1, 5, 15min)
<img src="screens/5.png">
<img src="screens/6.png">

*after stress –cpu 4 –timeout 60*
<img src="screens/7.png">
<img src="screens/8.png">

###  Internal Checks:
- How many items are enabled
<img src="screens/9.png">

- How many Servers are being monitored
<img src="screens/10.png">

###  Create triggers for every check
<img src="screens/11.png">
<img src="screens/12.png">
<img src="screens/13.png">
<img src="screens/14.png">

###  Create item and develop custom trigger for log monitoring (you can use httpd or tomcat logs)
<img src="screens/15.png">
<img src="screens/16.png">

###  Create a trigger for errors in log file monitored by that item
<img src="screens/17.png">
*after entering nonexistent address*
<img src="screens/18.png">
*after 30 seconds*
<img src="screens/19.png">

##  Task 2 - Zabbix Operations:
<img src="screens/20.png">
<img src="screens/21.png">
<img src="screens/22.png">
<img src="screens/23.png">
<img src="screens/24.png">
<img src="screens/25.png">
<img src="screens/26.png">
