#!/bin/bash
# Set the log file to be user-owned
PROFINET_LOG_FILE=$STORAGE_LOGS_PATH/profinet_driver_log.txt
touch $PROFINET_LOG_FILE

# Cycle log files
for (( i=9; i>0; i-- )); do
	if [ -f $PROFINET_LOG_FILE\_$i ]; then
	    mv $PROFINET_LOG_FILE\_$i $PROFINET_LOG_FILE\_$(($i+1))
	fi
done
if [ -f $PROFINET_LOG_FILE ]; then
	mv $PROFINET_LOG_FILE $PROFINET_LOG_FILE\_$(($i+1))
fi

stdbuf --output=L chrt --rr 99 /root/goal_linux_x64.bin -i $CONNECTIVITY_INTERFACE
