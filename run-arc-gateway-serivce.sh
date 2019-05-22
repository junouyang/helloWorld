#!/bin/bash

#parameter: hostname port applicationName accessKey version
echo "params: $1 $2 $3"
cmd="java \
-Dappdynamics.controller.hostName=$1 \
-Dappdynamics.controller.port=$2 \
-Dappdynamics.agent.applicationName=$3 \
-Dappdynamics.agent.accountAccessKey=SJ5b2m7d1\$354 \
-javaagent:/Users/jun.ouyang/source/helloWorld/lib/javaagent/4.5/javaagent.jar "

#logFolder="logs/$5/"
service="arc-gateway-service"
#mkdir $logFolder
$cmd -Dappdynamics.agent.tierName=${service} \
 -Dappdynamics.agent.nodeName=${service}-node \
 -Dconfig.arc.host=localhost \
 -Dconfig.arc.port=8090  \
 -Dconfig.controller.host=ec2-34-212-23-200.us-west-2.compute.amazonaws.com \
 -Dconfig.controller.port=8090 \
 -jar /Users/jun.ouyang/source/bitbucket/arc/arc-gateway-service/build/libs/arc-gateway-service.jar
