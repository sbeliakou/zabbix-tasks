# Report Here
Task. Zabbix. Basics

Testing Infrastructure:
-Vagrantfile to spin up 2 VMs (virtualbox):
-zabbix server, provisioned by Vagrant provisioner
-Zabbix agents on both VMs, provisioned by Vagrant provisioner
-Configure zabbix to work on the server directly without /zabbix 

<img src="pictures/Screenshot from 2017-07-24 21-07-06.png">

http://zabbix-server/zabbix -> http://zabbix-server

Task:
You should install and configure Zabbix server and agents.

1. Using Zabbix UI:
-Create User group “Project Owners” 

<img src="pictures/Screenshot from 2017-07-24 20-49-39.png">

<img src="pictures/Screenshot from 2017-07-24 20-49-44.png">

-Create User (example “Siarhei Beliakou”), assign user to “Project Owners”, set email

<img src="pictures/Screenshot from 2017-07-24 20-51-24.png">

<img src="pictures/Screenshot from 2017-07-24 20-51-28.png">

-Add 2nd VM to zabbix: create Host group (“Project Hosts”), create Host in this group, enable ZABBIX Agent monitoring

<img src="pictures/Screenshot from 2017-07-24 20-53-20.png">

<img src="pictures/Screenshot from 2017-07-24 20-53-45.png">

-Assign to this host template of Linux 

<img src="pictures/Screenshot from 2017-07-24 20-53-54.png">

-Create custom checks (CPU Load, Memory load, Free space on file systems, Network load)

<img src="pictures/Screenshot from 2017-07-24 20-55-58.png">

<img src="pictures/Screenshot from 2017-07-24 20-56-12.png">

<img src="pictures/Screenshot from 2017-07-24 20-56-26.png">

<img src="pictures/Screenshot from 2017-07-24 20-56-43.png">

-Create trigger with Severity HIGH, check if it works (Problem/Recovery)

<img src="pictures/Screenshot from 2017-07-24 21-00-00.png">

<img src="pictures/Screenshot from 2017-07-24 21-00-20.png">

<img src="pictures/Screenshot from 2017-07-24 21-00-24.png">

<img src="pictures/Screenshot from 2017-07-24 20-38-13.png">


-Create Action to inform “Project Owners” if HIGH triggers happen

<img src="pictures/Screenshot from 2017-07-24 20-36-41.png">

<img src="pictures/Screenshot from 2017-07-24 20-36-55.png">

<img src="pictures/Screenshot from 2017-07-24 20-38-13.png">

For both VMs use vagrant box “sbeliakou/centos-7.3-x86_64-minimal”

2. Using Zabbix UI:
Configure “Network discovery” so that, 2nd VM will be joined to Zabbix (group “Project Hosts”, Template “Template OS Linux”)

<img src="pictures/Screenshot from 2017-07-24 20-35-40.png">

<img src="pictures/Screenshot from 2017-07-24 20-35-50.png">

<img src="pictures/Screenshot from 2017-07-24 20-35-31.png">

<img src="pictures/Screenshot from 2017-07-24 20-35-10.png">


For both VMs use vagrant box “sbeliakou/centos-7.3-x86_64-minimal”

