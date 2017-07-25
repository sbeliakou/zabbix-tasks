#!/user/bin/python
import os
import socket
import requests
import json
import sys
from requests.auth import HTTPBasicAuth

sw=sys.argv[1] #up/down cl param for script

hostname = socket.gethostname()
zabbix_server = "192.168.56.10"
zabbix_api_admin_name = "Admin"
zabbix_api_admin_password = "zabbix"
ip = "192.168.56.11"
hosts_group = 'Cloud Hosts'
template = 'Custom'


##################### post func ###############
def post(request):
    headers = {'content-type': 'application/json'}
    return requests.post(
        "http://" + zabbix_server + "/api_jsonrpc.php",
         data=json.dumps(request),
         headers=headers,
         auth=HTTPBasicAuth(zabbix_api_admin_name, zabbix_api_admin_password)
    )

#################### auth check ################
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
#####################################################################
###################### enabling(registering)/disabling host #########
#####################################################################
if sw == 'down':                   #case vm shutdown
    ######### disabling host ##########
    def host_status():
        return post({
        "jsonrpc": "2.0",
        "method": "host.get",
        "params": {
            "output": "extend",
            "filter": {
                "host": [
                    hostname
                ]
            }
        },
        "auth": auth_token,
        "id": 1
        })
    if len(host_status().json()['result']) is not 0:
        if int(host_status().json()['result'][0]['status']) is 0:
            hostid = host_status().json()['result'][0]['hostid']
            print hostid
            print 'host disabling'
            host_up = post({
            "jsonrpc": "2.0",
            "method": "host.update",
            "params": {
                "hostid": hostid,
                "status": 1
            },
            "auth": auth_token,
            "id": 1
            })
            print host_up
elif sw == 'up':                      #case VM up
    ############################################################
    ###################### check if host exist on zabbix #######
    ###################### enable if disabled and ##############
    ###################### create if does not exist ############
    def host_status():
        return post({
        "jsonrpc": "2.0",
        "method": "host.get",
        "params": {
            "output": "extend",
            "filter": {
                "host": [
                    hostname
                ]
            }
        },
        "auth": auth_token,
        "id": 1
        })
    if len(host_status().json()['result']) is not 0:
        if host_status().json()['result'][0]['status'] is not 0:
            hostid = host_status().json()['result'][0]['hostid']
            print hostid
            print 'host enabling'
            host_up = post({
            "jsonrpc": "2.0",
            "method": "host.update",
            "params": {
                "hostid": hostid,
                "status": 0
            },
            "auth": auth_token,
            "id": 1
            })
            print host_up
    else:
        ###########get groupid or create group##########
        def groups():
            return post({
            "jsonrpc": "2.0",
            "method": "hostgroup.get",
            "params": {
                "output": "extend",
                "filter": {
                    "name": [
                        hosts_group
                    ]
                }
            },
            "auth": auth_token,
            "id": 1
            })
        if len(groups().json()['result']) is not 0:
            groupid = groups().json()['result'][0]['groupid']
        else:
            new_group = post({
                "jsonrpc": "2.0",
                "method": "hostgroup.create",
                "params": {
                    "name": hosts_group
                },
                "auth": auth_token,
                "id": 1
            })
            groupid = groups().json()['result'][0]['groupid']
        ################################################
        ########## Creating Template ###################

        def templates():
            return post({
            "jsonrpc": "2.0",
            "method": "template.get",
            "params": {
                "output": "extend",
                "filter": {
                    "host": [
                        template
                    ]
                }
            },
            "auth": auth_token,
            "id": 1
            })
        if len(templates().json()['result']) is not 0:
            templatesid = templates().json()['result'][0]['templateid']
        else:
            new_template = post({
                "jsonrpc": "2.0",
                "method": "template.create",
                "params": {
                    "host": template,
                    "groups": {
                        "groupid": groupid
                    }
                },
                "auth": auth_token,
                "id": 1
            })
            templatesid = templates().json()['result'][0]['templateid']

        ####################################################
        ######### Registering host #########################

        def register_host(hostname, ip):
            post({
                "jsonrpc": "2.0",
                "method": "host.create",
                "params": {
                    "host": hostname,
                    "templates": [{
                        "templateid": templatesid
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
                        {"groupid": groupid},
                    ]
                },
                "auth": auth_token,
                "id": 1
            })

        a = register_host(hostname, ip)

