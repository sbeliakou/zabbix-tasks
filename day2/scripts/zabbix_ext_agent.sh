sed -i 's|# DebagLevel| DebagLevel|' /etc/zabbix/zabbix_agentd.conf
sed -i 's|Server=127.0.0.1|Server=192.168.100.101|' /etc/zabbix/zabbix_agentd.conf
systemctl restart zabbix-agent
yum install zabbix-java-gateway -y
systemctl start zabbix-java-gateway
systemctl enable zabbix-java-gateway
