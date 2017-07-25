import sys, requests, json
from requests.auth import HTTPBasicAuth


def post(request):
    headers = {'content-type': 'application/json'}
    return requests.post(
        "http://" + zabbix_server + "/api_jsonrpc.php",
        data=json.dumps(request),
        headers=headers,
        auth=HTTPBasicAuth(zabbix_api_admin_name, zabbix_api_admin_password)
    )


def hostgroup_create(groupname):
    group_get = post({
        "jsonrpc": "2.0",
        "method": "hostgroup.get",
        "params": {
            "filter": {
                "name": groupname
            }
        },
        "auth": auth_token,
        "id": 1
        }).json()["result"]
    if group_get == []:
        group_get = post({
            "jsonrpc": "2.0",
            "method": "hostgroup.create",
            "params": {
                "name": groupname
            },
            "auth": auth_token,
            "id": 1
        }).json()["result"]
        return group_get['groupids'][0]
    else:
        return group_get[0]['groupid']


def template_create(tempname, groupid):
    templ_get = post({
        "jsonrpc": "2.0",
        "method": "template.get",
        "params": {
            "filter": {
                "host": tempname
            }
        },
        "auth": auth_token,
        "id": 1
        }).json()["result"]
    if templ_get == []:
        templ_get = post({
            "jsonrpc": "2.0",
            "method": "template.create",
            "params": {
                "host": tempname,
                "groups": {
                    "groupid": groupid
                }
            },
            "auth": auth_token,
            "id": 1
        }).json()["result"]
        return templ_get['templateids'][0]
    else:
        return templ_get[0]['templateid']


def host_create(hostname, ip, groupid, templid):
    host_get = post({
        "jsonrpc": "2.0",
        "method": "host.get",
        "params": {
            "filter": {
                "host": hostname
            }
        },
        "auth": auth_token,
        "id": 1
        }).json()["result"]
    if host_get == []:
        host_get = post({
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
                    {"groupid": groupid}
                ],
                "templates": [
                    {"templateid": templid}
                ]
            },
            "auth": auth_token,
            "id": 1
            }).json()["result"]
        return host_get['hostids'][0]
    else:
        return host_get[0]['hostid']

zabbix_server = "192.168.56.110"
zabbix_api_admin_name = "Admin"
zabbix_api_admin_password = "zabbix"
hastname = str(sys.argv[1])
ip = str(sys.argv[2])
groupname = 'CloudHosts'
template = 'Template Custom'

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

groupid = hostgroup_create(groupname)
print('Host Group CloudHosts with ID ' + str(groupid) + ' has been created')
templid = template_create(template, groupid)
print('Template Custom with ID ' + str(templid) + ' has been created')
host = host_create(hastname, ip, groupid, templid)
print('Host ' + hastname + ' has been created')
