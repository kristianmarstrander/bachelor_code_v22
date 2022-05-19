!#/bin/bash

apt install zabbix-agent
wget http://kyrre.mysil.local/code/linux_zabbix_agent.conf -O /etc/zabbix/zabbix_agentd.conf
systemctl zabbix-agent enable
systemctl zabbix-agent start
