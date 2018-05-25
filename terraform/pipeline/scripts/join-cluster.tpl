#!/bin/bash

JENKINS_URL="${jenkins_url}"
JENKINS_USERNAME="${jenkins_username}"
JENKINS_PASSWORD="${jenkins_password}"
TOKEN=$(curl -u $JENKINS_USERNAME:$JENKINS_PASSWORD ''$JENKINS_URL'/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,":",//crumb)')
INSTANCE_NAME=$(curl -s 169.254.169.254/latest/meta-data/local-hostname)
INSTANCE_IP=$(curl -s 169.254.169.254/latest/meta-data/local-ipv4)
JENKINS_CREDENTIALS_ID="${jenkins_credentials_id}"

sleep 60

curl -v -u $JENKINS_USERNAME:$JENKINS_PASSWORD -H "$TOKEN" -d 'script=
import hudson.model.Node.Mode
import hudson.slaves.*
import jenkins.model.Jenkins
import hudson.plugins.sshslaves.SSHLauncher
DumbSlave dumb = new DumbSlave("'$INSTANCE_NAME'",
"'$INSTANCE_NAME'",
"/home/ec2-user",
"3",
Mode.NORMAL,
"slaves",
new SSHLauncher("'$INSTANCE_IP'", 22, SSHLauncher.lookupSystemCredentials("'$JENKINS_CREDENTIALS_ID'"), "", null, null, "", "", 60, 3, 15),
RetentionStrategy.INSTANCE)
Jenkins.instance.addNode(dumb)
' $JENKINS_URL/script