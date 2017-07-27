import requests, json, sys
from datetime import datetime
from socket import gethostname

from requests.auth import HTTPBasicAuth

zabbix_ip = '111.111.11.11'
zabbix_api_admin_name = "Admin"
zabbix_api_admin_password = "zabbix"

currenthost = gethostname()

templ_create = False
group_create = False
host_create = False
DT = str(datetime.now().date()) + " " + str(datetime.now().strftime('%H:%M:%S')) + " : "


def post(request):
    headers = {'content-type': 'application/json'}
    return requests.post(
        "http://" + zabbix_ip + "/api_jsonrpc.php",
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

def ifAvailable(name):
     return exist_check(name, 'host.get').json()['result'][0]['status']

def create_something (name, method, host=None, group=None, unitip=zabbix_ip):
    if method == "hostgroup.create" or "template.create" or "host.create":
        request = {
            "jsonrpc": "2.0",
            "method": method,
            "params": {
                "interfaces": [{
                    "type": 1,
                    "main": 1,
                    "useip": 1,
                    "ip": unitip,
                    "dns": "",
                    "port": "10050"
                }],
                "host": name
            },
            "auth": auth_token,
            "id": 1
        }
        if host != None:
            hostinclude = {
                "hosts": [
                    {
                        "hostid": host
                    }]
            }
            request['params'].update(hostinclude)
        if group != None:
            groupinclude = {
                "groups": {
                    "groupid": group
                }
            }
            request['params'].update(groupinclude)
        post(request)
    else:
        return 42

def hosttogroup (host, group):
    post(
        {
            "jsonrpc": "2.0",
            "method": "host.update",
            "params": {
                "hostid": host,
                "groups": {
                    "groupid": group
                },
                "status": 0
            },
            "auth": auth_token,
            "id": 1
        }
    )

def disablehost(host):
    post(
        {
            "jsonrpc": "2.0",
            "method": "host.update",
            "params": {
                "hostid": host,
                "status": 1
            },
            "auth": auth_token,
            "id": 1
        }
    )
def enablehost(host):
    post(
        {
            "jsonrpc": "2.0",
            "method": "host.update",
            "params": {
                "hostid": host,
                "status": 0
            },
            "auth": auth_token,
            "id": 1
        }
    )

def deletesomething(method, id):
    if method == "hostgroup.delete" or "template.delete" or "host.delete":
        post(
            {
                "jsonrpc": "2.0",
                "method": method,
                "params": [
                    id
                ],
                "auth": auth_token,
                "id": 1
            }
        )
    else:
        return "Post method incompatibility"

def exist_check(name, type):
    if type == "hostgroup.get" or "template.get" or "host.get":
        return post(
            {
                "jsonrpc": "2.0",
                "method": type,
                "params": {
                    "output": "extend",
                    "filter": {
                        "host": name
                    }
                },
                "auth": auth_token,
                "id": 1
            }
        )
    else:
        return "Post method incompatibility"

def getId(name, type):
    """
    Short version for quick id-access
    :param name: any
    :param type: may be of "template | group | host"
    :return:
    """
    if type is "template":
        return exist_check(name, type + ".get").json()['result'][0][type + 'id']
    elif type is "group":
        return exist_check(name, "host" + type + ".get").json()['result'][0][type + 'id']
    elif type is "host":
        return exist_check(name, type + ".get").json()['result'][0][type + 'id']
    else:
        return 42


###Getting object id's###

if exist_check('CustomTemplate', 'template.get').json()['result'] != []:
    id_template = getId("CustomTemplate", "template")
else:
    templ_create = True
if exist_check('CloudHosts', 'hostgroup.get').json()['result'] != []:
    id_group = getId('CloudHosts', 'group')
else:
    group_create = True
if exist_check(currenthost, 'host.get').json()['result'] != []:
    id_host = getId(currenthost, 'host')
else:
    host_create = True


###Creation Host+Group+Template###

if group_create:
    create_something("CloudHosts", "hostgroup.create")
    id_group = getId('CloudHosts', 'group')
    with open("host-create.log", mode='a') as logfile:
        logfile.write(DT + "CloudHosts host group successfully created. \n")
else:
    id_group = getId('CloudHosts', 'group')
    with open("host-create.log", mode='a') as logfile:
        logfile.write(DT + "CloudHosts host group already exists. Nothing to do \n")

if host_create:
    create_something(currenthost, 'host.create', group=id_group, unitip='111.111.11.12')
    id_host = getId(currenthost, 'host')
    with open("host-create.log", mode='a') as logfile:
        logfile.write(DT + "%s host successfully created. \n" % currenthost)
else:
    with open("host-create.log", mode='a') as logfile:
        logfile.write(DT + "%s host already exists. Nothing to do \n" % currenthost)


if templ_create:
    create_something('CustomTemplate', 'template.create', id_host, id_group)
    id_template = getId("CustomTemplate", "template")
    with open("host-create.log", mode='a') as logfile:
        logfile.write(DT + "CustomTemplate template successfully created. \n")
else:
    id_template = getId("CustomTemplate", "template")
    with open("host-create.log", mode='a') as logfile:
        logfile.write(DT + "CustomTemplate template already exists. Nothing to do \n")

if ifAvailable(currenthost) == 0:
    disablehost(id_host)
enablehost(id_host)

if len(sys.argv) > 0:
    todisable = sys.argv[0]
    disablehost(getId(todisable, 'host'))

#hosttogroup(customid_host, id_group)
#deletesomething("host.delete", id_host)
#deletesomething("template.delete", id_template)
#deletesomething("hostgroup.delete", id_group)

