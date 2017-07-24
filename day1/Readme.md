# Task 1. Zabbix. Basics
### Create User group "Project Owners"
<img src="pict/Screenshot Basics 1.1.png">

### Create User (example “Siarhei Beliakou”), assign user to “Project Owners”, set email
<img src="pict/Screenshot Basics 2.1.png">
<img src="pict/Screenshot Basics 2.2.png">

### Add 2nd VM to zabbix: create Host group (“Project Hosts”), create Host in this group, enable ZABBIX Agent monitoring, assign to  this host template of Linux
<img src="pict/Screenshot Basics 3.1.png">

### Create custom checks (CPU Load, Memory load, Free space on file systems, Network load)
<img src="pict/Screenshot Basics 4.1.png">

### Create trigger with Severity HIGH, check if it works (Problem/Recovery)
<img src="pict/Screenshot Basics 5.1.png">
<img src="pict/Screenshot Basics 5.2.png">
<img src="pict/Screenshot Basics 5.3.png">

### Create Action to inform “Project Owners” if HIGH triggers happen
<img src="pict/Screenshot Basics 6.1.png">
<img src="pict/Screenshot Basics 6.2.png">
<img src="pict/Screenshot Basics 6.3.png">
<img src="pict/Screenshot Basics 6.4.png">

### Configure “Network discovery” so that, 2nd VM will be joined to Zabbix (group “Project Hosts”, Template “Template OS Linux”)
<img src="pict/Screenshot Basics 7.1.png">
<img src="pict/Screenshot Basics 7.2.png">
<img src="pict/Screenshot Basics 7.3.png">

# Task 2. Zabbix Tools
### Use zabbix_sender to send data to server manually
<img src="pict/Tools 1.1.png">
<img src="pict/Tools 1.2.png">

### Use zabbix_get as data receiver and examine zabbix agent sending’s
<img src="pict/Tools 2.1.png">
