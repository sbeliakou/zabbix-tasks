#Installing zabbix-agent
yum install http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/zabbix-release-3.2-1.el7.noarch.rpm -y
yum install zabbix-agent -y

sed -i 's|# DebugLevel=3|DebugLevel=3|' /etc/zabbix/zabbix_agentd.conf;
sed -i 's|Server=127.0.0.1|Server=192.168.56.10|' /etc/zabbix/zabbix_agentd.conf;
sed -i 's|# ListenPort=10050|ListenPort=10050|' /etc/zabbix/zabbix_agentd.conf;
sed -i 's|# ListenIP=0.0.0.0|ListenIP=0.0.0.0|' /etc/zabbix/zabbix_agentd.conf;
sed -i 's|# StartAgents=3|StartAgents=3|' /etc/zabbix/zabbix_agentd.conf;
sed -i 's|ServerActive=127.0.0.1|ServerActive=192.168.56.10:10051|' /etc/zabbix/zabbix_agentd.conf;
sed -i 's|Hostname=Zabbix server|Hostname=zabbix2|' /etc/zabbix/zabbix_agentd.conf;
sed -i 's|# HostnameItem=system.hostname|HostnameItem=system.hostname|' /etc/zabbix/zabbix_agentd.conf;

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
if [[ -f /home/vagrant//zabbixhostadd.py ]]; then
 cd /home/vagrant/
 wget https://raw.githubusercontent.com/aion3181/zabbix-tasks/day2/day2/zabbixhostadd.py 
 chmod +x /home/vagrant/zabbixhostadd.py

if [[ ! -f /etc/systemd/system/mypy.service ]]; then
 touch /etc/systemd/system/mypy.service
 chmod 664 /etc/systemd/system/mypy.service

cat >/etc/systemd/system/mypy.service << 'EOL'
[Unit]
Description=zabbixhost
After=network.target

[Service]
ExecStart=/usr/bin/python /home/vagrant/zabbixhostadd.py up
ExecStop=/usr/bin/python /home/vagrant/zabbixhostadd.py down
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
EOL

systemctl daemon-reload
systemctl enable mypy.service
systemctl start mypy.service
fi
fi

[Install]
WantedBy=default.target
EOL

systemctl daemon-reload
systemctl enable mypy.service
systemctl start mypy.service
fi
fi
