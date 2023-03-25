#!/bin/sh
# Author : Jean Macena
# Version: 0.0.1-RELEASE - 10/02/2022
# Copyright (c) Jean Macena

sudo yum -y install wget curl vim zip unzip
sudo rpm -Uvh https://repo.zabbix.com/zabbix/5.0/rhel/7/x86_64/zabbix-agent-5.0.20-1.el7.x86_64.rpm
sudo yum clean all

systemctl stop zabbix-agent

#vim /etc/zabbix/zabbix_agentd.conf

AWS_INSTANCE_ID=`curl -s http://169.254.169.254/latest/meta-data/hostname`

sed -i 's|Server=127.0.0.1|Server=3.86.0.65|g' /etc/zabbix/zabbix_agentd.conf
sed -i 's|ServerActive=127.0.0.1|#ServerActive=127.0.0.1|g' /etc/zabbix/zabbix_agentd.conf
sed -i 's|Hostname=Zabbix server|Hostname='"$AWS_INSTANCE_ID"'|g' /etc/zabbix/zabbix_agentd.conf

sudo systemctl daemon-reload
sudo systemctl enable zabbix-agent
sudo systemctl status zabbix-agent
sudo systemctl start zabbix-agent
sleep 2
sudo systemctl status zabbix-agent
