#Installing zabbix-agent
yum install http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/zabbix-release-3.2-1.el7.noarch.rpm -y
yum install zabbix-agent -y
systemctl enable zabbix-agent
systemctl start zabbix-agent

#Installing zabbix-sender-get
yum install zabbix-sender -y
yum install zabbix-get -y

#Installing tomcat
yum install tomcat -y
yum install tomcat tomcat-webapps -y

#loading python modules for script:
yum install python2-pip.noarch -y
pip install requests

#Creating unit file to start python script (register, enable, disable host on zabbix)
if [[ -f /vagrant/zabbixhostadd.py ]]; then 
 chmod +x /vagrant/zabbixhostadd.py

if [[ ! -f /etc/systemd/system/mypy.service ]]; then
 touch /etc/systemd/system/mypy.service
 chmod 664 /etc/systemd/system/mypy.service

cat >/etc/systemd/system/mypy.service << 'EOL'
[Unit]
Description=zabbixhost
After=network.target

[Service]
ExecStart=/usr/bin/python /vagrant/zabbixhostadd.py up
ExecStop=/usr/bin/python /vagrant/zabbixhostadd.py down
Type=forking
PIDFile=path_to_pidfile
RemainAfterExit=yes

[Install]
WantedBy=default.target
EOL

systemctl daemon-reload
systemctl enable mypy.service
systemctl start mypy.service
fi
fi
