# Report Here

Task. Zabbix. Basics

Testing Infrastructure:

Vagrantfile to spin up 2 VMs (virtualbox):

zabbix server, provisioned by Vagrant provisioner

Zabbix agents on both VMs, provisioned by Vagrant provisioner

Configure zabbix to work on the server directly without /zabbix

http://zabbix-server/zabbix -> http://zabbix-server

<img src="pictures/Screenshot from 2017-07-24 21-10-02.png">

Task:
You should install and configure Zabbix server and agents.

1. Using Zabbix UI:
Create User group “Project Owners”
<img src="pictures/Screenshot from 2017-07-24 21-12-11.png">

<img src="pictures/Screenshot from 2017-07-24 21-13-17.png">

Create User (example “Siarhei Beliakou”), assign user to “Project Owners”, set email

<img src="pictures/Screenshot from 2017-07-24 21-14-43.png">

<img src="pictures/Screenshot from 2017-07-24 21-15-00.png">

<img src="pictures/Screenshot from 2017-07-24 21-15-06.png">

Add 2nd VM to zabbix: create Host group (“Project Hosts”), create Host in this group, enable ZABBIX Agent monitoring

<img src="pictures/Screenshot from 2017-07-24 21-18-01.png">

<img src="pictures/Screenshot from 2017-07-24 21-18-19.png">

<img src="pictures/Screenshot from 2017-07-24 21-18-29.png">

Assign to this host template of Linux

<img src="pictures/Screenshot from 2017-07-24 21-20-34.png">

Create custom checks (CPU Load, Memory load, Free space on file systems, Network load)

<img src="pictures/Screenshot from 2017-07-24 21-22-32.png">

<img src="pictures/Screenshot from 2017-07-24 21-24-54.png">

<img src="pictures/Screenshot from 2017-07-24 21-26-52.png">

<img src="pictures/Screenshot from 2017-07-24 21-29-33.png">

Create trigger with Severity HIGH, check if it works (Problem/Recovery)

<img src="pictures/Screenshot from 2017-07-24 21-35-04.png">

<img src="pictures/Screenshot from 2017-07-24 21-36-34.png">

Create Action to inform “Project Owners” if HIGH triggers happen

<img src="pictures/Screenshot from 2017-07-24 21-40-48.png">

<img src="pictures/Screenshot from 2017-07-24 21-41-16.png">

<img src="pictures/Screenshot from 2017-07-24 21-41-41.png">

<img src="pictures/Screenshot from 2017-07-24 19-26-34.png">

<img src="pictures/Screenshot from 2017-07-24 21-44-12.png">

For both VMs use vagrant box “sbeliakou/centos-7.3-x86_64-minimal”

2. Using Zabbix UI:
Configure “Network discovery” so that, 2nd VM will be joined to Zabbix (group “Project Hosts”, Template “Template OS Linux”)

<img src="pictures/Screenshot from 2017-07-24 21-44-55.png">

<img src="pictures/Screenshot from 2017-07-24 21-45-47.png">

<img src="pictures/Screenshot from 2017-07-24 21-46-18.png">

<img src="pictures/Screenshot from 2017-07-24 21-47-31.png">

<img src="pictures/Screenshot from 2017-07-24 21-47-43.png">

For both VMs use vagrant box “sbeliakou/centos-7.3-x86_64-minimal”