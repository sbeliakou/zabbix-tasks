# Task 1. Zabbix. Basics
* Create User group “Project Owners”
<img src="Screenshot from 2017-07-24 19-24-16.png">
<img src="Screenshot from 2017-07-24 19-24-30.png">
<img src="Screenshot from 2017-07-24 19-24-57.png">
* Create User (example “Siarhei Beliakou”), assign user to “Project Owners”, set email
<img src="Screenshot from 2017-07-24 19-25-07.png">
<img src="Screenshot from 2017-07-24 19-25-43.png">
* Add 2nd VM to zabbix: create Host group (“Project Hosts”), create Host in this group, enable ZABBIX Agent monitoring
<img src="Screenshot from 2017-07-24 19-26-25.png">
* Assign to this host template of Linux
<img src="Screenshot from 2017-07-24 19-27-57.png">
<img src="Screenshot from 2017-07-24 19-28-14.png">
<img src="Screenshot from 2017-07-24 19-28-33.png">
* Create custom checks (CPU Load, Memory load, Free space on file systems, Network load)
<img src="Screenshot from 2017-07-24 19-28-59.png">
<img src="Screenshot from 2017-07-24 19-30-20.png">
* Create trigger with Severity HIGH, check if it works (Problem/Recovery)
<img src="Screenshot from 2017-07-24 19-30-58.png">
* Create Action to inform “Project Owners” if HIGH triggers happen
<img src="Screenshot from 2017-07-24 19-31-44.png">
<img src="Screenshot from 2017-07-24 19-32-06.png">
<img src="Screenshot from 2017-07-24 19-32-16.png">
* Configure “Network discovery” so that, 2nd VM will be joined to Zabbix (group “Project Hosts”, Template “Template OS Linux”)
<img src="Screenshot from 2017-07-24 21-47-14.png">
<img src="Screenshot from 2017-07-24 19-54-20.png">
<img src="Screenshot from 2017-07-24 19-54-30.png">
<img src="Screenshot from 2017-07-24 19-55-22.png">
<img src="Screenshot from 2017-07-24 20-05-41.png">
<img src="Screenshot from 2017-07-24 20-49-24.png">
# Task 2. Zabbix Tools
* Use zabbix_sender to send data to server manually
<img src="Screenshot from 2017-07-24 20-49-47.png">
* Use zabbix_get as data receiver and examine zabbix agent sending’s
<img src="Screenshot from 2017-07-24 20-56-43.png">
<img src="Screenshot from 2017-07-24 20-56-51.png">
<img src="Screenshot from 2017-07-24 20-59-11.png">

