#!/bin/sh
# Author : Jean Bezerra
# Version: 1.1.0-RELEASE - 12/02/2025
# Copyright (c) Yaman Tecnologia LTDA
# Yaman - JMeter Server

###################### Remover versões anteriores

systemctl stop jmeter-server
rm -rf /etc/systemd/system/jmeter-server.service
systemctl disable jmeter-server

cd /opt/
rm -rf microsoft-jdk-17
rm -rf microsoft-jdk-17.0.14-linux-x64.tar.gz
rm -rf yaman-jmeter

cd /etc/profile.d/
rm -rf JAVA_HOME.sh
rm -rf JMETER_HOME.sh

###################### System update
sudo yum -y update
sudo yum -y install vim wget git
sudo timedatectl set-timezone America/Sao_Paulo

###################### Install Java (Microsoft JDK 17)
cd /opt/
sudo wget https://publicsre.blob.core.windows.net/jmeter-scale/microsoft-jdk-17.0.14-linux-x64.tar.gz
sudo tar -xzf microsoft-jdk-17.0.14-linux-x64.tar.gz

# Renomeando e definindo JAVA_HOME
sudo mv jdk-17.0.14+7 microsoft-jdk-17

chmod -R 775 /opt/microsoft-jdk-17
chown -R root:root /opt/microsoft-jdk-17

sudo cat <<EOF > /etc/profile.d/JAVA_HOME.sh
export JAVA_HOME=/opt/microsoft-jdk-17
export PATH=\$PATH:\$JAVA_HOME/bin
EOF

source /etc/profile.d/JAVA_HOME.sh

###################### Folder and Download JMeter 5.6.3
sudo mkdir -p /opt/yaman-jmeter/ && cd /opt/yaman-jmeter/

sudo wget https://publicsre.blob.core.windows.net/jmeter-scale/apache-jmeter-5.6.3.tgz
sudo tar -xzf apache-jmeter-5.6.3.tgz
sudo chmod -R 775 *

###################### JMETER_HOME
sudo cat <<EOF > /etc/profile.d/JMETER_HOME.sh
export JMETER_HOME=/opt/yaman-jmeter/apache-jmeter-5.6.3
export PATH=\$PATH:\$JMETER_HOME/bin
EOF

source /etc/profile.d/JMETER_HOME.sh

###################### Config certificate
cd $JMETER_HOME/bin/
$JAVA_HOME/bin/keytool -genkeypair \
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

###################### Backup file jmeter.properties
cp -r -a $JMETER_HOME/bin/jmeter.properties $JMETER_HOME/bin/jmeter-properties.original
cp -r -a $JMETER_HOME/bin/jmeter-server $JMETER_HOME/bin/jmeter-server.original

###################### Config jmeter.properties

cd $JMETER_HOME/bin/

sed -i 's|#jmeter.save.saveservice.output_format=csv|jmeter.save.saveservice.output_format=csv|g' /opt/yaman-jmeter/apache-jmeter-5.6.3/bin/jmeter.properties
sed -i 's|#jmeter.save.saveservice.time=true|jmeter.save.saveservice.time=true|g' /opt/yaman-jmeter/apache-jmeter-5.6.3/bin/jmeter.properties
sed -i 's|#jmeter.save.saveservice.response_message=true|jmeter.save.saveservice.response_message=true|g' /opt/yaman-jmeter/apache-jmeter-5.6.3/bin/jmeter.properties
sed -i 's|#jmeter.save.saveservice.successful=true|jmeter.save.saveservice.successful=true|g' /opt/yaman-jmeter/apache-jmeter-5.6.3/bin/jmeter.properties
sed -i 's|#jmeter.save.saveservice.sent_bytes=true|jmeter.save.saveservice.sent_bytes=true|g' /opt/yaman-jmeter/apache-jmeter-5.6.3/bin/jmeter.properties
sed -i 's|#jmeter.save.saveservice.filename=false|jmeter.save.saveservice.filename=false|g' /opt/yaman-jmeter/apache-jmeter-5.6.3/bin/jmeter.properties
sed -i 's|#jmeter.save.saveservice.encoding=false|jmeter.save.saveservice.encoding=true|g' /opt/yaman-jmeter/apache-jmeter-5.6.3/bin/jmeter.properties
sed -i 's|#jmeter.save.saveservice.idle_time=true|jmeter.save.saveservice.idle_time=true|g' /opt/yaman-jmeter/apache-jmeter-5.6.3/bin/jmeter.properties
sed -i 's|#jmeter.save.saveservice.label=true|jmeter.save.saveservice.label=true|g' /opt/yaman-jmeter/apache-jmeter-5.6.3/bin/jmeter.properties
sed -i 's|#jmeter.save.saveservice.thread_name=true|jmeter.save.saveservice.thread_name=true|g' /opt/yaman-jmeter/apache-jmeter-5.6.3/bin/jmeter.properties
sed -i 's|#jmeter.save.saveservice.assertions=true|jmeter.save.saveservice.assertions=true|g' /opt/yaman-jmeter/apache-jmeter-5.6.3/bin/jmeter.properties
sed -i 's|#jmeter.save.saveservice.thread_counts=true|jmeter.save.saveservice.thread_counts=true|g' /opt/yaman-jmeter/apache-jmeter-5.6.3/bin/jmeter.properties
sed -i 's|#jmeter.save.saveservice.latency=true|jmeter.save.saveservice.latency=true|g' /opt/yaman-jmeter/apache-jmeter-5.6.3/bin/jmeter.properties
sed -i 's|#jmeter.save.saveservice.hostname=false|jmeter.save.saveservice.hostname=true|g' /opt/yaman-jmeter/apache-jmeter-5.6.3/bin/jmeter.properties
sed -i 's|#jmeter.save.saveservice.response_code=true|jmeter.save.saveservice.response_code=true|g' /opt/yaman-jmeter/apache-jmeter-5.6.3/bin/jmeter.properties
sed -i 's|#jmeter.save.saveservice.data_type=true|jmeter.save.saveservice.data_type=true|g' /opt/yaman-jmeter/apache-jmeter-5.6.3/bin/jmeter.properties
sed -i 's|#jmeter.save.saveservice.bytes=true|jmeter.save.saveservice.bytes=true|g' /opt/yaman-jmeter/apache-jmeter-5.6.3/bin/jmeter.properties
sed -i 's|#jmeter.save.saveservice.subresults=true|jmeter.save.saveservice.subresults=false|g' /opt/yaman-jmeter/apache-jmeter-5.6.3/bin/jmeter.properties
sed -i 's|#jmeter.save.saveservice.url=true|jmeter.save.saveservice.url=true|g' /opt/yaman-jmeter/apache-jmeter-5.6.3/bin/jmeter.properties
sed -i 's|#jmeter.save.saveservice.connect_time=true|jmeter.save.saveservice.connect_time=true|g' /opt/yaman-jmeter/apache-jmeter-5.6.3/bin/jmeter.properties
sed -i 's|#jmeter.save.saveservice.sample_count=false|jmeter.save.saveservice.sample_count=true|g' /opt/yaman-jmeter/apache-jmeter-5.6.3/bin/jmeter.properties
sed -i 's|#jmeter.save.saveservice.assertion_results_failure_message=true|jmeter.save.saveservice.assertion_results_failure_message=true|g' /opt/yaman-jmeter/apache-jmeter-5.6.3/bin/jmeter.properties
sed -i 's|#jmeter.save.saveservice.print_field_names=true|jmeter.save.saveservice.print_field_names=true|g' /opt/yaman-jmeter/apache-jmeter-5.6.3/bin/jmeter.properties

#sed -i 's|#server.rmi.ssl.keystore.type=JKS|server.rmi.ssl.keystore.type=PKCS12|g' /opt/yaman-jmeter/apache-jmeter-5.6.3/bin/jmeter.properties
#sed -i 's|#server.rmi.ssl.keystore.file=rmi_keystore.jks|server.rmi.ssl.keystore.file=rmi_keystore.jks|g' /opt/yaman-jmeter/apache-jmeter-5.6.3/bin/jmeter.properties
#sed -i 's|#server.rmi.ssl.keystore.alias=rmi|server.rmi.ssl.keystore.alias=rmi|g' /opt/yaman-jmeter/apache-jmeter-5.6.3/bin/jmeter.properties
#sed -i 's|#server.rmi.ssl.keystore.password=changeit|server.rmi.ssl.keystore.password=UYdOAgYYyuvyQXf1zmWVurHxlzYH7Og5|g' /opt/yaman-jmeter/apache-jmeter-5.6.3/bin/jmeter.properties

sed -i 's|#server.rmi.ssl.disable=false|server.rmi.ssl.disable=true|g' /opt/yaman-jmeter/apache-jmeter-5.6.3/bin/jmeter.properties
sed -i 's|#server_port=1099|server_port=2000|g' /opt/yaman-jmeter/apache-jmeter-5.6.3/bin/jmeter.properties
sed -i 's|#server.rmi.port=1234|server.rmi.port=2000|g' /opt/yaman-jmeter/apache-jmeter-5.6.3/bin/jmeter.properties
sed -i 's|#server.rmi.localport=4000|server.rmi.localport=5000|g' /opt/yaman-jmeter/apache-jmeter-5.6.3/bin/jmeter.properties

###################### Configuração do JMeter Server
cd $JMETER_HOME/bin/
#LOCAL_IP=$(/sbin/ip -o -4 addr list enp0s3 | awk '{print $4}' | cut -d/ -f1)
#LOCAL_IP=$(/sbin/ip -o -4 addr list enp0s5 | awk '{print $4}' | cut -d/ -f1)
LOCAL_IP=$(/sbin/ip -o -4 addr list eth0 | awk '{print $4}' | cut -d/ -f1)
sed -i 's|#RMI_HOST_DEF=-Djava.rmi.server.hostname=xxx.xxx.xxx.xxx|RMI_HOST_DEF=-Djava.rmi.server.hostname='"$LOCAL_IP"'|g' $JMETER_HOME/bin/jmeter-server
sed -i 's|-Dserver_port=${SERVER_PORT:-1099}|-Dserver_port=2000|g' $JMETER_HOME/bin/jmeter-server
sed -i 's|jmeter-server.log|/tmp/jmeter-server.log|g' $JMETER_HOME/bin/jmeter-server

###################### JMeter Server - Memory Improvement
sed -i '54i JVM_ARGS="-Xms256m -Xmx25G -XX:+DisableExplicitGC"' $JMETER_HOME/bin/jmeter
sed -i '32i JVM_ARGS="-Xms256m -Xmx25G -XX:+DisableExplicitGC"' $JMETER_HOME/bin/jmeter.sh

###################### JMeter Server - Service
sudo systemctl stop jmeter-server.service
sudo systemctl disable jmeter-server.service
sudo rm -rf /etc/systemd/system/jmeter-server.service
sudo systemctl daemon-reload

sudo cat <<EOF > /etc/systemd/system/jmeter-server.service
[Unit]
Description=JMeter Server - Load Testing Tool
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/opt/yaman-jmeter/apache-jmeter-5.6.3/bin
Environment="JAVA_HOME=/opt/microsoft-jdk-17"
Environment="JMETER_HOME=/opt/yaman-jmeter/apache-jmeter-5.6.3"
ExecStart=/opt/yaman-jmeter/apache-jmeter-5.6.3/bin/jmeter-server
Restart=always
RestartSec=10s
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable jmeter-server
sudo systemctl start jmeter-server

###################### Disable Swap and SELinux
swapoff -a
sudo setenforce 0

###################### Check Ports and Restart Server
sleep 5s
sudo netstat -anot | grep 5000
sleep 1s
sudo netstat -anot | grep 2000
sleep 1s