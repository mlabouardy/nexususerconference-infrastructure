#/bin/sh

echo "Install Telegraf"
wget https://dl.influxdata.com/telegraf/releases/telegraf-1.6.0-1.x86_64.rpm -O /tmp/telegraf.rpm
yum localinstall -y /tmp/telegraf.rpm
rm /tmp/telegraf.rpm
chkconfig telegraf on
usermod -aG docker telegraf
mv /tmp/telegraf.conf /etc/telegraf/telegraf.conf
service telegraf start

echo "Install Docker CE"
yum update -y
yum install docker -y
service docker start
usermod -aG docker ec2-user
mv /tmp/docker /etc/sysconfig/docker
chmod 644 /etc/sysconfig/docker
service docker restart