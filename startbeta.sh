#!/bin/bash

#Start tomcat7 - although it fails
echo "Tomcat9 start script says it fails to start even when it's successful"
service tomcat9 start
service guacd start

tail -f /var/log/tomcat9/catalina.out &

wait
