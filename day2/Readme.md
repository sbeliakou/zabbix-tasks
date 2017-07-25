
# Task 1. Java Monitoring with Java

Task:
You should install and configure Zabbix server and agents.

# Used Scripts

[Vagrantfile](https://github.com/bubalush/zabbix-tasks/blob/ndolya_day2/day2/Vagrantfile)- Vagrantfile to spin up 2 VMs

[agent.sh](https://github.com/bubalush/zabbix-tasks/tree/ndolya_day2/day2/scripts/agent.sh) - Install Zabbix-agent

[server.sh](https://github.com/bubalush/zabbix-tasks/tree/ndolya_day2/day2/scripts/server.sh) - Install Zabbix-server, zabbix-java-gateway

[tomcat.sh](https://github.com/bubalush/zabbix-tasks/tree/ndolya_day2/day2/scripts/tomcat.sh)- Install Tomcat server and configure JMX/RMI

Testing Infrastructure:

Vagrantfile to spin up 2 VMs (virtualbox):

- zabbix server, provisioned by Vagrant provisioner
- Zabbix agents on both VMs, provisioned by Vagrant provisioner

Install Tomcat 7 on 2nd VM

<img src="pictures/Screenshot from 2017-07-25 15-40-07.png">

<img src="pictures/Screenshot from 2017-07-25 13-33-16.png">

<img src="pictures/Screenshot from 2017-07-25 13-32-38.png">

Tasks:

1. Configure Zabbix to examine Java parameters via Java Gateway (http://jmxmonitor.sourceforge.net/jmx.html)

<img src="pictures/Screenshot from 2017-07-25 15-43-01.png">

<img src="pictures/Screenshot from 2017-07-25 15-43-57.png">

<img src="pictures/Screenshot from 2017-07-25 15-44-43.png">


2. Configure triggers to alert once these parameters changed.

<img src="pictures/Screenshot from 2017-07-25 15-48-24.png">

<img src="pictures/Screenshot from 2017-07-25 15-57-14.png">

<img src="pictures/Screenshot from 2017-07-25 15-36-43.png">

For both VMs use vagrant box “sbeliakou/centos-7.3-x86_64-minimal”


# Task 2. Web Monitoring with Zabbix

Testing Infrastructure:

Vagrantfile to spin up 2 VMs (virtualbox):

- zabbix server, provisioned by Vagrant provisioner
- Zabbix agents on both VMs, provisioned by Vagrant provisioner

Install Tomcat 7 on 2nd VM, deploy any “hello world” application

Tasks:

1. Configure WEB check:

Scenario to test Tomcat availability as well as Application heath

<img src="pictures/Screenshot from 2017-07-25 17-09-55.png">

<img src="pictures/Screenshot from 2017-07-25 17-02-52.png">

<img src="pictures/Screenshot from 2017-07-25 17-25-36.png">


2. Configure Triggers to alert once WEB resources become unavailable

<img src="pictures/Screenshot from 2017-07-25 17-02-25.png">

<img src="pictures/Screenshot from 2017-07-25 17-02-06.png">

For both VMs use vagrant box “sbeliakou/centos-7.3-x86_64-minimal”


# Task 3. Zabbix API

Task:

You should develop a script (on Python 2.x) which registers given host in Zabbix.

Testing Infrastructure:

Vagrantfile to spin up 2 VMs (virtualbox):

- zabbix server, provisioned by Vagrant provisioner
- Linux VM with zabbix agent, script for registration on zabbix server, all provisioned by Vagrant provisioner

Registering Script requirements:

Written on Python 2.x

Starts at VM startup or on provision phase

- Host registered in Zabbix server should have Name = Hostname (not IP)

- Host registered in Zabbix server should belong to ”CloudHosts” group

- Host registered in Zabbix server should be linked with Custom template

- This script should create group “CloudHosts” id it doesn’t exist

For both VMs use vagrant box “sbeliakou/centos-7.3-x86_64-minimal”

# Used Scripts

[zabbix_create.py](https://github.com/bubalush/zabbix-tasks/tree/ndolya_day2/day2/scripts/zabbix_create.py) - Create Host in Zabbix

[Vagrantfile](https://github.com/bubalush/zabbix-tasks/blob/ndolya_day2/day2/Vagrantfile)- Vagrantfile to spin up 2 VMs

[agent.sh](https://github.com/bubalush/zabbix-tasks/tree/ndolya_day2/day2/scripts/agent.sh) - Install Zabbix-agent

[server.sh](https://github.com/bubalush/zabbix-tasks/tree/ndolya_day2/day2/scripts/server.sh) - Install Zabbix-server, zabbix-java-gateway

[tomcat.sh](https://github.com/bubalush/zabbix-tasks/tree/ndolya_day2/day2/scripts/tomcat.sh)- Install Tomcat server and configure JMX/RMI