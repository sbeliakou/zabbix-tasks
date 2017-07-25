# Task. Java Monitoring with Java #

**Task:**

You should install and configure Zabbix server and agents.

Testing Infrastructure:

Vagrantfile to spin up 2 VMs (virtualbox):

* zabbix server, provisioned by Vagrant provisioner
* Zabbix agents on both VMs, provisioned by Vagrant provisioner

Install Tomcat 7 on 2nd VM

<img src="pictures/Screenshot from 2017-07-25 12-12-30.png">

<img src="pictures/Screenshot from 2017-07-25 12-13-45.png">

## Tasks: ##

### 1. Configure Zabbix to examine Java parameters via Java Gateway (http://jmxmonitor.sourceforge.net/jmx.html) ###

<img src="pictures/Screenshot from 2017-07-25 13-31-07.png">

<img src="pictures/Screenshot from 2017-07-25 14-05-38.png">

<img src="pictures/Screenshot from 2017-07-25 14-09-04.png">

<img src="pictures/Screenshot from 2017-07-25 14-40-27.png">

<img src="pictures/Screenshot from 2017-07-25 14-45-55.png">

<img src="pictures/Screenshot from 2017-07-25 15-56-22.png">

<img src="pictures/Screenshot from 2017-07-25 15-56-13.png">

<img src="pictures/Screenshot from 2017-07-25 15-59-42.png">

### 2. Configure triggers to alert once these parameters changed. ###

<img src="pictures/Screenshot from 2017-07-25 15-55-19.png">

<img src="pictures/Screenshot from 2017-07-25 15-44-26.png">

<img src="pictures/Screenshot from 2017-07-25 15-54-27.png">

<img src="pictures/Screenshot from 2017-07-25 15-53-21.png">

For both VMs use vagrant box “sbeliakou/centos-7.3-x86_64-minimal”



# Task. Web Monitoring with Zabbix #

Testing Infrastructure:

Vagrantfile to spin up 2 VMs (virtualbox):

* zabbix server, provisioned by Vagrant provisioner
* Zabbix agents on both VMs, provisioned by Vagrant provisioner

Install Tomcat 7 on 2nd VM, deploy any “hello world” application

## Tasks: ##

### 1. Configure WEB check: ###
* Scenario to test Tomcat availability as well as Application heath

<img src="pictures/Screenshot from 2017-07-25 16-52-33.png">

<img src="pictures/Screenshot from 2017-07-25 16-52-40.png">

<img src="pictures/Screenshot from 2017-07-25 16-50-14.png">

<img src="pictures/Screenshot from 2017-07-25 16-50-44.png">

<img src="pictures/Screenshot from 2017-07-25 16-52-12.png">

### 2. Configure Triggers to alert once WEB resources become unavailable ###

<img src="pictures/Screenshot from 2017-07-25 16-58-08.png">

<img src="pictures/Screenshot from 2017-07-25 17-06-53.png">

<img src="pictures/Screenshot from 2017-07-25 17-05-54.png">

<img src="pictures/Screenshot from 2017-07-25 17-08-37.png">

<img src="pictures/Screenshot from 2017-07-25 17-09-21.png">

<img src="pictures/Screenshot from 2017-07-25 17-16-29.png">

For both VMs use vagrant box “sbeliakou/centos-7.3-x86_64-minimal”
