#!/usr/bin/env bash
#usage : ma.sh applicationName componentName nodeName version
java -jar lib/machineagent/$4/machineagent.jar -Dappdynamics.agent.applicationName=$1 -Dappdynamics.agent.tierName=$2 -Dappdynamics.controller.hostName=$3  -Dappdynamics.controller.port=8080 -Dappdynamics.agent.accountAccessKey=SJ5b2m7d1\$354 -Dappdynamics.agent.uniqueHostId=uhid0731_5