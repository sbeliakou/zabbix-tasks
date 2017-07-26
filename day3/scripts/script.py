#!/usr/bin/python
import os, requests, json, sys, socket
from requests.auth import HTTPBasicAuth

zabbix_server = "192.168.56.10"
zabbix_api_admin_name = "Admin"
zabbix_api_admin_password = "zabbix"
zabbix_api_group_name = "CloudHosts"
zabbix_api_hostname = socket.gethostname()
zabbix_api_hostname_ip = "192.168.56.11"
zabbix_api_template_name = "Custom CloudHosts Template"

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


def register_group(group_name):
    return post({
        "jsonrpc": "2.0",
        "method": "hostgroup.create",
        "params": {
            "name": group_name
        },
        "auth": auth_token,
        "id": 1
    })


def register_template(template_name, group_id):
    return post({
        "jsonrpc": "2.0",
        "method": "template.create",
        "params": {
            "host": template_name,
            "groups": {
                "groupid": group_id
            }
        },
        "auth": auth_token,
        "id": 1
    })


def register_host(hostname, ip, group_id, template_id):
    return post({
        "jsonrpc": "2.0",
        "method": "host.create",
        "params": {
            "host": hostname,
            "templates": [{
                "templateid": template_id
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
                {"groupid": group_id}
            ]
        },
        "auth": auth_token,
        "id": 1
    })


def check_existence(name, method):
    answer = post({
        "jsonrpc": "2.0",
        "method": method,
        "params": {
            "output": "extend",
            "filter": {
                "host": [
                    name
                ],
                "name": [
                    name
                ]
            }
        },
        "auth": auth_token,
        "id": 1
    })
    if len(answer.json()["result"]) > 0:
        if 'hostgroup.get' in method:
            return answer.json()["result"][0]["groupid"]
        elif 'host.get' in method:
            return answer.json()["result"][0]["hostid"]
        elif 'template.get' in method:
            return answer.json()["result"][0]["templateid"]
    else:
        return None


# Register group
zabbix_api_group_id = check_existence(zabbix_api_group_name, "hostgroup.get")
if zabbix_api_group_id is not None:
    print("Group {} already exists with id: {}!".format(zabbix_api_group_name, zabbix_api_group_id))
else:
    zabbix_api_group_id = register_group(zabbix_api_group_name).json()["result"]["groupids"][0]
    print('New group {} with id: {} was successfully created'.format(zabbix_api_group_name, zabbix_api_group_id))

# Register custom template
zabbix_api_template_id = check_existence(zabbix_api_template_name, "template.get")
if zabbix_api_template_id is not None:
    print("Template {} already exists with id: {}!".format(zabbix_api_template_name, zabbix_api_template_id))
else:
    zabbix_api_template_id = register_template(zabbix_api_template_name, zabbix_api_group_id).json()["result"]["templateids"][0]
    print('New template {} with id: {} was successfully created'.format(zabbix_api_template_name, zabbix_api_template_id))

# Register host
zabbix_api_hostname_id = check_existence(zabbix_api_hostname, "host.get")
if zabbix_api_hostname_id is not None:
    print("Host {} already exists with id: {}!".format(zabbix_api_hostname, zabbix_api_hostname_id))
else:
    zabbix_api_hostname_id = register_host(zabbix_api_hostname, zabbix_api_hostname_ip, zabbix_api_group_id, zabbix_api_template_id).json()["result"]["hostids"][0]
    print('New host {} with id: {} was successfully created and added to group id {} and template {}'.format(zabbix_api_hostname, zabbix_api_hostname_id, zabbix_api_group_id, zabbix_api_template_id))

