#!/bin/bash

NEXUS_USERNAME="admin"
NEXUS_PASSWORD="admin123"

echo "Install Java JDK 8"
yum update -y
yum install -y java-1.8.0-openjdk

echo "Install Nexus OSS"
mkdir /opt/nexus
cd /opt/nexus
wget https://download.sonatype.com/nexus/3/latest-unix.tar.gz
tar -xvf latest-unix.tar.gz
rm latest-unix.tar.gz
mv nexus-3.12.0-01 nexus
useradd nexus
chown -R nexus:nexus /opt/nexus/
ln -s /opt/nexus/nexus/bin/nexus /etc/init.d/nexus
cd /etc/init.d
chkconfig --add nexus
chkconfig --levels 345 nexus on
mv /tmp/nexus.rc /opt/nexus/nexus/bin/nexus.rc
service nexus restart

until $(curl --output /dev/null --silent --head --fail http://localhost:8081); do
    printf '.'
    sleep 2
done


echo "Upload Groovy Script"
curl -v -X POST -u $NEXUS_USERNAME:$NEXUS_PASSWORD --header "Content-Type: application/json" 'http://localhost:8081/service/rest/v1/script' -d @/tmp/repository.json

echo "Execute it"
curl -v -X POST -u $NEXUS_USERNAME:$NEXUS_PASSWORD  --header "Content-Type: text/plain" 'http://localhost:8081/service/rest/v1/script/docker-repository/run'