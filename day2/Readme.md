## Task. Java Monitoring with Java

**Task:**

You should install and configure Zabbix server and agents.

Testing Infrastructure:

  Vagrantfile to spin up 2 VMs (virtualbox):

    - Zabbix server, provisioned by Vagrant provisioner

    - Zabbix agents on both VMs, provisioned by Vagrant provisioner

    - Install Tomcat 7 on 2nd VM

**Tasks:**
  * Configure Zabbix to examine Java parameters via Java Gateway (http://jmxmonitor.sourceforge.net/jmx.html)
  * Configure triggers to alert once these parameters changed.

  *For both VMs use vagrant box “sbeliakou/centos-7.3-x86_64-minimal”*
