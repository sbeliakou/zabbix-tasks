# Day 2
# Task 1

## [Vagrantfile](Vagrantfile) to spin up 2 VMs (virtualbox):

```ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.define "zabbix_server" do |zabbix|
    zabbix.vm.box = "Centos-7.3"
    zabbix.vm.hostname = "zabbix"
    zabbix.vm.network :private_network, ip: "10.1.1.1"
    zabbix.vm.network "forwarded_port", guest: 80, host: 8080
    zabbix.vm.provider 'virtualvm' do |v|
        v.memory = "1000"
    end
    zabbix.vm.provision "shell", path: "provision/prov-zabbix.sh"
    zabbix.vm.provision "shell", path: "provision/prov-agent.sh"
  end

  config.vm.define("tomcat") do |tomcat|
        tomcat.vm.box = "Centos-7.3"
        tomcat.vm.hostname = "tomcat"
        tomcat.vm.network :private_network, ip: "10.1.1.2"
        tomcat.vm.provider 'virtualvm' do |v|
            v.memory = "500"
        end
    tomcat.vm.provision "shell", path: "provision/prov-tomcat.sh"
    tomcat.vm.provision "shell", path: "provision/prov-agent.sh"
  end
end
```


## Java Monitoring with Java
1. Tomcat installed 

![alt text](https://github.com/anton-maslakou/zabbix-tasks/blob/day2/day2/images/Picture1.png "Tomcat works")

![alt text](https://github.com/anton-maslakou/zabbix-tasks/blob/day2/day2/images/2.png "")

2. Items created
![alt text](https://github.com/anton-maslakou/zabbix-tasks/blob/day2/day2/images/3.png "")

3. Trigger created
![alt text](https://github.com/anton-maslakou/zabbix-tasks/blob/day2/day2/images/4.png "")

4. Trigger worked properly 
![alt text](https://github.com/anton-maslakou/zabbix-tasks/blob/day2/day2/images/5.png "")

# Task 2
## Task. Zabbix. Web Monitoring with Zabbix
1. Hello world app deployed
![alt text](https://github.com/anton-maslakou/zabbix-tasks/blob/day2/day2/images/6.png "")

2. Web monitoring
![alt text](https://github.com/anton-maslakou/zabbix-tasks/blob/day2/day2/images/7.png "")

3. Trigger created
![alt text](https://github.com/anton-maslakou/zabbix-tasks/blob/day2/day2/images/8.png "")

4. Trigger worked properly 
![alt text](https://github.com/anton-maslakou/zabbix-tasks/blob/day2/day2/images/9.png "")
![alt text](https://github.com/anton-maslakou/zabbix-tasks/blob/day2/day2/images/10.png "")



