# Report Here  
## Using Zabbix UI  
Create User group “Project Owners”  

<img src="Pictures/Zabbix_UGroup.png">

Create User (example “Siarhei Beliakou”), assign user to “Project Owners”, set email  

<img src="Pictures/Zabbix_User.png">

Assign to this host template of Linux  

<img src="Pictures/Zabbix_Host.png">

Create custom checks (CPU Load, Memory load, Free space on file systems, Network load)  
Create trigger with Severity HIGH, check if it works (Problem/Recovery)  

<img src="Pictures/Zabbix_Trigger.png">

Configure “Network discovery” so that, 2nd VM will be joined to Zabbix (group “Project Hosts”, Template “Template OS Linux”)  

<img src="Pictures/Zabbix_Discovery.png">

Use zabbix\_sender to send data to server manually (use zabbix\_sender with key –vv for maximal verbosity)  

<img src="Pictures/Zabbix_Sender.png">

Use zabbix\_get as data receiver and examine zabbix agent sending’s  

<img src="Pictures/Zabbix_Get.png">
