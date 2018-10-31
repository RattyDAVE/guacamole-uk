#!/bin/bash

#Start tomcat7 - although it fails
echo "Tomcat8 start script says it fails to start even when it's successful"
service tomcat8 start
service guacd start

tail -f /var/log/tomcat8/catalina.out &

wait
