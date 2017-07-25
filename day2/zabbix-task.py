import requests, json

from requests.auth import HTTPBasicAuth

zabbix_ip = '111.111.11.11'
#zabbix_server = "zabbix-server"
zabbix_api_admin_name = "Admin"
zabbix_api_admin_password = "zabbix"

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

def register_host(hostname, ip):
    a = post({
        "jsonrpc": "2.0",
        "method": "host.create",
        "params": {
            "host": hostname,
            "interfaces": [{
                "type": 1,
                "main": 1,
                "useip": 1,
                "ip": ip,
                "dns": "",
                "port": "10050"
            }],
            "groups": [
                {"groupid": "1"}
            ]
        },
        "auth": auth_token,
        "id": 1
    })
    return a

def create_hostgroup (name, ip, host=None):
    a = post(
        {
            "jsonrpc": "2.0",
            "method": "hostgroup.create",
            "params": {
                "interfaces": [{
                    "type": 1,
                    "main": 1,
                    "useip": 1,
                    "ip": ip,
                    "dns": "",
                    "port": "10050"
                }],
                "name": name,
                "hosts": [
                    {
                        "hostid": host
                    }]
            },
            "auth": auth_token,
            "id": 1
        }
    )
    return a

def create_template (name, ip, host, group):
    a = post(
        {
            "jsonrpc": "2.0",
            "method": "template.create",
            "params": {
                "interfaces": [{
                    "type": 1,
                    "main": 1,
                    "useip": 1,
                    "ip": ip,
                    "dns": "",
                    "port": "10050"
                }],
                "host": name,
                "groups": {
                    "groupid": group
                },
                "hosts": [
                    {
                        "hostid": host
                    }]
            },
            "auth": auth_token,
            "id": 1
        }
    )
    return a
def exist_check(ip, name, type):
    if type == "hostgroup.get" or "template.get" or "host.get":
        a = post(
            {
                "jsonrpc": "2.0",
                "method": type,
                "params": {
                    "interfaces": [{
                        "type": 1,
                        "main": 1,
                        "useip": 1,
                        "ip": ip,
                        "dns": "",
                        "port": "10050"
                    }],
                    "output": "extend",
                    "filter": {
                        "name": name
                    }
                },
                "auth": auth_token,
                "id": 1
            }
        )
        return a
    else:
        return "Post method incompatibility"

if exist_check(zabbix_ip, 'Hostname', 'host.get').json()['result'] == []:
    register_host('Hostname', zabbix_ip)
    
customid_host = exist_check(zabbix_ip, 'Hostname', 'host.get').json()['result'][0]['hostid']

if exist_check(zabbix_ip, 'CloudHosts', 'hostgroup.get').json()['result'] == []:
    create_hostgroup('CloudHosts', zabbix_ip, customid_host)
    
customid_group = exist_check(zabbix_ip, 'CloudHosts', 'hostgroup.get').json()['result'][0]['groupid']

if exist_check(zabbix_ip, 'Custom', 'template.get').json()['result'] == []:
    create_template('Custom', zabbix_ip, customid_host, customid_group)

