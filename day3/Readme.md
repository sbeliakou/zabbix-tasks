# Task. Items
### Task:
   Assuming we have 2 servers (VMs) – ZabbixServer and Tomcat (see [Vagrantfile](https://github.com/akonchyts/zabbix-tasks/blob/akonchyts/day3/Vagrantfile), see [server.sh](https://github.com/akonchyts/zabbix-tasks/blob/akonchyts/day3/server.sh), see [agent.sh](https://github.com/akonchyts/zabbix-tasks/blob/akonchyts/day3/agent.sh))  

### Configure checks and triggers for every check:  
### **1.** Simple checks:  
   *Zabbix Server WEB availability (80) and trigger for it*  
   <img src="pic/1.png">  
   
   <img src="pic/10.png">  
   
   *Zabbix DB is available (3306) and trigger for it*  
   <img src="pic/5.png">  
   
   <img src="pic/9.png">  
   
   *Tomcat availability (80) and trigger for it*  
   <img src="pic/7.png">  
   
   <img src="pic/1.png">  
   
   *Tomcat availability (8080) and trigger for it* 
   <img src="pic/3.png">  
   
   <img src="pic/6.png">  
   
   *Tomcat Server is available by ssh (22) and trigger for it*  
   <img src="pic/4.png">  
   
   <img src="pic/8.png">  

####   Check that simple checks and triggers for them work for:
   <img src="pic/11.png">  
   
   *Zabbix Server WEB unavailability (80) trigger*  
   <img src="pic/20.png">  
   
   *Tomcat unavailability (80,8080) triggers*  
   <img src="pic/19.png">  
   
   
### **2.** Calculated Checks:  
   *CPU Load per Core (1, 5, 15min) and triggers for them*  
   <img src="pic/12.png">  
   <img src="pic/15.png">  
   
   <img src="pic/13.png">  
   <img src="pic/16.png">  
   
   <img src="pic/14.png">  
   <img src="pic/17.png">  
   
#### Check that calculated checks and triggers for them work:  
   <img src="pic/18.png">  
   
   <img src="pic/26.png">  
   
   
### **3.** Internal Checks:
   *How many items are enabled and trigger for it*  
   <img src="pic/21.png">  
   
   <img src="pic/24.png">  
   
   *How many Servers are being monitored and trigger for it*  
   <img src="pic/22.png">  
   
   <img src="pic/25.png">  
   
#### Check that internal checks and triggers for them work:  
   <img src="pic/23.png">  
   
   <img src="pic/27.png">  
   
  
### **4.** Create item and custom trigger for log monitoring (you can use httpd or tomcat logs)  
   *Create item for log monitoring and trigger for it*  
   <img src="pic/28.png">  
   
   <img src="pic/31.png">  

#### Check that item for log monitoring and trigger for it work:  
   <img src="pic/29.png">  
   
   <img src="pic/30.png">  



# Task. Operations  
### Task:  
   Configure Custom graphs and screens of your infrastructure:  
   2 VMS, Zabbix Server and Tomcat Server  
   
   *Create next items and check that they work*  
   <img src="pic/47.png">  
   
   <img src="pic/48.png">  
   
   *Create next graphs and check them*  
   <img src="pic/40.png">  
   
   <img src="pic/42.png">  
   
   <img src="pic/43.png">  
   
   <img src="pic/44.png">  
   
   <img src="pic/45.png">  
   
   *Create screen for Zabbix Server and Tomcat Server*  
   <img src="pic/41.png">  
   
   *Create screen for Tomcat Server (host-agent1)*  
   <img src="pic/46.png">  

