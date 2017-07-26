## Task. Logfile monitoring

**Task:**
  * Create item and develop custom trigger for log monitoring (you can use httpd or tomcat logs)  
  <img src="images/1-1.png">  
  <img src="images/1-2.png">  

  * Create a trigger for errors in log file monitored by that item  
  <img src="images/1-3.png">  
  <img src="images/1-4.png">

## Task. Items

**Task:**  
Assuming we have 2 servers (VMs) – ZabbixServer and Tomcat.  
Configure:
### 1. Simple checks:
  * Zabbix Server WEB availability (80)  

  <img src="images/2-1.png">

  * Zabbix DB is available (3306)  
  <img src="images/2-2.png">

  * Tomcat availability (80, 8080)  
  <img src="images/2-3.png">
  <img src="images/2-4.png">

  * Tomcat Server is available by ssh (22)  
  <img src="images/2-5.png">

### 2. Calculated Checks:
  * CPU Load per Core (1, 5, 15min)
  <img src="images/2-6.png">  
  <img src="images/2-7.png">  
  <img src="images/2-8.png">  

### 3. Internal Checks:
  * How many items are enabled
  <img src="images/2-9.png">

  * How many Servers are being monitored
  <img src="images/2-10.png">

### Create triggers for every check  

 Zabbix Server WEB availability (80)  
  <img src="images/2-11.png">  

  Zabbix DB is available (3306)  

  <img src="images/2-12.png">  

  Tomcat availability (80)  
  <img src="images/2-13.png">  

  Tomcat availability (8080)  
  <img src="images/2-14.png">  

  Tomcat Server is available by ssh (22)  
  <img src="images/2-15.png">

  Average CPU load per core (for 1, 5, 15 minutes)  
  <img src="images/2-16.png">
  <img src="images/2-17.png">
  <img src="images/2-18.png">

  Count active items changed  
  <img src="images/2-19.png">

  Count of monitored hosts changed  
  <img src="images/2-20.png">

### Example of triggering:  
<img src="images/2-21.png">

## Task. Operations

**Task:**
Configure Custom graphs and screens of your infrastructure:  
2 VMS, Zabbix Server and Tomcat Server

<img src="images/3-1.png">
