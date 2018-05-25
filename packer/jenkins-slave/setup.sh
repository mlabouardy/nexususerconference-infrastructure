#!/bin/bash

echo "Install Java JDK 8"
sudo yum remove -y java
sudo yum install -y java-1.8.0-openjdk

echo "Install Docker engine"
sudo yum update -y
sudo yum install docker -y
sudo service docker start
sudo usermod -aG docker ec2-user

echo "Install git"
sudo yum install -y git

echo "Install Telegraf"
sudo wget https://dl.influxdata.com/telegraf/releases/telegraf-1.6.0-1.x86_64.rpm -O /tmp/telegraf.rpm
sudo yum localinstall -y /tmp/telegraf.rpm
sudo rm /tmp/telegraf.rpm
sudo chkconfig telegraf on
sudo usermod -aG docker telegraf