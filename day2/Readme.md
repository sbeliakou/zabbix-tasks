## Task. Java Monitoring with Java

**Task:**  
You should install and configure Zabbix server and agents.  
Testing Infrastructure:  
  Vagrantfile to spin up 2 VMs (virtualbox):  
   - Zabbix server, provisioned by Vagrant provisioner  
   - Zabbix agents on both VMs, provisioned by Vagrant provisioner  
   - Install Tomcat 7 on 2nd VM  

**Tasks:**
  * Configure Zabbix to examine Java parameters via Java Gateway (http://jmxmonitor.sourceforge.net/jmx.html)  
  /usr/share/tomcat/conf/tomcat.conf:  
  <img src="images/1-1.png">
  
  /usr/share/tomcat/conf/server.xml:  
  <img src="images/1-2.png">
  
  ps -ef | grep tomcat:  
  <img src="images/1-3.png">
  
  checking with jmxterm:  
  <img src="images/1-4.png">
  
  after installing zabbix-java-gateway
  /etc/zabbix/zabbix_server.conf:  
  <img src="images/1-5.png">
 
 configuring host and adding items:  
 <img src="images/1-6.png">  
 <img src="images/1-7.png">
 
 result:  
 <img src="images/1-8.png">
  
  * Configure triggers to alert once these parameters changed.
 <img src="images/1-9.png">  
 <img src="images/1-10.png">  
 <img src="images/1-11.png">  
 
## Task. Web Monitoring with Zabbix

**Testing Infrastructure:**  

  Vagrantfile to spin up 2 VMs (virtualbox):  
    -zabbix server, provisioned by Vagrant provisioner  
    -Zabbix agents on both VMs, provisioned by Vagrant provisioner  
  Install Tomcat 7 on 2nd VM, deploy any “hello world” application  
  
 **Tasks:**
  * Configure WEB check:  
  Scenario to test Tomcat availability as well as Application heath  
  <img src="images/2-1.png">  
  <img src="images/2-2.png">  
  
  * Configure Triggers to alert once WEB resources become unavailable  
  <img src="images/2-3.png">
  <img src="images/2-4.png">   
  
  after undeploying sample app:  
  <img src="images/2-6.png">
  
  
  
  
  



 
