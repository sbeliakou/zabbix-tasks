set -x
yum -y install http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/zabbix-release-3.2-1.el7.noarch.rpm
yum -y install zabbix-sender
yum -y install zabbix-getter
yum -y install zabbix-agent
sed -i '95aServer=192.168.56.70' /etc/zabbix/zabbix_agentd.conf
sed -i '103aListenPort=10050' /etc/zabbix/zabbix_agentd.conf
sed -i '111aListenIP=0.0.0.0' /etc/zabbix/zabbix_agentd.conf
sed -i '136aServerActive=192.168.56.70' /etc/zabbix/zabbix_agentd.conf
systemctl start zabbix-agent
systemctl enable zabbix-agent
