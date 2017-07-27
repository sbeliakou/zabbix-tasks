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
id_host = 1
id_group = 1
id_template = 1


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
    """
    Method for creating Hosts, HosGroups or Templates by given name on
    choosen ip-addr (default: Zabbix server's) and autoassigning it
    to an existing ones (default: not assign)
    :param name: str for name
    :param method: hostgroup.create|template.create|host.create as str value
    :param host: link host (only one for now) to your object
    :param group: link group (only one for now) to your object
    :param unitip: choose ip-addr  to link
    :return:
    """
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
def isneedtocreate (name, type):
    if type == "template":
        if exist_check(name, '%s.get' % type).json()['result'] != []:
            id_template = getId(name, type)
        else:
            templ_create = True
    elif type == "group":
        if exist_check(name, 'host%s.get' % type).json()['result'] != []:
            id_group = getId(name, type)
        else:
            group_create = True
    elif type == "host":
        if exist_check(name, '%s.get' % type).json()['result'] != []:
            id_host = getId(name, type)
        else:
            host_create = True
    else:
        print("Name|Type error")


###Creation Host+Group+Template###

def createhost(name, type):
    if type == "group":
        if group_create:
            create_something(name, "host%s.create" % type)
            id_group = getId('CloudHosts', 'group')
            with open("host-create.log", mode='a') as logfile:
                logfile.write(DT + "CloudHosts host group successfully created. \n")
        else:
            id_group = getId('CloudHosts', 'group')
            with open("host-create.log", mode='a') as logfile:
                logfile.write(DT + "CloudHosts host group already exists. Nothing to do \n")
    elif type == "host":
        if host_create:
            create_something(name, '%s.create' % type, unitip='111.111.11.12')
            id_host = getId(name, 'host')
            with open("host-create.log", mode='a') as logfile:
                logfile.write(DT + "%s host successfully created. \n" % name)
        else:
            with open("host-create.log", mode='a') as logfile:
                logfile.write(DT + "%s host already exists. Nothing to do \n" % name)
    elif type == "template":
        if templ_create:
            create_something(name, '%s.create' % type)
            id_template = getId("CustomTemplate", "template")
            with open("host-create.log", mode='a') as logfile:
                logfile.write(DT + "CustomTemplate template successfully created. \n")
        else:
            id_template = getId("CustomTemplate", "template")
            with open("host-create.log", mode='a') as logfile:
                logfile.write(DT + "CustomTemplate template already exists. Nothing to do \n")
    else:
        print("Name|Type error")

isneedtocreate('agent3', 'host')
createhost('agent3', 'host')

if len(sys.argv) > 1:
    totype = sys.argv[2]
    if len(sys.argv) < 2:
        toname = currenthost
    else:
        toname = sys.argv[3]
    todo = sys.argv[1]
    if todo == "create":
        if totype == "all":
            isneedtocreate(toname, 'host')
            isneedtocreate('CloudGroup', 'group')
            isneedtocreate('CustomTemplate', 'template')
            createhost(toname, 'host')
            createhost('CloudGroup', 'group')
            createhost('CustomTemplate', 'template')
        else:
            isneedtocreate(toname, type)
            createhost(toname, type)
    elif todo == "delete":
        if totype == "group":
            deletesomething('host%s.delete' % totype, toname)
        else:
            deletesomething('%s.delete' % totype, toname)
    elif todo == "disable":
        disablehost(getId(toname, totype))
    elif todo == "enable":
        enablehost(getId(toname, totype))
    else:
        print("""Usage: create|delete|disable|enable <type> <name>
        type: host|group|template
        name: any string value""")
else:
    print("""Usage: create|delete|disable|enable <type> <name>
            type: host|group|template
            name: any string value, defaul: current hostname""")


#hosttogroup(customid_host, id_group)
#deletesomething("host.delete", id_host)
#deletesomething("template.delete", id_template)
#deletesomething("hostgroup.delete", id_group)

