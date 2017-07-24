# Task. Zabbix. Basics
## 1. Using Zabbix UI:
### Create User group “Project Owners” 
<img src="/day1/task1/1.jpg">

### Create User (example “Siarhei Beliakou”), assign user to “Project Owners”, set email
<img src="/day1/task1/2.jpg">
<img src="/day1/task1/3.jpg">

### Add 2nd VM to zabbix: create Host group (“Project Hosts”), create Host in this group, enable ZABBIX Agent monitoring
<img src="/day1/task1/4.jpg">
<img src="/day1/task1/5.jpg">

### Assign to this host template of Linux
<img src="/day1/task1/6.jpg">

### Create custom checks (CPU Load, Memory load, Free space on file systems, Network load)
<img src="/day1/task1/7.jpg">
<img src="/day1/task1/8.jpg">
<img src="/day1/task1/9.jpg">
<img src="/day1/task1/10.jpg">

### Create trigger with Severity HIGH, check if it works (Problem/Recovery)
<img src="/day1/task1/11.jpg">
<img src="/day1/task1/12.jpg">

### Create Action to inform “Project Owners” if HIGH triggers happen
<img src="/day1/task1/13.jpg">
<img src="/day1/task1/14.jpg">
<img src="/day1/task1/15.jpg">
<img src="/day1/task1/16.jpg">
<img src="/day1/task1/17.jpg">

## 2. Using Zabbix UI:
### Configure “Network discovery” so that, 2nd VM will be joined to Zabbix (group “Project Hosts”, Template “Template OS Linux”)
<img src="/day1/task1/18.jpg">
<img src="/day1/task1/19.jpg">
<img src="/day1/task1/20.jpg">



