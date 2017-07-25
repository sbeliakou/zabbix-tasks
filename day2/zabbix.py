import requests
import json
from requests.auth import HTTPBasicAuth

def main():
    zabbix_server = "192.168.56.70/zabbix"
    zabbix_api_admin_name = "Admin"
    zabbix_api_admin_password = "zabbix"
    hostname = "host-agent1"
    ip = "192.168.56.71"
    templatename="Custom template"

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
        "id": 1
    }).json()["result"]

    hostgroupid=post({
        "jsonrpc": "2.0",
        "method": "hostgroup.get",
        "params": {
            "output": "extend",
            "filter": {
                "name": "CloudHosts"
            }
        },
        "auth": auth_token,
        "id": 1
    }).json()["result"]
    if(not hostgroupid):
        hostgroupid = (post({
            "jsonrpc": "2.0",
            "method": "hostgroup.create",
            "params": {
                "name": "CloudHosts"
            },
            "auth": auth_token,
            "id": 1
        }).json()["result"]).__getitem__('groupids')[0]
    else:
        hostgroupid = hostgroupid[0].__getitem__('groupid')

    templateid = post({
        "jsonrpc": "2.0",
        "method": "template.get",
        "params": {
            "output": "extend",
            "filter": {
                "host": templatename
            }
        },
        "auth": auth_token,
        "id": 1
    }).json()["result"]

    if(not templateid):
        templateid=(post({
        "jsonrpc": "2.0",
        "method": "template.create",
        "params": {
            "host": templatename,
            "groups": {
                "groupid": hostgroupid
            }
        },
        "auth": auth_token,
        "id": 1
    }).json()["result"]).__getitem__('templateids')[0]
    else:
        templateid = templateid[0].__getitem__('templateid')

    def register_host (hostname, ip):
        post({
        "jsonrpc": "2.0",
        "method": "host.create",
        "params": {
            "host": hostname,
            "templates": [{
                "templateid": templateid
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
                {"groupid": hostgroupid}
            ]
        },
        "auth": auth_token,
        "id": 1
    })

    hostid = post({
            "jsonrpc": "2.0",
            "method": "host.get",
            "params": {
                "output": "extend",
                "filter": {
                    "host": hostname
                }
            },
            "auth": auth_token,
            "id": 1
        }).json()["result"]
    if(not hostid):
        register_host(hostname, ip)
if __name__ == '__main':
    main()
