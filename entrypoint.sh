#!/bin/bash
# Start Tomcat
/opt/tomcat/bin/startup.sh
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start Tomcat: $status"
  exit $status
fi


trap "/opt/tomcat/bin/shutdown.sh;exit $?" SIGTERM SIGINT
# Naive check runs checks once a minute to see if either of the processes exited.
# This illustrates part of the heavy lifting you need to do if you want to run
# more than one service in a container. The container exits with an error
# if it detects that either of the processes has exited.
# Otherwise it loops forever, waking up every 60 seconds

while true; do
  ps aux |grep Bootstrap |grep -q -v grep
  Tomcat_1_STATUS=$?
  # If the grep above finds anything, it exit with 0 status
  # If it is not  0, then something is wrong
  if [ $Tomcat_1_STATUS -ne 0 ]; then
    echo "Tomcat process has already exited."
    exit 1
  fi
sleep 5

done
