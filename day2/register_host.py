import requests
import json
import platform
from requests.auth import HTTPBasicAuth


def main():

    group_name = "CloudHosts"
    custom_template_name = "CustomTemplate"
    zabbix_server = "192.168.56.10/zabbix"
    zabbix_api_admin_name = "Admin"
    zabbix_api_admin_password = "zabbix"

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
        "id": 0}).json()

    if('error' in auth_token.keys()):
        print("authentication error")
    else:
        auth_token = auth_token.__getitem__('result')

    id_group = post({
        "jsonrpc": "2.0",
        "method": "hostgroup.get",
        "params": {
            "output": "extend",
            "filter": {
                "name": [
                    group_name
                ]
            }
        },
        "auth": auth_token,
        "id": 1
    }).json()["result"]
    if(not id_group):
        id_group = (post({
        "jsonrpc": "2.0",
        "method": "hostgroup.create",
        "params": {
            "name": group_name
        },
        "auth": auth_token,
        "id": 1 }).json()["result"]).__getitem__('groupids')[0]
    else:
        id_group = id_group[0].__getitem__('groupid')


    template_id = post({
        "jsonrpc": "2.0",
        "method": "template.get",
        "params": {
            "output": "extend",
            "filter": {
                "host": [
                    custom_template_name
                ]
            }
        },
        "auth": auth_token,
        "id": 1
    }).json()["result"]
    if(not template_id):
        template_id = post({
        "jsonrpc": "2.0",
        "method": "template.create",
        "params": {
            "host": custom_template_name,
            "groups": {
                "groupid": id_group
            },
        },
        "auth": auth_token,
        "id": 1
    }).json()["result"].__getitem__('templateids')[0]
    else:
        template_id = template_id[0].__getitem__('templateid')


    host_id = post({
        "jsonrpc": "2.0",
        "method": "host.get",
        "params": {
            "output": "extend",
            "filter": {
                "host": [
                    str(platform.node())
                ]
            }
        },
        "auth": auth_token,
        "id": 1
    }).json()["result"]
    if(not host_id):
        host_id = post({
        "jsonrpc": "2.0",
            "method": "host.create",
            "params": {
                "host": platform.node(),
                "templates": [{
                    "templateid": template_id
                }],
                "interfaces": [{
                    "type": 1,
                    "main": 1,
                    "useip": 1,
                    "ip": "192.168.56.11",
                    "dns": "",
                    "port": "10050"
                }],
                "groups": [
                    {"groupid": id_group.__str__()},
                ]
            },
            "auth": auth_token,
            "id": 1
    })
        
if __name__ == '__main__':
    main()



