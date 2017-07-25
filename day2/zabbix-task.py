from zabbix_api import ZabbixAPI
zapi = ZabbixAPI(server="https://server/")
zapi.login("login", "password")
zapi.trigger.get({"expandExpression": "extend", "triggerids": range(0, 100)})