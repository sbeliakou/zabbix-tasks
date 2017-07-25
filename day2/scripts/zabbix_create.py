import os, requests, json, sys
from requests.auth import HTTPBasicAuth
import platform
import configparser2

config = configparser2.ConfigParser()
config.read('zabbix_create.ini')
zabbix_server = config.get('common','zabbix_server')
zabbix_api_admin_name = config.get('common','zabbix_api_admin_name')
zabbix_api_admin_password = config.get('common','zabbix_api_admin_password')
hostip=config.get('common','hostip')

hostname=platform.node()

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

def group_create(groupname):
      try:
          return post({
                "jsonrpc": "2.0",
                 "method": "hostgroup.create",
                 "params": {
                     "name": groupname
                            },
                 "auth": auth_token,
                  "id": 1
            }).json()["result"]['groupid'][0]
      except:
          return post({
                      "jsonrpc": "2.0",
                      "method": "hostgroup.get",
                      "params": {
                          "filter":
                            {"name": groupname}},
                      "auth": auth_token,
                      "id": 1
                      }).json()["result"][0]['groupid']



def template_create(custom_template,group):
    try:
        return post({
                    "jsonrpc": "2.0",
                    "method": "template.create",
                    "params": {
                        "host": custom_template,
                        "groups": {
                            "groupid": group
                        }
                     },
                    "auth": auth_token,
                    "id": 1
                    }).json()["result"]['templateid'][0]
    except:
        return post({
                        "jsonrpc": "2.0",
                        "method": "template.get",
                        "params": {
                            "output": "extend",
                            "filter": {
                                "host": custom_template
                            }
                        },
                        "auth": auth_token,
                        "id": 1
                    }).json()["result"][0]['templateid']


def register_host(hostname, ip, group, template):
    try:
        post({
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
                }).json()["result"]['hostids'][0]


    except:

         r=post({
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
                }).json()["result"][0]['hostid']
         print('Host already exist:'+'hostID='+str(r))


groupid=group_create("CloudHosts")
templateid=template_create("Server-Tomcat",groupid)
hostid=register_host(hostname,hostip,groupid,templateid)



