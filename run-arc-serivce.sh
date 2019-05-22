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
service="arc-service"
#mkdir $logFolder
$cmd -Dappdynamics.agent.tierName=${service} -Dappdynamics.agent.nodeName=${service}-node -Dserver.port=8090 -jar /Users/jun.ouyang/source/bitbucket/arc/arc-service/build/libs/arc-service-0.1.0.jar
