import requests
import json
from requests.auth import HTTPBasicAuth

zabbix_server = "192.168.100.101"
zabbix_api_admin_name = "Admin"
zabbix_api_admin_password = "zabbix"

hgname = "CloudHosts"
tpname = "Custom Template"
hostname = "Ext agent"
ip = "192.168.100.102"


def post(request):
    headers = {'content-type': 'application/json'}
    return requests.post("http://" + zabbix_server + "/api_jsonrpc.php",
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
                "port": "10050"
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
host_zbx_interface_id = post({
    "jsonrpc": "2.0",
    "method": "hostinterface.create",
    "params": {
        "hostid": host_id,
        "dns": "",
        "ip": ip,
        "main": 0,
        "port": "10050",
        "type": 1,
        "useip": 1
    },
    "auth": auth_token,
    "id": 1
}).json()["result"]["interfaceids"][0]
zbx_item_creator = post({
    "jsonrpc": "2.0",
    "method": "item.create",
    "params": {
        "name": "Zbx check",
        "key_": "agent.hostname",
        "hostid": host_id,
        "type": 0,
        "value_type": 3,
        "interfaceid": host_zbx_interface_id,
        "delay": 30
    },
    "auth": auth_token,
    "id": 1
})
host_jmx_interface_id = post({
    "jsonrpc": "2.0",
    "method": "hostinterface.create",
    "params": {
        "hostid": host_id,
        "dns": "",
        "ip": ip,
        "main": 0,
        "port": "8097",
        "type": 4,
        "useip": 1
    },
    "auth": auth_token,
    "id": 1
}).json()["result"]["interfaceids"][0]
print "Host interface created"
jmx_item_creator = post({
    "jsonrpc": "2.0",
    "method": "item.create",
    "params": {
        "name": "Java Heap Memory Item",
        "key_": "jmx[\"java.lang:type=Memory\",HeapMemoryUsage.committed]",
        "hostid": host_id,
        "type": 16,
        "value_type": 3,
        "interfaceid": host_jmx_interface_id,
        "delay": 30
    },
    "auth": auth_token,
    "id": 1
})
print "End"
