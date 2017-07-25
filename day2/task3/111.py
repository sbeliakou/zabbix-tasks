import os, requests, json, sys
from requests.auth import HTTPBasicAuth

zabbix_server = "192.168.56.10"
zabbix_api_admin_name = "Admin"
zabbix_api_admin_password = "zabbix"

Project_g = "CloudHosts"
Newhost = "Hostname"
Project_template = "Custom template"

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

try:
    get_cloud = post({
    "jsonrpc": "2.0",
    "method": "hostgroup.get",
    "params": {
        "output": "extend",
        "filter": {
            "host": ["CloudHosts"]
        }
    },
    "auth": auth_token,
    "id": 1}
    ).json()["result"][0]["name"]
    print "some error"
except IndexError:
    if True:
        host_group = post({
            "jsonrpc": "2.0",
            "method": "hostgroup.create",
            "params": {
                "name": Project_g
            },
            "auth": auth_token,
            "id": 1}
        ).json()["result"]["groupids"][0]
        print host_group

        template_id = post({
            "jsonrpc": "2.0",
            "method": "template.create",
            "params": {
                "host": Project_template,
                "groups": {
                    "groupid": host_group
                },
            },
            "auth": auth_token,
            "id": 1}
        ).json()["result"]["templateids"][0]
        print template_id

        host_id = post({
            "jsonrpc": "2.0",
            "method": "host.create",
            "params": {
                "host": Newhost,
                "interfaces": [
                    {
                        "type": 1,
                        "main": 1,
                        "useip": 1,
                        "ip": "192.168.56.55",
                        "dns": "",
                        "port": "10050"
                    }
                ],
                "groups": [
                    {
                        "groupid": host_group
                    }
                ],
                "templates": [
                    {
                        "templateid": template_id
                    }
                ],
                "inventory_mode": 0,
                "inventory": {
                    "macaddress_a": "01234",
                    "macaddress_b": "56768"
                }
            },
            "auth": auth_token,
            "id": 1}
        ).json()["result"]["hostids"][0]
        print host_id

