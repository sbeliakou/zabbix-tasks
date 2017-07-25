import os
import requests
import json
import sys
from requests.auth import HTTPBasicAuth

zabbix_server = "zabbix"
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
    "id": 0}
).json()["result"]



def register_host(hostname, ip):
        a = post({
            "jsonrpc": "2.0",
            "method": "host.create",
            "params": {
                "host": hostname,
                "templates": [{
                    "templateid": "10001"
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
                    {"groupid": "1"},
                    {"groupid": "2"}
                ]
            },
            "auth": auth_token,
            "id": 1
        })
        return a.text

#print (register_host('test1', '192.168.56.1'))

def retrieve_host():
    a = post({
        "jsonrpc": "2.0",
        "method": "host.get",
        "params": {
            "output": [
                "hostid",
                "host"
            ],
            "selectInterfaces": [
                "interfaceid",
                "ip"
            ]
        },
        "id": 2,
        "auth": auth_token
    })
    return a.text