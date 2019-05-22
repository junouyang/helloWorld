#!/bin/bash

#parameter: hostname port applicationName accessKey version
echo "params: $1 $2 $3 $4 $5 $6 $7 $8 $9"

cmd="java -classpath \"/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/charsets.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/deploy.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/ext/cldrdata.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/ext/dnsns.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/ext/jaccess.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/ext/jfxrt.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/ext/localedata.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/ext/nashorn.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/ext/sunec.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/ext/sunjce_provider.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/ext/sunpkcs11.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/ext/zipfs.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/javaws.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/jce.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/jfr.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/jfxswt.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/jsse.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/management-agent.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/plugin.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/resources.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/rt.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/lib/ant-javafx.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/lib/dt.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/lib/javafx-mx.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/lib/jconsole.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/lib/packager.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/lib/sa-jdi.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/lib/tools.jar:/Users/jun.ouyang/source/helloWorld/out/production/helloWorld:/Users/jun.ouyang/source/helloWorld/lib/jetty-all-9.0.4.v20130625.jar:/Users/jun.ouyang/source/helloWorld/lib/commons-io-2.5.jar:/Users/jun.ouyang/source/helloWorld/lib/javax.servlet-api-3.0.1.jar:/Users/jun.ouyang/source/helloWorld/lib/mockito-all-1.10.19.jar:/Users/jun.ouyang/source/helloWorld/lib/commons-lang3-3.5.jar\" \
-Dappdynamics.controller.hostName=$1 \
-Dappdynamics.controller.port=$2 \
-Dappdynamics.agent.accountAccessKey=$3"
version="4.2"

logFolder="logs/kakaka/"
service1="$4-web"
service2="$5-bookservice"
service3="$6-database"
echo $logFolder
mkdir $logFolder

#$cmd -Dappdynamics.agent.applicationName=$3 -Dappdynamics.agent.tierName=$service1 \
#-Dappdynamics.agent.nodeName=$service1-node TestHelloWorld 8988 | tee $logFolder/helloworld.log & \
$cmd -Dappdynamics.agent.applicationName=$4 -Dappdynamics.agent.tierName=$service1 \
-javaagent:/Users/jun.ouyang/source/helloWorld/lib/javaagent/$version/javaagent.jar \
-Dappdynamics.agent.nodeName=$service1-node TestHelloWorld 8988 | tee $logFolder/helloworld.log & \
$cmd -Dappdynamics.agent.applicationName=$4 -Dappdynamics.agent.tierName=$service1 \
-javaagent:/Users/jun.ouyang/source/helloWorld/lib/javaagent/$version/javaagent.jar \
-Dappdynamics.agent.nodeName=$service1-node TestHelloWorld 8990 | tee $logFolder/helloworld.log & \
$cmd -Dappdynamics.agent.applicationName=$5 -Dappdynamics.agent.tierName=$service2 \
-javaagent:/Users/jun.ouyang/source/helloWorld/lib/javaagent/$version/javaagent.jar \
-Dappdynamics.agent.nodeName=$service2-node BackendService 8988 8989 | tee $logFolder/backend1-8988.log & \
$cmd -Dappdynamics.agent.applicationName=$6 -Dappdynamics.agent.tierName=$service3 \
-javaagent:/Users/jun.ouyang/source/helloWorld/lib/javaagent/$version/javaagent.jar \
-Dappdynamics.agent.nodeName=$service3-node BackendService 8989 | tee $logFolder/backend2-8988.log & \
$cmd -Dappdynamics.agent.applicationName=$7 -Dappdynamics.agent.tierName=$service3 \
-javaagent:/Users/jun.ouyang/source/helloWorld/lib/javaagent/$version/javaagent.jar \
-Dappdynamics.agent.nodeName=kakaka-node BackendService 8990 8989 | tee $logFolder/backend3-8988.log & \


