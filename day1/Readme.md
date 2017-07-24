# Report Here

# Task 1. Zabbix. Basics

Testing Infrastructure:
-Vagrantfile to spin up 2 VMs (virtualbox):
-zabbix server, provisioned by Vagrant provisioner
-Zabbix agents on both VMs, provisioned by Vagrant provisioner
-Configure zabbix to work on the server directly without /zabbix

<img src="pictures/Screenshot from 2017-07-24 23-08-49.png">

http://zabbix-server/zabbix -> http://zabbix-server

Task:
You should install and configure Zabbix server and agents.

1. Using Zabbix UI:
-Create User group “Project Owners”

-Create User (example “Siarhei Beliakou”), assign user to “Project Owners”, set email

<img src="pictures/Screenshot from 2017-07-24 19-36-43.png">

-Add 2nd VM to zabbix: create Host group (“Project Hosts”), create Host in this group, enable ZABBIX Agent monitoring

<img src="pictures/Screenshot from 2017-07-24 19-47-41.png">

-Assign to this host template of Linux

<img src="pictures/Screenshot from 2017-07-24 19-49-27.png">

-Create custom checks (CPU Load, Memory load, Free space on file systems, Network load)

<img src="pictures/Screenshot from 2017-07-24 23-13-57.png">

-Create trigger with Severity HIGH, check if it works (Problem/Recovery)

<img src="pictures/Screenshot from 2017-07-24 23-16-36.png">




-Create Action to inform “Project Owners” if HIGH triggers happen
<img src="pictures/Screenshot from 2017-07-24 22-02-51.png">

<img src="pictures/Screenshot from 2017-07-24 21-00-20.png">

<img src="pictures/Screenshot from 2017-07-24 22-43-20.png">

<img src="pictures/Screenshot from 2017-07-24 22-57-42.png">

For both VMs use vagrant box “sbeliakou/centos-7.3-x86_64-minimal”

2. Using Zabbix UI:
Configure “Network discovery” so that, 2nd VM will be joined to Zabbix (group “Project Hosts”, Template “Template OS Linux”)

<img src="pictures/Screenshot from 2017-07-24 20-35-40.png">

<img src="pictures/Screenshot from 2017-07-24 20-35-50.png">

<img src="pictures/Screenshot from 2017-07-24 20-35-31.png">

<img src="pictures/Screenshot from 2017-07-24 20-35-10.png">


For both VMs use vagrant box “sbeliakou/centos-7.3-x86_64-minimal”



# Task 2. Zabbix Tools
Testing Infrastructure:
Vagrantfile to spin up 2 VMs (virtualbox):
    - zabbix server, provisioned by Vagrant provisioner
    - Linux VM with zabbix agent, script for registration on zabbix server, all provisioned by Vagrant provisioner
Task:
1. Configure the agent for replying to the specific server in passive and active mode.

2. Use zabbix_sender to send data to server manually (use zabbix_sender with key –vv for maximal verbosity).

<img src="pictures/Screenshot from 2017-07-24 23-32-12.png">

3. Use zabbix_get as data receiver and examine zabbix agent sending’s.



For both VMs use vagrant box “sbeliakou/centos-7.3-x86_64-minimal”

