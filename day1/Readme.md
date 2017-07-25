##  Task 1 - Zabbix Basics:
- Create User group “Project Owners” 
<img src="Screens/Screenshot from 2017-07-24 18-22-25.png">

- Create User (example “Siarhei Beliakou”), assign user to “Project Owners”, set email
<img src="Screens/Screenshot from 2017-07-24 18-29-39.png">
<img src="Screens/Screenshot from 2017-07-24 18-29-49.png">

- Add 2nd VM to zabbix: create Host group (“Project Hosts”), create Host in this group, enable ZABBIX Agent monitoring
<img src="Screens/Screenshot from 2017-07-24 18-47-07.png">
<img src="Screens/Screenshot from 2017-07-24 18-47-58.png">

- Assign to this host template of Linux 
<img src="Screens/Screenshot from 2017-07-24 18-49-41.png">
<img src="Screens/Screenshot from 2017-07-24 18-51-29.png">

- Create custom checks (CPU Load, Memory load, Free space on file systems, Network load)
<img src="Screens/Screenshot from 2017-07-24 18-58-49.png">
<img src="Screens/Screenshot from 2017-07-24 19-33-09.png">
<img src="Screens/Screenshot from 2017-07-24 19-33-22.png">
<img src="Screens/Screenshot from 2017-07-24 19-33-34.png">
<img src="Screens/Screenshot from 2017-07-24 19-32-56.png">

- Create trigger with Severity HIGH, check if it works (Problem/Recovery)
<img src="Screens/Screenshot from 2017-07-24 19-55-55.png">
<img src="Screens/Screenshot from 2017-07-24 20-01-08.png">
<img src="Screens/Screenshot from 2017-07-24 20-26-53.png">

- Create Action to inform “Project Owners” if HIGH triggers happen
<img src="Screens/Screenshot from 2017-07-24 20-38-07.png">
<img src="Screens/Screenshot from 2017-07-24 20-46-34.png">
<img src="Screens/Screenshot from 2017-07-24 20-46-41.png">
<img src="Screens/Screenshot from 2017-07-24 20-46-51.png">
<img src="Screens/Screenshot from 2017-07-24 21-13-56.png">
<img src="Screens/Screenshot from 2017-07-24 21-18-38.png">
<img src="Screens/Screenshot from 2017-07-24 21-18-52.png">

- Configure “Network discovery” so that, 2nd VM will be joined to Zabbix (group “Project Hosts”, Template “Template OS Linux”)
<img src="Screens/Screenshot from 2017-07-24 21-46-44.png">
<img src="Screens/Screenshot from 2017-07-24 21-58-36.png">
<img src="Screens/Screenshot from 2017-07-24 22-01-49.png">

##  Task 2 - Zabbix Tools:
- Use zabbix_sender to send data to server manually (use zabbix_sender with key –vv for maximal verbosity).
<img src="Screens/Screenshot from 2017-07-24 22-15-51.png">
<img src="Screens/Screenshot from 2017-07-24 22-18-24.png">

- Use zabbix_get as data receiver and examine zabbix agent sending’s
<img src="Screens/Screenshot from 2017-07-24 22-20-43.png">
