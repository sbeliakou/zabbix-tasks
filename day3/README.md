## Vagrantfile:

```ruby
Vagrant.configure("2") do |config|
  config.vm.define "zabbix" do |zabbix|
    zabbix.vm.box = "zabbix"
    zabbix.vm.hostname = 'zabbix'
    zabbix.vm.box_url = "sbeliakou-vagrant-centos-7.3-x86_64-minimal.box"
    zabbix.vm.network :forwarded_port, guest: 80, host: 8080
    zabbix.vm.network :private_network, ip: "192.168.56.10"
    zabbix.vm.synced_folder "share/", "/share"
    zabbix.vm.provider :virtualbox do |v|
      v.memory = "4096"
      v.name = "zabbixVM"
    end
    zabbix.vm.provision "shell", inline: <<-SHELL
    sudo su
    chmod +x /share/scripts/server.sh
    /share/scripts/server.sh
    SHELL
  end

  config.vm.define "agent" do |agent|
    agent.vm.box = "agent"
    agent.vm.hostname = 'agent'
    agent.vm.box_url = "sbeliakou-vagrant-centos-7.3-x86_64-minimal.box"
    agent.vm.network :private_network, ip: "192.168.56.11"
    agent.vm.synced_folder "share/", "/share"
    agent.vm.provider :virtualbox do |v|
      v.memory = "2048"
      v.name = "agent"
    end
    agent.vm.provision "shell", inline: <<-SHELL
    sudo su
    chmod +x /share/scripts/agent.sh
    /share/scripts/agent.sh
    SHELL
  end

end
```
#  Task. Zabbix. Items

## 1. Simple checks:

Zabbix Server WEB availability

<img src="pictures/Screenshot from 2017-07-26 13-24-32.png">

Zabbix DB is available

<img src="pictures/Screenshot from 2017-07-26 17-40-17.png">

Tomcat availability

<img src="pictures/Screenshot from 2017-07-26 13-28-00.png">

<img src="pictures/Screenshot from 2017-07-26 17-40-44.png">

Tomcat Server is available by ssh

<img src="pictures/Screenshot from 2017-07-26 17-43-33.png">

## 2. Calculated Checks:

<img src="pictures/Screenshot from 2017-07-26 15-14-19.png">

<img src="pictures/Screenshot from 2017-07-26 15-14-27.png">

CPU Load per Core (1min)

<img src="pictures/Screenshot from 2017-07-26 15-14-13.png">

<img src="pictures/Screenshot from 2017-07-26 15-13-40.png">

CPU Load per Core (5min)

<img src="pictures/Screenshot from 2017-07-26 15-17-14.png">

CPU Load per Core (15min)

<img src="pictures/Screenshot from 2017-07-26 15-18-59.png">

## 3. Internal Checks:

How many items are enabled:

<img src="pictures/Screenshot from 2017-07-26 15-39-41.png">

How many Servers are being monitored:

<img src="pictures/Screenshot from 2017-07-26 15-42-50.png">

<img src="pictures/Screenshot from 2017-07-26 15-44-26.png">

## 4. Create triggers for every check

<img src="pictures/Screenshot from 2017-07-26 16-10-16.png">

<img src="pictures/Screenshot from 2017-07-26 16-11-16.png">

<img src="pictures/Screenshot from 2017-07-26 16-13-11.png">

<img src="pictures/Screenshot from 2017-07-26 16-21-58.png">

## 5. Logs

Create item and develop custom trigger for log monitoring:

<img src="pictures/Screenshot from 2017-07-26 14-57-17.png">

Create a trigger for errors in log file monitored by that item:

<img src="pictures/Screenshot from 2017-07-26 16-10-16.png">

Shutting down Tomcat:

<img src="pictures/Screenshot from 2017-07-26 15-26-46.png">


#  Task. Zabbix. Operations

## 1. Configure Custom graphs and screens of your infrastructure

Graph

<img src="pictures/Screenshot from 2017-07-26 17-15-30.png">

Screens:

<img src="pictures/Screenshot from 2017-07-26 17-15-07.png">

## 2. Maintenance

<img src="pictures/Screenshot from 2017-07-26 16-33-31.png">

<img src="pictures/Screenshot from 2017-07-26 16-33-02.png">

<img src="pictures/Screenshot from 2017-07-26 16-44-28.png">
