#  Task. Zabbix. Java Monitoring with Java

## Vagrantfile:

```ruby
Vagrant.configure("2") do |config|
  config.vm.define "zabbix" do |zabbix|
    zabbix.vm.box = "zabbix"
    zabbix.vm.hostname = 'zabbix'
    zabbix.vm.box_url = "sbeliakou-vagrant-centos-7.3-x86_64-minimal.box"
    zabbix.vm.network :forwarded_port, guest: 80, host: 8080, auto_correct: true
    zabbix.vm.network :private_network, ip: "192.168.56.101"
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
    agent.vm.network :private_network, ip: "192.168.56.111"
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
# 1. Configure Zabbix to examine Java parameters via Java Gateway

Connecting via terminal

<img src="pictures/Screenshot from 2017-07-25 14-13-27.png">

Setting host

<img src="pictures/Screenshot from 2017-07-25 15-54-31.png">

Connected

<img src="pictures/Screenshot from 2017-07-25 15-54-36.png">

Custom items:

<img src="pictures/Screenshot from 2017-07-25 15-54-50.png">

<img src="pictures/Screenshot from 2017-07-25 15-55-00.png">

<img src="pictures/Screenshot from 2017-07-25 16-00-56.png">

# 2. Configure triggers to alert once these parameters changed

Creating trigger

<img src="pictures/Screenshot from 2017-07-25 16-09-56.png">

Warning after creating CPU load

<img src="pictures/Screenshot from 2017-07-25 16-11-18.png"

#  Task. Zabbix. Web Monitoring with Zabbix

## 1. Configure WEB check

Tomcat web face:

<img src="pictures/Screenshot from 2017-07-25 16-21-26.png">

Web app:

<img src="pictures/Screenshot from 2017-07-25 16-22-58.png">

Total:

<img src="pictures/Screenshot from 2017-07-25 16-27-44.png">

Results:

<img src="pictures/Screenshot from 2017-07-25 16-27-10.png">

# 2. Configure Triggers to alert once WEB resources become unavailable

Creating trigger

<img src="pictures/Screenshot from 2017-07-25 16-33-04.png">

After stoping tomcat

<img src="pictures/Screenshot from 2017-07-25 16-34-17.png">

#  Task. Zabbix Zabbix API

```python
import requests, json, sys
from requests.auth import HTTPBasicAuth

zabbix_server = sys.argv[1]#"192.168.56.101/zabbix"
zabbix_api_admin_name = sys.argv[2]#"Admin"
zabbix_api_admin_password = sys.argv[3]#"zabbix"
group_name = sys.argv[4]#"CloudHosts"
template_name = sys.argv[5]#"Custom template"
host_name = sys.argv[6]#"Hostname"
host_ip = sys.argv[7]#"192.168.56.111"

def post(request):
    headers = {'content-type': 'application/json'}
    return requests.post(
        "http://" + zabbix_server + "/api_jsonrpc.php",
         data=json.dumps(request),
         headers=headers,
         auth=HTTPBasicAuth(zabbix_api_admin_name, zabbix_api_admin_password)
    )

auth_token = post({
    "jsonrpc": "2.0",
    "method": "user.login",
    "params": {
         "user": zabbix_api_admin_name,
         "password": zabbix_api_admin_password
     },
    "auth": None,
    "id": 0}
).json()["result"]


def register_host(hostname, ip, group, template):
    return post({
        "jsonrpc": "2.0",
        "method": "host.create",
        "params": {
            "host": hostname,
            "templates": [{
                "templateid": template
            }],
            "interfaces": [{
                "type": 1,
                "main": 1,
                "useip": 1,
                "ip": ip,
                "dns": "",
                "port": "10050"
            }],
            "groups": [
                {"groupid": group}
            ]
        },
        "auth": auth_token,
        "id": 1
    })

def check_group(name):
    reply = post({
        "jsonrpc": "2.0",
        "method": "hostgroup.get",
        "params": {
            "output": "extend",
            "filter": {
                "name": name
            }
        },
        "auth": auth_token,
        "id": 1
    }).json()["result"]
    if reply.__len__() > 0:
        return int(reply[0]['groupid'])
    else: return False

def check_template(name):
    reply = post({
        "jsonrpc": "2.0",
        "method": "template.get",
        "params": {
            "output": "extend",
            "filter": {
                "name": name
            }
        },
        "auth": auth_token,
        "id": 1
    }).json()["result"]
    if reply.__len__() > 0:
        return int(reply[0]['templateid'])
    else: return False

def create_group(name):
    return int(post({
        "jsonrpc": "2.0",
        "method": "hostgroup.create",
        "params": {
            "name": name
        },
        "auth": auth_token,
        "id": 1
    }).json()["result"]['groupids'][0])

def create_template(name, group):
    return int(post({
        "jsonrpc": "2.0",
        "method": "template.create",
        "params": {
            "host": name,
            "groups": {
                "groupid": group
            }
        },
        "auth": auth_token,
        "id": 1
    }).json()["result"]['templateids'][0])

group_id = check_group(group_name)
if group_id == False:
    group_id = create_group(group_name)
    print "Group", group_name,"created"


template_id = check_template(template_name)
if template_id == False:
    template_id = create_template(template_name, group_id)
    print "Template", template_name, "created"

result = register_host(host_name, host_ip, group_id, template_id).json()

if 'error' in result:
    print "Error!!!:", result['error']['data']
else:
    print "Host", host_name, "with ip", host_ip, "and template", template_name, "created and added to group", group_name
```

