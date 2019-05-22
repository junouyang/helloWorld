#!/bin/bash

#parameter: hostname port applicationName accessKey version
echo "params: $1 $2 $3 $"
cmd="java -classpath \"/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/charsets.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/deploy.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/ext/cldrdata.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/ext/dnsns.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/ext/jaccess.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/ext/jfxrt.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/ext/localedata.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/ext/nashorn.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/ext/sunec.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/ext/sunjce_provider.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/ext/sunpkcs11.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/ext/zipfs.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/javaws.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/jce.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/jfr.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/jfxswt.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/jsse.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/management-agent.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/plugin.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/resources.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/jre/lib/rt.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/lib/ant-javafx.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/lib/dt.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/lib/javafx-mx.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/lib/jconsole.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/lib/packager.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/lib/sa-jdi.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home/lib/tools.jar:/Users/jun.ouyang/source/helloWorld/out/production/helloWorld:/Users/jun.ouyang/source/helloWorld/lib/jetty-all-9.0.4.v20130625.jar:/Users/jun.ouyang/source/helloWorld/lib/commons-io-2.5.jar:/Users/jun.ouyang/source/helloWorld/lib/javax.servlet-api-3.0.1.jar:/Users/jun.ouyang/source/helloWorld/lib/mockito-all-1.10.19.jar:/Users/jun.ouyang/source/helloWorld/lib/commons-lang3-3.5.jar\" \
-Dappdynamics.controller.hostName=localhost \
-Dappdynamics.controller.port=8080 \
-javaagent:/Users/jun.ouyang/source/helloWorld/lib/javaagent/fed/javaagent.jar"

#logFolder="logs/$5/"
service1="web"
service2="bookservice"
service3="database"
li
echo $logFolder
mkdir $logFolder

#$cmd -Dappdynamics.agent.applicationName=Downstream -Dappdynamics.agent.tierName=tier3 \
#-Dappdynamics.agent.accountName=customer2 -Dappdynamics.agent.accountAccessKey=b71beccb-a06e-481d-a7c0-86673435785a \
#-Dappdynamics.agent.nodeName=node3 BackendService 8989 true & \
$cmd -Dappdynamics.agent.applicationName=Loopstart -Dappdynamics.agent.tierName=tier2 \
-Dappdynamics.agent.accountName=federation_account1 -Dappdynamics.agent.accountAccessKey=e5a5d899-7662-496b-85b3-a5fccac58b92 \
-Dappdynamics.agent.nodeName=Loopstart BackendServiceLoop1 & \
$cmd -Dappdynamics.agent.applicationName=Loopend -Dappdynamics.agent.tierName=tier3 \
-Dappdynamics.agent.accountName=federation_account4 -Dappdynamics.agent.accountAccessKey=4d4ca682-e7f4-4496-b2d1-6be2370ed112 \
-Dappdynamics.agent.nodeName=loopend BackendServiceLoop & \
$cmd -Dappdynamics.agent.applicationName=client -Dappdynamics.agent.tierName=tier1 \
-Dappdynamics.agent.accountName=federation_account2 -Dappdynamics.agent.accountAccessKey=c4c7f201-cf85-4fe6-8628-b53a585cf3a9 \
-Dappdynamics.agent.nodeName=node1 TestHelloWorldLoop