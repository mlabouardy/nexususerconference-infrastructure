#!/bin/bash

NODE_IP=$(curl -fsS http://169.254.169.254/latest/meta-data/local-ipv4)

docker run -d --restart on-failure:5 \
-e SWARM_DISCOVERY_BUCKET=${swarm_discovery_bucket} \
-e ROLE=${swarm_role} \
-e NODE_IP=$NODE_IP \
-e SWARM_NAME=${swarm_name} \
-v /var/run/docker.sock:/var/run/docker.sock \
mlabouardy/swarm-discovery:latest

if [ "${swarm_role}" == "manager" ]; then
    sleep 15
    lines=$(docker service ls | wc -l)
    if [ $lines == 1 ]; then
        docker service create \
            --name=visualizer \
            --publish=8080:8080/tcp \
            --constraint=node.role==manager \
            --mount=type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock \
            dockersamples/visualizer
    fi
fi