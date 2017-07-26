import requests, json, sys
from requests.auth import HTTPBasicAuth

zabbix_server = sys.argv[1]#"192.168.56.10/zabbix"
zabbix_api_admin_name = sys.argv[2]#"Admin"
zabbix_api_admin_password = sys.argv[3]#"zabbix"
group_name = sys.argv[4]#"CloudHosts"
template_name = sys.argv[5]#"Custom template"
host_name = sys.argv[6]#"Hostname"
host_ip = sys.argv[7]#"192.168.56.11"

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


def register_host(hostname, ip, group, template):
    return post({
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
    })

def check_group(name):
    reply = post({
        "jsonrpc": "2.0",
        "method": "hostgroup.get",
        "params": {
            "output": "extend",
            "filter": {
                "name": name
            }
        },
        "auth": auth_token,
        "id": 1
    }).json()["result"]
    if reply.__len__() > 0:
        return int(reply[0]['groupid'])
    else: return False

def check_template(name):
    reply = post({
        "jsonrpc": "2.0",
        "method": "template.get",
        "params": {
            "output": "extend",
            "filter": {
                "name": name
            }
        },
        "auth": auth_token,
        "id": 1
    }).json()["result"]
    if reply.__len__() > 0:
        return int(reply[0]['templateid'])
    else: return False

def create_group(name):
    return int(post({
        "jsonrpc": "2.0",
        "method": "hostgroup.create",
        "params": {
            "name": name
        },
        "auth": auth_token,
        "id": 1
    }).json()["result"]['groupids'][0])

def create_template(name, group):
    return int(post({
        "jsonrpc": "2.0",
        "method": "template.create",
        "params": {
            "host": name,
            "groups": {
                "groupid": group
            }
        },
        "auth": auth_token,
        "id": 1
    }).json()["result"]['templateids'][0])

group_id = check_group(group_name)
if group_id == False:
    group_id = create_group(group_name)
    print "Group", group_name,"created"


template_id = check_template(template_name)
if template_id == False:
    template_id = create_template(template_name, group_id)
    print "Template", template_name, "created"

result = register_host(host_name, host_ip, group_id, template_id).json()

if 'error' in result:
    print "Error!!!:", result['error']['data']
else:
    print "Host", host_name, "with ip", host_ip, "and template", template_name, "created and added to group", group_name