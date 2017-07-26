# Task. Zabbix. Basics
### See Vagrantfile and script files for Testing Infrastructure:
*Vagrantfile to spin up 2 VMs (virtualbox):*
  * *zabbix server, provisioned by Vagrant provisioner*
  * *Zabbix agents on both VMs, provisioned by Vagrant provisioner*
*Configure zabbix to work on the server directly without /zabbix*
*http://zabbix-server/zabbix -> http://zabbix-server*

### Task:
**1.** Using Zabbix UI:
  * *Create User group 'Project Owners'*

<img src="pic/1.png">

<img src="pic/24.png">
  
  * *Create User 'Andrei konchyts'), assign user to 'Project Owners', set email*

<img src="pic/2.png">

<img src="pic/25.png">

<img src="pic/3.png">

<img src="pic/4.png">
 
  * *Add 2nd VM to zabbix: create Host group ('Project Hosts'), create Host in this group, enable ZABBIX Agent monitoring*
  
<img src="pic/5.png">

<img src="pic/6.png">

<img src="pic/8.png">
  
  * *Assign to this host template of Linux*
  
<img src="pic/7.png">
  
  * *Create custom checks (CPU Load, Memory load, Free space on file systems, Network load)*
  
<img src="pic/9.png">

<img src="pic/10.png">

<img src="pic/11.png">

<img src="pic/12.png">

<img src="pic/13.png">

<img src="pic/14.png">

<img src="pic/15.png">
  
  * *Create trigger with Severity HIGH, check if it works (Problem/Recovery)*
  
<img src="pic/16.png">

<img src="pic/17.png">

<img src="pic/18.png">

<img src="pic/19.png">
  
  * *Create Action to inform 'Project Owners' if HIGH triggers happen*
  
<img src="pic/20.png">

<img src="pic/21.png">

<img src="pic/22.png">

<img src="pic/23.png">

<img src="pic/26.png">

<img src="pic/28.png">

<img src="pic/27.png">

<img src="pic/29.png">

**2.** Using Zabbix UI:
  * *Configure 'Network discovery' so that, 2nd VM will be joined to Zabbix (group 'Project Hosts', Template 'Template OS Linux')*
  
<img src="pic/30.png">

<img src="pic/31.png">

<img src="pic/32.png">

<img src="pic/33.png">

<img src="pic/34.png">

<img src="pic/35.png">

<img src="pic/36.png">

<img src="pic/37.png">



# Task. Zabbix Tools
### See Vagrantfile and script files for Testing Infrastructure

### Task:
**1.** Configure the agent for replying to the specific server in passive and active mode

<img src="pic/40.png">

<img src="pic/41.png">

**2.** Use zabbix_sender to send data to server manually (use zabbix_sender with key –vv for maximal verbosity)

<img src="pic/42.png">

<img src="pic/43.png">

<img src="pic/44.png">

**3.** Use zabbix_get as data receiver and examine zabbix agent sending’s

<img src="pic/45.png">


