#!/bin/bash

# Start Tomcat
/opt/tomcat/bin/startup.sh
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start Tomcat: $status"
  exit $status
fi

# Catches SIGTERM & SIGINT and runs gracefull shutdown. 
# Important: sleep seems to prevent SIGTERM reaction and delays it, so 5 seconds is pretty good
trap "/opt/tomcat/bin/shutdown.sh; exit $?" SIGTERM SIGINT

# Checks every 5 second - longer will delay the response to SIGTERM
# Assume that if process is not running - it failed, as we trap the SIGTERM & SIGINT, 
# and gracefully shutting down the server and exiting earlier with exit status of shutdown.sh script

while true; do
  ps aux |grep Bootstrap |grep -q -v grep
  Tomcat_1_STATUS=$?
  # If the grep above finds anything, it exit with 0 status
  # If it is not  0, then something is wrong
  if [ $Tomcat_1_STATUS -ne 0 ]; then
    echo "Tomcat process has exited without unexpectedly."
    exit 1
  fi
sleep 5

done
