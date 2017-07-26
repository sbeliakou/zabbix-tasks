# Used Scripts

[Vagrantfile](https://github.com/bubalush/zabbix-tasks/blob/ndolya_day3/day3/Vagrantfile)- Vagrantfile to spin up 2 VMs

[agent.sh](https://github.com/bubalush/zabbix-tasks/tree/ndolya_day3/day3/scripts/agent.sh) - Install Zabbix-agent

[server.sh](https://github.com/bubalush/zabbix-tasks/tree/ndolya_day3/day3/scripts/server.sh) - Install Zabbix-server

[tomcat.sh](https://github.com/bubalush/zabbix-tasks/tree/ndolya_day3/day3/scripts/tomcat.sh)- Install Tomcat server and Apache httpd

# Task 1. Items

Task:

Assuming we have 2 servers (VMs) – ZabbixServer and Tomcat,

Configure:

1. Simple checks:

- Zabbix Server WEB availability (80)

- Zabbix DB is available (3306)

- Tomcat availability (80, 8080)

- Tomcat Server is available by ssh (22)

<img src="pictures/Screenshot from 2017-07-26 13-39-46.png">

<img src="pictures/Screenshot from 2017-07-26 13-39-55.png">

<img src="pictures/Screenshot from 2017-07-26 13-40-06.png">

<img src="pictures/Screenshot from 2017-07-26 13-40-14.png">


2. Calculated Checks:

- CPU Load per Core (1, 5, 15min)

<img src="pictures/Screenshot from 2017-07-26 17-29-21.png"> 

<img src="pictures/Screenshot from 2017-07-26 17-35-19.png">

<img src="pictures/Screenshot from 2017-07-26 17-36-04.png">

3. Internal Checks:

- How many items are enabled

<img src="pictures/Screenshot from 2017-07-26 17-26-55.png">

- How many Servers are being monitored

<img src="pictures/Screenshot from 2017-07-26 17-28-24.png">

Create triggers for every check

<img src="pictures/Screenshot from 2017-07-26 17-44-14.png">

<img src="pictures/Screenshot from 2017-07-26 17-44-55.png">

<img src="pictures/Screenshot from 2017-07-26 13-41-16.png">

<img src="pictures/Screenshot from 2017-07-26 13-43-33.png">

4. Create item and develop custom trigger for log monitoring (you can use httpd or tomcat logs).

Create a trigger for errors in log file monitored by that item

<img src="pictures/Screenshot from 2017-07-26 17-47-43.png">

<img src="pictures/Screenshot from 2017-07-26 17-48-18.png">

<img src="pictures/Screenshot from 2017-07-26 17-52-14.png">

# Task2 . Operations

Configure Custom graphs and screens of your infrastructure:

2 VMS, Zabbix Server and Tomcat Server 

<img src="pictures/Screenshot from 2017-07-26 17-56-56.png">

<img src="pictures/Screenshot from 2017-07-26 18-02-04.png">

<img src="pictures/Screenshot from 2017-07-26 18-02-50.png">

<img src="pictures/Screenshot from 2017-07-26 18-03-39.png">

<img src="pictures/Screenshot from 2017-07-26 18-04-29.png">







