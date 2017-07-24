# Task1. Zabbiks Basics
## all job procces in pictures attached
1.Configure zabbix to work on the server directly without /zabbix 
sol: add virtualhost block to httpd.conf

2.Create User group “Project Owners”
sol: administration -> UG -> create UG, then set group name and add user if such exists, 
in permissions tab i will add project hosts  later

3.Create User (example “Siarhei Beliakou”), assign user to “Project Owners”, set email
sol: administartion -> users -> create new user,
set alias, name surname and group for user
In Media tab choose Email and type it in Send to field, also I unselected some severely checkboxes

4.Add 2nd VM to zabbix: create Host group (“Project Hosts”), create Host in this group, 
enable ZABBIX Agent monitoring
sol: Configuration -> Host groups -> create new, set group name and add hosts if they are exist
in Hosts tab set host name, visible name and group, set agent ip addr and port
in Templates tab select Template OS Linux

5.Create custom checks (CPU Load, Memory load, Free space on file systems, Network load)
sol: in created host click items -> create item, set name, type, key value, for example system.cpu.load[,]
set data and information types, choose applications -> add

6.Create trigger with Severity HIGH, check if it works (Problem/Recovery)
sol: created host click triggers, set name, severity, expression

7.Create Action to inform “Project Owners” if HIGH triggers happen
sol: change values in Administration -> media types -> Email to valid
configuration -> action -> triggers event -> new
set name, conditions, in operation tab add operations like:

Send message to users: asemirski (Aliaksei Semriski) via Email
Send message to user groups: Project Owners via Email

note: user must have access to host group for which email sending configured

8.Configure “Network discovery” so that, 2nd VM will be joined to Zabbix (group “Project Hosts”, Template “Template OS Linux”)
sol: configuration -> discovery -> local network -> set ip range as 192.168.56.1-254
set delay, i set 5 sec

Actions tab -> select Discovery -> Auto discovery action
configure ip range and in operations tab add operations like:

Add to host groups: Project Hosts
Link to templates: Template OS Linux
