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
    :param unitip: choose ip-addr  to link (default: Zabbix server ip)
    :return:
    """
    if method == "hostgroup.create" or "template.create" or "host.create":
        if method == "host.create" and group == None:
            print("Error: host without group assigned creation attempt")
            return 42
        if method == "template.create" and group == None:
            print("Error: template without group assigned creation attempt")
            return 42
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
        if method == "hostgroup.create":
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
                "name": name
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
        #if exist_check(gethostname(), method[:-6]+'get').json()['result'] == []:
            #print("Delete Successfull: object %s with <id %d> no longer exists" % (method[:-6], id))
    else:
        return "Post method incompatibility"

def exist_check(name, type):
    if type == "template.get" or "host.get":
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
    elif type == "hostgroup.get":
        return post(
            {
                "jsonrpc": "2.0",
                "method": type,
                "params": {
                    "output": "extend",
                    "filter": {
                        "name": name
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
    :return: int of object Id
    """
    if type is "template":
        result = exist_check(name, "%s.get" % type).json()['result']
        for each in result:
            if each['name'] == name:
                return each['%sid' % type]
    elif type is "group":
        result = exist_check(name, "host%s.get" % type).json()['result']
        for each in result:
            if each['name'] == name:
                return each['%sid' % type]
    elif type is "host":
        result = exist_check(name, "%s.get" % type).json()['result']
        for each in result:
            if each['name'] == name:
                return each['%sid' % type]
    else:
        return 42


###Getting object id's###
def isneedtocreate (name, type):
    out = [0, False]
    if type == "template":
            if exist_check(name, '%s.get' % type).json()['result'] != []:
                out[0] = getId(name, type)
            else:
                out[1] = True
            return out
    elif type == "group":
        temp = exist_check(name, 'host%s.get' % type).json()['result']
        for each in temp:
            if each['name'] == name:
                out[0] = getId(name, type)
            else:
                out[1] = True
            return out
    elif type == "host":
        if exist_check(name, '%s.get' % type).json()['result'] != []:
            out[0] = getId(name, type)
        else:
            out[1] = True
        return out
    else:
        print("Name|Type error")


###Creation Host+Group+Template###

def createhost(name, type, assignhost=None, assigntogroup=None):
    """
    Void func for creating an object of <type> with <name>
    :param name: str of name
    :param type: str of group|host|template
    :return: writes into host-create.log in current folder with timestamp
    """
    if type == "group":
        if isneedtocreate(name, type)[1]:
            create_something(name, "host%s.create" % type, assignhost, assigntogroup)
            readyid = getId(name, type)
            with open("host-create.log", mode='a') as logfile:
                logfile.write(DT + "%s host group successfully created. \n" % name)
        else:
            readyid = getId(name, type)
            with open("host-create.log", mode='a') as logfile:
                logfile.write(DT + "CloudHosts host group already exists. Nothing to do \n")
        return readyid
    elif type == "host":
        if isneedtocreate(name, type)[1]:
            create_something(name, '%s.create' % type, group=assigntogroup, unitip='111.111.11.12')
            readyid = getId(name, type)
            with open("host-create.log", mode='a') as logfile:
                logfile.write(DT + "%s host successfully created. \n" % name)
        else:
            readyid = getId(name, type)
            with open("host-create.log", mode='a') as logfile:
                logfile.write(DT + "%s host already exists. Nothing to do \n" % name)
        return readyid
    elif type == "template":
        if isneedtocreate(name, type)[1]:
            create_something(name, '%s.create' % type, group=assigntogroup)
            readyid = getId(name, type)
            with open("host-create.log", mode='a') as logfile:
                logfile.write(DT + "%s template successfully created. \n" % name)
        else:
            readyid = getId(name, type)
            with open("host-create.log", mode='a') as logfile:
                logfile.write(DT + "%s template already exists. Nothing to do \n" % name)
        return readyid
    else:
        print("Name|Type error")

def mainstart (args):
    assignsId = {'ToHost': None, 'ToGroup': None}
    if len(args) > 2:
        totype = args[2]
        if len(args) < 4:
            toname = currenthost
        else:
            toname = args[3]
        todo = args[1]
        if todo == "create":
            if totype == "all":
                createhost('CloudGroup', 'group')
                assignsId['ToGroup'] = getId('CloudGroup', 'group')
                createhost('CustomTemplate', 'template', assigntogroup=assignsId['ToGroup'])
                createhost(toname, 'host', assigntogroup=assignsId['ToGroup'])
            else:
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

#mainstart(sys.argv)
test = ['zabbix-task.py', 'create', 'all']
mainstart(test)

"""
createhost('CloudGroup', 'group')
name = 'SomeTemplate'
type = 'template'
assignsId = {'ToHost': None, 'ToGroup': None}
assignsId['ToGroup'] = getId('CloudGroup', 'group')
print(isneedtocreate(name, type))
print(exist_check(name, '%s.get' % type).json())
print(createhost(name, type, assigntogroup=assignsId['ToGroup']))
print(exist_check(name, "%s.get" % type).json()['result'])
print(assignsId)
print(getId(name, type))
"""
#deletesomething('hostgroup.delete', getId('CloudGroup', 'group'))


