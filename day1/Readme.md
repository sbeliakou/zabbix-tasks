## Task 1. Zabbix. Basics

**Testing Infrastructure:**
Vagrantfile to spin up 2 VMs (virtualbox):
- zabbix server, provisioned by Vagrant provisioner
- Zabbix agents on both VMs, provisioned by Vagrant provisioner
Configure zabbix to work on the server directly without /zabbix
http ://zabbix-server/zabbix -> http://zabbix-server

## Task
  You should install and configure Zabbix server and agents.

**1. Using Zabbix UI:**
  * Create User group “Project Owners”
  <img src="images/1.png">

  * Create User (example “Siarhei Beliakou”), assign user to “Project Owners”, set
email
  <img src="images/2.png">
  <img src="images/3.png">
  <img src="images/4.png">


  * Add 2nd VM to zabbix: create Host group (“Project Hosts”), create Host in this
group, enable ZABBIX Agent monitoring
  <img src="images/5.png">
  <img src="images/6.png">

  * Assign to this host template of Linux
  <img src="images/7.png">

  * Create custom checks (CPU Load, Memory load, Free space on file systems, Network load)
      custom keys:
        system.cpu.load[ ,]
        proc.mem[,sum]
        vfs.fs.size[/,free]
        net.if.in[enp0s8]
        net.if.out[enp0s8]
      Example:
      <img src="images/8.png">

  * Create trigger with Severity HIGH, check if it works (Problem/Recovery)
    <img src="images/9.png">

  * Create Action to inform “Project Owners” if HIGH triggers happen
  <img src="images/10.png">
  <img src="images/11.png">
  <img src="images/12.png">
  <img src="images/13.png">
  <img src="images/14.png">

  For both VMs use vagrant box “sbeliakou/centos-7.3-x86_64-minimal”

  **2. Using Zabbix UI:**
  * Configure “Network discovery” so that, 2nd VM will be joined to Zabbix (group “Project Hosts”, Template “Template OS Linux”)
  <img src="images/15.png">
  !<img src="images/16.png">
  <img src="images/17.png">
  <img src="images/18.png">
  <img src="images/19.png">
  <img src="images/20.png">


## Task. Zabbix Tools

**Testing Infrastructure:**
Vagrantfile to spin up 2 VMs (virtualbox):
 - zabbix server, provisioned by Vagrant provisioner
 - Linux VM with zabbix agent, script for registration on zabbix server, all provisioned by Vagrant provisioner

## Task

  * Configure the agent for replying to the specific server in passive and active mode.

  * Use zabbix_sender to send data to server manually (use zabbix_sender with key –vv for maximal verbosity).
  <img src="images/2-1.png">
  <img src="images/2-2.png">
  <img src="images/2-3.png">
  <img src="images/2-4.png">

  * Use zabbix_get as data receiver and examine zabbix agent sending’s.
  <img src="images/2-5.png">
For both VMs use vagrant box “sbeliakou/centos-7.3-x86_64-minimal”
