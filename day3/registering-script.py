import os, requests, json, sys
from requests.auth import HTTPBasicAuth

zabbix_server = "192.168.56.10"
zabbix_api_admin_name = "Admin"
zabbix_api_admin_password = "zabbix"

hgname = "CloudHosts"
tpname = "Custom Template"
hostname = "Tomcat"
ip = "192.168.56.11"


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
    "id": 0
}
).json()["result"]
print auth_token

#sorry
try:
    get_hg=post({
        "jsonrpc": "2.0",
        "method": "hostgroup.get",
        "params": {
            "output": "extend",
            "filter": {
                "name": [
                    "CloudHosts"
                ]
            }
        },
        "auth": auth_token,
        "id": 1
    }).json()["result"][0]["name"]
    print "group already exists! => all other conditions observed "
except IndexError:
    if True:
        group_token = post({
            "jsonrpc": "2.0",
            "method": "hostgroup.create",
            "params": {
                "name": hgname
            },
            "auth": auth_token,
            "id": 1
        }).json()["result"]["groupids"][0]
        print group_token

    template_token = post(
        {
            "jsonrpc": "2.0",
            "method": "template.create",
            "params": {
                "host": tpname,
                "groups": {
                    "groupid": group_token
                },
            },
            "auth": auth_token,
            "id": 1
        }
    ).json()["result"]["templateids"][0]
    print template_token

    host_creator = post({
        "jsonrpc": "2.0",
        "method": "host.create",
        "params": {
            "host": hostname,
            "interfaces": [
                {
                    "type": 1,
                    "main": 1,
                    "useip": 1,
                    "ip": ip,
                    "dns": "",
                    "port": "10050"
                }
            ],
            "groups": [
                {
                    "groupid": group_token
                }
            ],
            "templates": [
                {
                    "templateid": template_token
                }
            ],
        },
        "auth": auth_token,
        "id": 1
    })
    print "done!"
