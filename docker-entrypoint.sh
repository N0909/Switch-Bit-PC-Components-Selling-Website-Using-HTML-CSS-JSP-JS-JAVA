#!/bin/bash
set -e

# Replace default Tomcat port with Railway's PORT env var
if [ -n "$PORT" ]; then
  sed -i "s/port=\"8080\"/port=\"$PORT\"/g" /usr/local/tomcat/conf/server.xml
fi

# Start Tomcat
catalina.sh run
