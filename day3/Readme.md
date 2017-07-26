# Day 3
# Task 1

## [Vagrantfile](Vagrantfile) to spin up 2 VMs (virtualbox):

```ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.define "zabbix_server" do |server|
    server.vm.hostname = "server"
    server.vm.box = "Centos-7.3"
    server.vm.network "forwarded_port", guest: 80, host: 8080
    server.vm.network "private_network", ip: "192.168.56.10"
    server.vm.provider "virtualbox" do |vb|
      vb.name = "Zabbix Server"
      vb.memory = "1024"
    end

    server.vm.provision "shell", path: "scripts/server.sh"
    server.vm.provision "shell", path: "scripts/agent.sh"

  end

  config.vm.define "host1" do |host1|
    host1.vm.hostname = "host-agent1"
    host1.vm.box = "Centos-7.3"
    host1.vm.network "private_network", ip: "192.168.56.11"
    host1.vm.provider "virtualbox" do |vb|
      vb.name = "Host1"
      vb.memory = "1024"
    end

    host1.vm.provision "shell", path: "scripts/agent.sh"
    host1.vm.provision "shell", path: "scripts/tomcat.sh"

  end

end
end
```
#  Task. Zabbix. Items

![alt text](https://github.com/anton-maslakou/zabbix-tasks/blob/day3/day3/imag/1.png "")
![alt text](https://github.com/anton-maslakou/zabbix-tasks/blob/day3/day3/imag/2.png "")
![alt text](https://github.com/anton-maslakou/zabbix-tasks/blob/day3/day3/imag/3.png "")
![alt text](https://github.com/anton-maslakou/zabbix-tasks/blob/day3/day3/imag/4.png "")
![alt text](https://github.com/anton-maslakou/zabbix-tasks/blob/day3/day3/imag/5.png "")

![alt text](https://github.com/anton-maslakou/zabbix-tasks/blob/day3/day3/imag/6.png "")
![alt text](https://github.com/anton-maslakou/zabbix-tasks/blob/day3/day3/imag/7.png "")
![alt text](https://github.com/anton-maslakou/zabbix-tasks/blob/day3/day3/imag/8.png "")
![alt text](https://github.com/anton-maslakou/zabbix-tasks/blob/day3/day3/imag/9.png "")
![alt text](https://github.com/anton-maslakou/zabbix-tasks/blob/day3/day3/imag/10.png "")
![alt text](https://github.com/anton-maslakou/zabbix-tasks/blob/day3/day3/imag/11.png "")
![alt text](https://github.com/anton-maslakou/zabbix-tasks/blob/day3/day3/imag/17.png "")


#  Task. Zabbix. Operations

## 1. Configure Custom graphs and screens of your infrastructure
![alt text](https://github.com/anton-maslakou/zabbix-tasks/blob/day3/day3/imag/12.png "")
![alt text](https://github.com/anton-maslakou/zabbix-tasks/blob/day3/day3/imag/13.png "")

## 2. Maintenance
![alt text](https://github.com/anton-maslakou/zabbix-tasks/blob/day3/day3/imag/14.png "")
![alt text](https://github.com/anton-maslakou/zabbix-tasks/blob/day3/day3/imag/15.png "")
![alt text](https://github.com/anton-maslakou/zabbix-tasks/blob/day3/day3/imag/16.png "")

