import sys, os, requests, json, sys
from requests.auth import HTTPBasicAuth

zabbix_server = sys.argv[1]#"192.168.56.105"
zabbix_api_admin_name = "Admin"
zabbix_api_admin_password = "zabbix"
new_host = sys.argv[2]#'zabbix-client222'
new_group = 'CloudHosts'
new_template = 'Custom_template'#'asddsa'#'Template App FTP Service'

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

#########################################
#              groups
#########################################
try:
    group_id = int(post({
    "jsonrpc": "2.0",
    "method": "hostgroup.create",
    "params": {
        "name": new_group
    },
    "auth": auth_token,
    "id": 1
     }).json()['result']['groupids'][0])
except:
    group_id = int(post({
    "jsonrpc": "2.0",
    "method": "hostgroup.get",
    "params": {
        "output": "extend",
        "filter": {
            "name":
                new_group
        }
    },
    "auth": auth_token,
    "id": 1
}).json()['result'][0]['groupid'])


#########################################
#              templates
#########################################
try:
    template_id = int(post({
        "jsonrpc": "2.0",
        "method": "template.get",
        "params": {
            "output": "extend",
            "filter": {
                "host":
                    new_template
            }
        },
        "auth": auth_token,
        "id": 1
    }).json()["result"][0]['templateid'])

except IndexError:
    template_id = int(post({
        "jsonrpc": "2.0",
        "method": "template.create",
        "params": {
            "host": new_template,
            "groups": {
                "groupid": group_id
            }
         },
        "auth": auth_token,
        "id": 1
    }).json()['result']['templateids'][0])



#########################################
#              host
#########################################
try:
    host_id = post({
    "jsonrpc": "2.0",
    "method": "host.create",
    "params": {
        "host": new_host,
        "interfaces": [
            {
                "type": 1,
                "main": 1,
                "useip": 1,
                "ip": "192.168.56.106",
                "dns": "",
                "port": "10050"
            }
        ],
        "groups": [
            {
                "groupid": group_id
            }
        ],
        "templates": [
            {
                "templateid": template_id
            }
        ],
        "inventory_mode": 0,
        "inventory": {
            "macaddress_a": "01234",
            "macaddress_b": "56768"
        }
    },
    "auth": auth_token,
    "id": 1
}).json()['result']['hostids'][0]
except Exception as e:
    print "Host already exist"
