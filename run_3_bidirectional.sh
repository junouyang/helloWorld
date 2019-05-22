#!/bin/bash

#parameter: hostname port applicationName accessKey1 version accessKey2
echo "params: $1 $2 $3 $4 $5 $6"
cmd1="java -classpath \"/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/charsets.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/deploy.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/ext/cldrdata.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/ext/dnsns.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/ext/jaccess.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/ext/jfxrt.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/ext/localedata.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/ext/nashorn.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/ext/sunec.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/ext/sunjce_provider.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/ext/sunpkcs11.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/ext/zipfs.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/javaws.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/jce.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/jfr.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/jfxswt.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/jsse.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/management-agent.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/plugin.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/resources.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/rt.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/lib/ant-javafx.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/lib/dt.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/lib/javafx-mx.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/lib/jconsole.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/lib/packager.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/lib/sa-jdi.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/lib/tools.jar:/Users/junoyang/source/helloWorld/out/production/helloWorld:/Users/junoyang/source/helloWorld/lib/jetty-all-9.0.4.v20130625.jar:/Users/junoyang/source/helloWorld/lib/commons-io-2.5.jar:/Users/junoyang/source/helloWorld/lib/javax.servlet-api-3.0.1.jar:/Users/junoyang/source/helloWorld/lib/mockito-all-1.10.19.jar:/Users/junoyang/source/helloWorld/lib/commons-lang3-3.5.jar\" \
-Dappdynamics.controller.hostName=$1 \
-Dappdynamics.controller.port=$2 \
-Dappdynamics.controller.ssl.enabled=false \
-Dappdynamics.agent.applicationName=$3-one \
-Dappdynamics.agent.accountAccessKey=$4 \
-javaagent:/Users/junoyang/source/helloWorld/lib/javaagent/$5/javaagent.jar"

cmd2="java -classpath \"/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/charsets.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/deploy.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/ext/cldrdata.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/ext/dnsns.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/ext/jaccess.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/ext/jfxrt.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/ext/localedata.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/ext/nashorn.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/ext/sunec.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/ext/sunjce_provider.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/ext/sunpkcs11.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/ext/zipfs.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/javaws.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/jce.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/jfr.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/jfxswt.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/jsse.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/management-agent.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/plugin.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/resources.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/rt.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/lib/ant-javafx.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/lib/dt.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/lib/javafx-mx.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/lib/jconsole.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/lib/packager.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/lib/sa-jdi.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/lib/tools.jar:/Users/junoyang/source/helloWorld/out/production/helloWorld:/Users/junoyang/source/helloWorld/lib/jetty-all-9.0.4.v20130625.jar:/Users/junoyang/source/helloWorld/lib/commons-io-2.5.jar:/Users/junoyang/source/helloWorld/lib/javax.servlet-api-3.0.1.jar:/Users/junoyang/source/helloWorld/lib/mockito-all-1.10.19.jar:/Users/junoyang/source/helloWorld/lib/commons-lang3-3.5.jar\" \
-Dappdynamics.controller.hostName=$1 \
-Dappdynamics.controller.port=$2 \
-Dappdynamics.controller.ssl.enabled=false \
-Dappdynamics.agent.accountName=customer2 \
-Dappdynamics.agent.applicationName=$3-two \
-Dappdynamics.agent.accountAccessKey=$6 \
-javaagent:/Users/junoyang/source/helloWorld/lib/javaagent/$5/javaagent.jar"

logFolder="logs/$5/"
service1="web"
service2="bookservice"
service3="database"
mkdir $logFolder
echo $logFolder

$cmd1 -Dappdynamics.agent.tierName=$service3 -Dappdynamics.agent.nodeName=$service3-node BackendServiceBiDirection 8989 8988 \
| tee $logFolder/backend-8988.log & \
$cmd2 -Dappdynamics.agent.tierName=$service2 -Dappdynamics.agent.nodeName=$service2-node BackendServiceBiDirection 8988 8989 \
| tee $logFolder/backend-8988.log & \
$cmd2 -Dappdynamics.agent.tierName=client2 -Dappdynamics.agent.nodeName=client2-node TestHelloWorld 8988 \
| tee $logFolder/helloworld.log & \
$cmd1 -Dappdynamics.agent.tierName=$service1 -Dappdynamics.agent.nodeName=$service1-node TestHelloWorld 8989 \
| tee $logFolder/helloworld2.log

# |$cmd -Dappdynamics.agent.tierName=$service1 -Dappdynamics.agent.nodeName=$service1-node TestHelloWorld 8988 \
# | tee $logFolder/helloworld.log