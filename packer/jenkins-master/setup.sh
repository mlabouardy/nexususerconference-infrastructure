#!/bin/bash

echo "Install Jenkins stable release"
sudo yum remove -y java
sudo yum install -y java-1.8.0-openjdk
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo
sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
sudo yum install -y jenkins
sudo chkconfig jenkins on

echo "Install Telegraf"
sudo wget https://dl.influxdata.com/telegraf/releases/telegraf-1.6.0-1.x86_64.rpm -O /tmp/telegraf.rpm
sudo yum localinstall -y /tmp/telegraf.rpm
sudo rm /tmp/telegraf.rpm
sudo chkconfig telegraf on

echo "Install git"
sudo yum install -y git

echo "Setup SSH key"
sudo mkdir /var/lib/jenkins/.ssh
sudo touch /var/lib/jenkins/.ssh/known_hosts
sudo chown -R jenkins:jenkins /var/lib/jenkins/.ssh
sudo chmod 700 /var/lib/jenkins/.ssh