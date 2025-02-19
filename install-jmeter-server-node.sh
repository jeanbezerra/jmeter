#!/bin/sh
# Author : Jean Macena
# Version: 1.0.0-RELEASE - 23/04/2022
# Copyright (c) Jean Macena
# Yaman - JMeter Server
# sudo su
# cd /opt
# wget https://yaman-apm-static-files.s3.sa-east-1.amazonaws.com/scripts/install-jmeter-server-node.sh
# chmod +x install-jmeter-server-node.sh
# ./install-jmeter-server-node.sh

###################### System update

sudo yum -y update
sudo yum -y install vim wget git

###################### Install Java

sudo amazon-linux-extras install -y java-openjdk11
sudo yum -y install java-11-openjdk java-11-openjdk-devel
sudo alternatives --auto java

TZ=America/Sao_Paulo
ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

###################### Folder and Download

sudo mkdir -p /opt/yaman-jmeter/ && cd /opt/yaman-jmeter/

sudo wget https://yaman-apm-static-files.s3.sa-east-1.amazonaws.com/apache-jmeter/apache-jmeter-5.4.1.tgz

cd /opt/yaman-jmeter/
sudo tar -xzf apache-jmeter-5.4.1.tgz
sudo chmod -R 775 *

###################### JAVA_HOME

cd /etc/profile.d/

sudo cat <<EOF > JAVA_HOME.sh
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk
export PATH=PATH:JAVA_HOME/bin
EOF

sed -i 's|PATH:JAVA_HOME|$PATH:$JAVA_HOME|g' /etc/profile.d/JAVA_HOME.sh

source /etc/profile.d/JAVA_HOME.sh

###################### JMETER_HOME

cd /etc/profile.d/

sudo cat <<EOF > JMETER_HOME.sh 
export JMETER_HOME=/opt/yaman-jmeter/apache-jmeter-5.4.1
export PATH=PATH:JMETER_HOME/bin
EOF

sed -i 's|PATH:JMETER_HOME|$PATH:$JMETER_HOME|g' /etc/profile.d/JMETER_HOME.sh

source /etc/profile.d/JMETER_HOME.sh

###################### Config certificate

cd $JMETER_HOME/bin/
/usr/lib/jvm/java-11-openjdk/bin/keytool -genkeypair \
-dname "CN=yaman.com.br, OU=APM Squad, O=Yaman Tecnologia LTDA, L=SaoPaulo, S=SaoPaulo, C=BR" \
-alias rmi \
-storepass UYdOAgYYyuvyQXf1zmWVurHxlzYH7Og5 \
-storetype PKCS12 \
-keyalg RSA \
-keysize 2048 \
-validity 365 \
-keystore $JMETER_HOME/bin/rmi_keystore.jks

cd $JMETER_HOME/bin/ && ls -lha *rmi*
chmod -R 755 rmi_keystore.jks

###################### Permissions

cd $JMETER_HOME/bin/
sudo chmod -R 775 *
#sudo chown -R root:root *

###################### Backup file jmeter.properties

cp -r -a $JMETER_HOME/bin/jmeter.properties $JMETER_HOME/bin/jmeter-properties.original
cp -r -a $JMETER_HOME/bin/jmeter-server.properties $JMETER_HOME/bin/jmeter-server.original

###################### Config jmeter.properties

cd $JMETER_HOME/bin/

sed -i 's|#jmeter.save.saveservice.output_format=csv|jmeter.save.saveservice.output_format=csv|g' /opt/yaman-jmeter/apache-jmeter-5.4.1/bin/jmeter.properties
sed -i 's|#jmeter.save.saveservice.time=true|jmeter.save.saveservice.time=true|g' /opt/yaman-jmeter/apache-jmeter-5.4.1/bin/jmeter.properties
sed -i 's|#jmeter.save.saveservice.response_message=true|jmeter.save.saveservice.response_message=true|g' /opt/yaman-jmeter/apache-jmeter-5.4.1/bin/jmeter.properties
sed -i 's|#jmeter.save.saveservice.successful=true|jmeter.save.saveservice.successful=true|g' /opt/yaman-jmeter/apache-jmeter-5.4.1/bin/jmeter.properties
sed -i 's|#jmeter.save.saveservice.sent_bytes=true|jmeter.save.saveservice.sent_bytes=true|g' /opt/yaman-jmeter/apache-jmeter-5.4.1/bin/jmeter.properties
sed -i 's|#jmeter.save.saveservice.filename=false|jmeter.save.saveservice.filename=false|g' /opt/yaman-jmeter/apache-jmeter-5.4.1/bin/jmeter.properties
sed -i 's|#jmeter.save.saveservice.encoding=false|jmeter.save.saveservice.encoding=true|g' /opt/yaman-jmeter/apache-jmeter-5.4.1/bin/jmeter.properties
sed -i 's|#jmeter.save.saveservice.idle_time=true|jmeter.save.saveservice.idle_time=true|g' /opt/yaman-jmeter/apache-jmeter-5.4.1/bin/jmeter.properties
sed -i 's|#jmeter.save.saveservice.label=true|jmeter.save.saveservice.label=true|g' /opt/yaman-jmeter/apache-jmeter-5.4.1/bin/jmeter.properties
sed -i 's|#jmeter.save.saveservice.thread_name=true|jmeter.save.saveservice.thread_name=true|g' /opt/yaman-jmeter/apache-jmeter-5.4.1/bin/jmeter.properties
sed -i 's|#jmeter.save.saveservice.assertions=true|jmeter.save.saveservice.assertions=true|g' /opt/yaman-jmeter/apache-jmeter-5.4.1/bin/jmeter.properties
sed -i 's|#jmeter.save.saveservice.thread_counts=true|jmeter.save.saveservice.thread_counts=true|g' /opt/yaman-jmeter/apache-jmeter-5.4.1/bin/jmeter.properties
sed -i 's|#jmeter.save.saveservice.latency=true|jmeter.save.saveservice.latency=true|g' /opt/yaman-jmeter/apache-jmeter-5.4.1/bin/jmeter.properties
sed -i 's|#jmeter.save.saveservice.hostname=false|jmeter.save.saveservice.hostname=true|g' /opt/yaman-jmeter/apache-jmeter-5.4.1/bin/jmeter.properties
sed -i 's|#jmeter.save.saveservice.response_code=true|jmeter.save.saveservice.response_code=true|g' /opt/yaman-jmeter/apache-jmeter-5.4.1/bin/jmeter.properties
sed -i 's|#jmeter.save.saveservice.data_type=true|jmeter.save.saveservice.data_type=true|g' /opt/yaman-jmeter/apache-jmeter-5.4.1/bin/jmeter.properties
sed -i 's|#jmeter.save.saveservice.bytes=true|jmeter.save.saveservice.bytes=true|g' /opt/yaman-jmeter/apache-jmeter-5.4.1/bin/jmeter.properties
sed -i 's|#jmeter.save.saveservice.subresults=true|jmeter.save.saveservice.subresults=false|g' /opt/yaman-jmeter/apache-jmeter-5.4.1/bin/jmeter.properties
sed -i 's|#jmeter.save.saveservice.url=true|jmeter.save.saveservice.url=true|g' /opt/yaman-jmeter/apache-jmeter-5.4.1/bin/jmeter.properties
sed -i 's|#jmeter.save.saveservice.connect_time=true|jmeter.save.saveservice.connect_time=true|g' /opt/yaman-jmeter/apache-jmeter-5.4.1/bin/jmeter.properties
sed -i 's|#jmeter.save.saveservice.sample_count=false|jmeter.save.saveservice.sample_count=true|g' /opt/yaman-jmeter/apache-jmeter-5.4.1/bin/jmeter.properties
sed -i 's|#jmeter.save.saveservice.assertion_results_failure_message=true|jmeter.save.saveservice.assertion_results_failure_message=true|g' /opt/yaman-jmeter/apache-jmeter-5.4.1/bin/jmeter.properties
sed -i 's|#jmeter.save.saveservice.print_field_names=true|jmeter.save.saveservice.print_field_names=true|g' /opt/yaman-jmeter/apache-jmeter-5.4.1/bin/jmeter.properties

#sed -i 's|#server.rmi.ssl.keystore.type=JKS|server.rmi.ssl.keystore.type=PKCS12|g' /opt/yaman-jmeter/apache-jmeter-5.4.1/bin/jmeter.properties
#sed -i 's|#server.rmi.ssl.keystore.file=rmi_keystore.jks|server.rmi.ssl.keystore.file=rmi_keystore.jks|g' /opt/yaman-jmeter/apache-jmeter-5.4.1/bin/jmeter.properties
#sed -i 's|#server.rmi.ssl.keystore.alias=rmi|server.rmi.ssl.keystore.alias=rmi|g' /opt/yaman-jmeter/apache-jmeter-5.4.1/bin/jmeter.properties
#sed -i 's|#server.rmi.ssl.keystore.password=changeit|server.rmi.ssl.keystore.password=UYdOAgYYyuvyQXf1zmWVurHxlzYH7Og5|g' /opt/yaman-jmeter/apache-jmeter-5.4.1/bin/jmeter.properties

sed -i 's|#server.rmi.ssl.disable=false|server.rmi.ssl.disable=true|g' /opt/yaman-jmeter/apache-jmeter-5.4.1/bin/jmeter.properties
sed -i 's|#server_port=1099|server_port=2000|g' /opt/yaman-jmeter/apache-jmeter-5.4.1/bin/jmeter.properties
sed -i 's|#server.rmi.port=1234|server.rmi.port=2000|g' /opt/yaman-jmeter/apache-jmeter-5.4.1/bin/jmeter.properties
sed -i 's|#server.rmi.localport=4000|server.rmi.localport=5000|g' /opt/yaman-jmeter/apache-jmeter-5.4.1/bin/jmeter.properties

###################### Config jmeter-server

cd $JMETER_HOME/bin/

### AWS ONLY
#cd $JMETER_HOME/bin/
#LOCAL_IP=$(/sbin/ip -o -4 addr list eth0 | awk '{print $4}' | cut -d/ -f1)
#sed -i 's|#RMI_HOST_DEF=-Djava.rmi.server.hostname=xxx.xxx.xxx.xxx|RMI_HOST_DEF=-Djava.rmi.server.hostname='"$LOCAL_IP"'|g' /opt/yaman-jmeter/apache-jmeter-5.4.1/bin/jmeter-server
#sed -i 's|-Dserver_port=${SERVER_PORT:-1099}|-Dserver_port=2000|g' /opt/yaman-jmeter/apache-jmeter-5.4.1/bin/jmeter-server
#sed -i 's|jmeter-server.log|/tmp/jmeter-server.log|g' /opt/yaman-jmeter/apache-jmeter-5.4.1/bin/jmeter-server

### CENTOS
cd $JMETER_HOME/bin/
LOCAL_IP=$(/sbin/ip -o -4 addr list enp0s3 | awk '{print $4}' | cut -d/ -f1)
sed -i 's|#RMI_HOST_DEF=-Djava.rmi.server.hostname=xxx.xxx.xxx.xxx|RMI_HOST_DEF=-Djava.rmi.server.hostname='"$LOCAL_IP"'|g' /opt/yaman-jmeter/apache-jmeter-5.4.1/bin/jmeter-server
sed -i 's|-Dserver_port=${SERVER_PORT:-1099}|-Dserver_port=2000|g' /opt/yaman-jmeter/apache-jmeter-5.4.1/bin/jmeter-server
sed -i 's|jmeter-server.log|/tmp/jmeter-server.log|g' /opt/yaman-jmeter/apache-jmeter-5.4.1/bin/jmeter-server

###################### JMeter Server - Memory Improvment

#cd $JMETER_HOME/bin/ && vim jmeter
#JVM_ARGS="-Xms10G -Xmx25G -XX:NewSize=1024m -XX:MaxNewSize=1024m -XX:+DisableExplicitGC"
#sed -i '54i JVM_ARGS="-Xms10G -Xmx25G -XX:NewSize=1024m -XX:MaxNewSize=1024m -XX:+DisableExplicitGC"' $JMETER_HOME/bin/jmeter
sed -i '54i JVM_ARGS="-Xms10G -Xmx25G -XX:+DisableExplicitGC"' $JMETER_HOME/bin/jmeter
sed -i '32i JVM_ARGS="-Xms10G -Xmx25G -XX:+DisableExplicitGC"' $JMETER_HOME/bin/jmeter.sh

###################### JMeter Server - Service

sudo systemctl stop jmeter-server.service
sudo systemctl disable jmeter-server.service
sudo systemctl status jmeter-server.service
sudo rm -rf /etc/systemd/system/jmeter-server.service
sudo systemctl daemon-reload

sudo cat <<EOF > /etc/systemd/system/jmeter-server.service
[Unit]
Description=Jmeter-Server - Run Jmeter-Server
After=network.target
StartLimitIntervalSec=0
[Service]
Type=idle
User=root
ExecStart=/opt/yaman-jmeter/apache-jmeter-5.4.1/bin/jmeter-server

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable jmeter-server
sudo systemctl start jmeter-server
sudo systemctl status jmeter-server

###################### Disable Swap and SELinux

swapoff -a
sudo sestatus
sudo setenforce 0

###################### Check Ports and Restart Server

sleep 5s
sudo netstat -anot | grep 5000
sleep 1s
sudo netstat -anot | grep 2000
sleep 1s

###################### Restart
sudo init 6
