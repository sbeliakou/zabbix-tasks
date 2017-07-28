import requests
import json
from requests.auth import HTTPBasicAuth

zabbix_server_ip = "192.168.100.101"
zabbix_api_admin_name = "Admin"
zabbix_api_admin_password = "zabbix"

hgname = "CloudHosts"
tpname = "Custom Template"
hostname = "Ext agent"
ip = "192.168.100.102"


def post(request):
    headers = {'content-type': 'application/json'}
    return requests.post("http://" + zabbix_server_ip + "/api_jsonrpc.php",
                         data=json.dumps(request),
                         headers=headers,
                         auth=HTTPBasicAuth(zabbix_api_admin_name, zabbix_api_admin_password))
auth_token = post({
    "jsonrpc": "2.0",
    "method": "user.login",
    "params": {
         "user": zabbix_api_admin_name,
         "password": zabbix_api_admin_password
     },
    "auth": None,
    "id": 0
}
).json()["result"]
print "Auth token " + auth_token
group_id = None
template_id = None
try:
    group_id = post({
        "jsonrpc": "2.0",
        "method": "hostgroup.get",
        "params": {
            "output": "extend",
            "filter": {
                "name": [
                    hgname
                ]
            }
        },
        "auth": auth_token,
        "id": 1
    }).json()["result"][0]["groupid"]
    print "Group id " + group_id
except IndexError:
    group_id = post({
        "jsonrpc": "2.0",
        "method": "hostgroup.create",
        "params": {
            "name": hgname
        },
        "auth": auth_token,
        "id": 1
    }).json()["result"]["groupids"][0]
    print "Group id in exception " + group_id
print "Check group id " + group_id
try:
    template_id = post({
        "jsonrpc": "2.0",
        "method": "template.get",
        "params": {
            "output": "extend",
            "filter": {
                "host": [
                    tpname
                ]
            }
        },
        "auth": auth_token,
        "id": 1
    }).json()["result"][0]["templateid"]
except IndexError:
    template_id = post(
        {
            "jsonrpc": "2.0",
            "method": "template.create",
            "params": {
                "host": tpname,
                "groups": {
                    "groupid": group_id
                },
            },
            "auth": auth_token,
            "id": 1
        }
    ).json()["result"]["templateids"][0]
print "Check tpid " + template_id
host_id = post({
    "jsonrpc": "2.0",
    "method": "host.create",
    "params": {
        "host": hostname,
        "interfaces": [
            {
                "type": 1,
                "main": 1,
                "useip": 1,
                "ip": "127.0.0.1",
                "dns": "",
                "port": "10050"
            },
            {
                "type": 4,
                "main": 1,
                "useip": 1,
                "ip": "127.0.0.1",
                "dns": "",
                "port": "8097"
            }
        ],
        "groups": [
            {
                "groupid": group_id
            }
        ],
        "templates": [
            {
                "templateid": template_id
            }
        ],
    },
    "auth": auth_token,
    "id": 1
}).json()["result"]["hostids"][0]
print "Host created!"
host_interfaces_id = post({
    "jsonrpc": "2.0",
    "method": "hostinterface.create",
    "params": [
        {
            "hostid": host_id,
            "dns": "",
            "ip": ip,
            "main": 0,
            "port": "10050",
            "type": 1,
            "useip": 1
        },
        {
            "hostid": host_id,
            "dns": "",
            "ip": ip,
            "main": 0,
            "port": "8097",
            "type": 4,
            "useip": 1
        }
    ],
    "auth": auth_token,
    "id": 1
}).json()["result"]["interfaceids"]
items_id = post({
    "jsonrpc": "2.0",
    "method": "item.create",
    "params": [
        {   # item 0
            "name": "Zbx check",
            "key_": "agent.hostname",
            "hostid": host_id,
            "type": 0,
            "value_type": 4,
            "interfaceid": host_interfaces_id[0],
            "delay": 30
        },
        {   # item 1
            "name": "Zabbix enabled items count",
            "key_": "zabbix[items]",
            "hostid": host_id,
            "type": 5,
            "value_type": 3,
            "interfaceid": host_interfaces_id[0],
            "delay": 30
        },
        {   # item 2
            "name": "Zabbix enabled hosts count",
            "key_": "zabbix[hosts]",
            "hostid": host_id,
            "type": 5,
            "value_type": 3,
            "interfaceid": host_interfaces_id[0],
            "delay": 30
        },
        {   # item 3
            "name": "Zabbix 80 port check",
            "key_": "net.tcp.service[" + zabbix_server_ip + "]",
            "hostid": host_id,
            "type": 0,
            "value_type": 3,
            "interfaceid": host_interfaces_id[0],
            "delay": 30
        },
        {   # item 4
            "name": "Zabbix DB (3306 port) check",
            "key_": "net.tcp.service[" + zabbix_server_ip + "]",
            "hostid": host_id,
            "type": 0,
            "value_type": 3,
            "interfaceid": host_interfaces_id[0],
            "delay": 30
        },
        {   # item 5
            "name": "Tomcat 80 port check",
            "key_": "net.tcp.service[" + ip + "]",
            "hostid": host_id,
            "type": 0,
            "value_type": 3,
            "interfaceid": host_interfaces_id[0],
            "delay": 30
        },
        {   # item 6
            "name": "Tomcat 8080 port check",
            "key_": "net.tcp.service[" + ip + "]",
            "hostid": host_id,
            "type": 0,
            "value_type": 3,
            "interfaceid": host_interfaces_id[0],
            "delay": 30
        },
        {   # item 7
            "name": "CPU num max",
            "key_": "system.cpu.num[max]",
            "hostid": host_id,
            "type": 0,
            "value_type": 3,
            "interfaceid": host_interfaces_id[0],
            "delay": 60
        },
        {   # item 8
            "name": "CPU load",
            "key_": "system.cpu.load[all,avg1]",
            "hostid": host_id,
            "type": 0,
            "value_type": 0,
            "interfaceid": host_interfaces_id[0],
            "delay": 5
        },
        {   # item 9
            "name": "Calculated CPU load per core avg 1 min",
            "key_": "system.cpu.load[,avg1]",
            "hostid": host_id,
            "type": 0,
            "value_type": 0,
            "interfaceid": host_interfaces_id[0],
            "formula": "avg(\"system.cpu.load[all,avg1]\",60)/last(\"system.cpu.num[max]\")",
            "delay": 60
        },
        {   # item 10
            "name": "Calculated CPU load per core avg 5 min",
            "key_": "system.cpu.load[,avg5]",
            "hostid": host_id,
            "type": 0,
            "value_type": 0,
            "interfaceid": host_interfaces_id[0],
            "formula": "avg(\"system.cpu.load[all,avg1]\",300)/last(\"system.cpu.num[max]\")",
            "delay": 300
        },
        {   # item 11
            "name": "CPU load per core avg 15 min",
            "key_": "system.cpu.load[,avg15]",
            "hostid": host_id,
            "type": 0,
            "value_type": 0,
            "interfaceid": host_interfaces_id[0],
            "formula": "avg(\"system.cpu.load[all,avg1]\",900)/last(\"system.cpu.num[max]\")",
            "delay": 900
        },
        {   # item 12
            "name": "Java Heap Memory Item",
            "key_": "jmx[\"java.lang:type=Memory\",HeapMemoryUsage.committed]",
            "hostid": host_id,
            "type": 16,
            "value_type": 0,
            "interfaceid": host_interfaces_id[1],
            "delay": 30
        }
    ],
    "auth": auth_token,
    "id": 1
}).json()
print items_id
print "Host interface created"
graph_create = post({
    "jsonrpc": "2.0",
    "method": "graph.create",
    "params": {
        "name": "My custom graph",
        "width": 900,
        "height": 200,
        "gitems": [
            {
                "itemid": items_id[12],
                "color": "00AA00"
            },
        ]
    },
    "auth": auth_token,
    "id": 1
})
print "End"
