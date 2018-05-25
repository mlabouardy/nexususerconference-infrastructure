#/bin/sh

echo "Install Docker CE"
sudo yum update -y
sudo yum install docker -y
sudo service docker start
sudo usermod -aG docker ec2-user

echo "Install Telegraf"
sudo wget https://dl.influxdata.com/telegraf/releases/telegraf-1.6.0-1.x86_64.rpm -O /tmp/telegraf.rpm
sudo yum localinstall -y /tmp/telegraf.rpm
sudo rm /tmp/telegraf.rpm
sudo chkconfig telegraf on
sudo usermod -aG docker telegraf