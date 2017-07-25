# Report Here

# Task 1. Java Monitoring with Java

Testing Infrastructure:
-Vagrantfile to spin up 2 VMs (virtualbox):
-zabbix server, provisioned by Vagrant provisioner
-Zabbix agents on both VMs, provisioned by Vagrant provisioner
-Install Tomcat 7 on 2nd VM

Tasks:
1. Configure Zabbix to examine Java parameters via Java Gateway

<img src="pictures/Screenshot from 2017-07-25 15-31-27.png">

2. Configure triggers to alert once these parameters changed.

<img src="pictures/Screenshot from 2017-07-25 16-19-12.png">

<img src="pictures/Screenshot from 2017-07-25 16-12-46.png">

-Alert

<img src="pictures/Screenshot from 2017-07-25 16-12-57.png">

# Task 2. Web Monitoring with Zabbix

Testing Infrastructure:
-Vagrantfile to spin up 2 VMs (virtualbox):
-zabbix server, provisioned by Vagrant provisioner
-Zabbix agents on both VMs, provisioned by Vagrant provisioner
-Install Tomcat 7 on 2nd VM, deploy any “hello world” application

Tasks:
1. Configure WEB check:
Scenario to test Tomcat availability as well as Application heath

<img src="pictures/Screenshot from 2017-07-25 16-36-19.png">

<img src="pictures/Screenshot from 2017-07-25 17-12-18.png">

2. Configure Triggers to alert once WEB resources become unavailable

<img src="pictures/Screenshot from 2017-07-25 17-13-16.png">

