# Task 3. Java Monitoring with Java

## Vagrantfile to spin up 2 VMs (virtualbox):
[Vagrantfile](Vagrantfile)

* Zabbix server, provisioned by Vagrant provisioner
[server.sh](scripts/server.sh)

* Zabbix agents on both VMs, provisioned by Vagrant provisioner

* Install Tomcat 7 on 2nd VM
[server.sh](scripts/agent.sh)


1. Configure Zabbix to examine Java parameters via Java Gateway 
<img src="Screenshot from 2017-07-25 14-03-09.png">
<img src="Screenshot from 2017-07-25 14-08-47.png">
<img src="Screenshot from 2017-07-25 14-09-30.png">
<img src="Screenshot from 2017-07-25 15-32-56.png">

2. Configure triggers to alert once these parameters changed.
<img src="Screenshot from 2017-07-25 15-34-43.png">
<img src="Screenshot from 2017-07-25 15-34-34.png">
<img src="Screenshot from 2017-07-25 15-34-19.png">
<img src="Screenshot from 2017-07-25 15-33-27.png">

# Task 4. Web Monitoring with Zabbix
1. Configure WEB check:
* Scenario to test Tomcat availability as well as Application heath
<img src="Screenshot from 2017-07-25 16-02-09.png">
<img src="Screenshot from 2017-07-25 16-02-56.png">
<img src="Screenshot from 2017-07-25 15-59-28.png">

2. Configure Triggers to alert once WEB resources become unavailable
<img src="Screenshot from 2017-07-25 16-03-05.png">
<img src="Screenshot from 2017-07-25 16-05-50.png">
* Remove application from Tomcat
<img src="Screenshot from 2017-07-25 15-58-51.png">

* Testing with mistake in field "Required"
<img src="Screenshot from 2017-07-25 16-42-24.png">
<img src="Screenshot from 2017-07-25 16-42-38.png">

# Task 5. Zabbix API

* Scrypt execution results
[script.py](scripts/script.py)
<img src="Screenshot from 2017-07-25 16-44-31.png">
<img src="Screenshot from 2017-07-25 16-45-20.png">