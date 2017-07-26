#!/usr/bin/python
import script, sys


def change_status(host_id, status):
    return script.post({
        "jsonrpc": "2.0",
        "method": "host.update",
        "params": {
            "hostid": host_id,
            "status": status
        },
        "auth": script.auth_token,
        "id": 1
    }).json()["result"]

answer = script.check_existence(script.zabbix_api_hostname, "host.get")

if answer is not None:
    zabbix_api_hostname_id = answer["hostid"]
    zabbix_api_host_status = answer["status"]
    if len(sys.argv) > 1:
        if sys.argv[1] == '1':
            change_status(zabbix_api_hostname_id, '1')
            if script.check_existence(script.zabbix_api_hostname, "host.get")["status"] == '1':
                print('Host {} was successfully disabled!'.format(script.zabbix_api_hostname))
        else:
            change_status(zabbix_api_hostname_id, '0')
            if script.check_existence(script.zabbix_api_hostname, "host.get")["status"] == '0':
                print('Host {} was successfully enabled!'.format(script.zabbix_api_hostname))

