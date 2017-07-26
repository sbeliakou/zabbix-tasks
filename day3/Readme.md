# Task1

__1. Simple checks:__
* Zabbix Server WEB availability (80)
* Zabbix DB is available (3306)
* Tomcat availability (80, 8080)
* Tomcat Server is available by ssh (22)

<img src="img/add1-1.png">
<img src="img/add1-2.png">

__The result (tomcat only):__
* for full down of virtual host command:
<img src="img/1-1.png">

* **sshd** daemon down only:
<img src="img/1-2.png">
<img src="img/1-3.png">

__2. Calculated Checks:__

* CPU load per cpu in **%**
<img src="img/2-1.png">

__3. Internal Checks:__

* How many items are enabled
* How many Servers are being monitored

<img src="img/3-1.png">

* Triggers:

<img src="img/3-2.png">

# Task2
__Graphs__

* Zabbix CPU (default)

<img src="img/4-1.png">

* Tomcat availability (custom)

<img src="img/4-2.png">

* Tomcat threads (custom)

<img src="img/4-3.png">