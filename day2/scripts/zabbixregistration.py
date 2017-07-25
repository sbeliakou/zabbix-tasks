import requests, json, socket
from requests.auth import HTTPBasicAuth

zabbix_server = "192.168.56.10"
zabbix_api_admin_name = "Admin"
zabbix_api_admin_password = "zabbix"
groupname = "CloudHosts"
templatename = "Custom"
hostname = socket.gethostname()
hostip = "192.168.56.11"


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


def get_groupname(groupname):
    return post({
        "jsonrpc": "2.0",
        "method": "hostgroup.get",
        "params": {
            "output": "extend",
            "filter": {
                "name": [
                    groupname
                ]
            }
        },
        "auth": auth_token,
        "id": 1
    })


def create_groupname(groupname):
    return post({
        "jsonrpc": "2.0",
        "method": "hostgroup.create",
        "params": {
            "name": groupname
        },
        "auth": auth_token,
        "id": 1
    })

try:
    groupID = get_groupname(groupname).json()["result"][0]['groupid']
except IndexError:
    groupID = create_groupname(groupname).json()["result"]['groupids'][0]


def get_templatename(templatename):
    return post({
        "jsonrpc": "2.0",
        "method": "template.get",
        "params": {
            "output": "extend",
            "filter": {
                "host": [
                    templatename
                ]
            }
        },
        "auth": auth_token,
        "id": 1
    })


def create_templatename(templatename, groupID):
    return post({
        "jsonrpc": "2.0",
        "method": "template.create",
        "params": {
            "host": templatename,
            "groups": {
                "groupid": groupID
            }
        },
        "auth": auth_token,
        "id": 1
    })
try:
    templateID = get_templatename(templatename).json()["result"][0]['templateid']
except IndexError:
    templateID = create_templatename(templatename, groupID).json()["result"]['templateids'][0]


def get_hostname(hostname):
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


def create_hostname(hostname, hostip, groupID, templateID):
    return post({
        "jsonrpc": "2.0",
        "method": "host.create",
        "params": {
            "host": hostname,
            "templates": [{
                "templateid": templateID
            }],
            "interfaces": [{
                "type": 1,
                "main": 1,
                "useip": 1,
                "ip": hostip,
                "dns": "",
                "port": "10050"
            }],
            "groups": [
                {"groupid": groupID}
            ]
        },
        "auth": auth_token,
        "id": 1
    })
try:
    hostID = get_hostname(hostname).json()["result"][0]['hostid']
except IndexError:
    hostID = create_hostname(hostname, hostip, groupID,templateID).json()["result"]['hostids'][0]
