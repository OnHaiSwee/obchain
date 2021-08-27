#!/bin/bash

# Function: to start, stop and restart java-obc.
# Usage: bash work.sh start|stop|restart.
# Note: modify the paths and private key to your own.

# Auther: haoyouqiang
# Since: 2018/5/27 
# Version: 1.0

if [ $# -ne 1 ]; then
    echo "Usage: bash work.sh start|stop|restart."
    exit 1
fi295BD812"

case "${1}" in
    start)
        # Already running
        if [ -f ${PID_FILE_PATH} ]; then
            pid=$(cat ${PID_FILE_PATH})
            if $(ps -p ${pid} > /dev/null); then
                echo "Already running [PID: ${pid}], you can stop it and retry."
                exit 1
            fi
        fi

        nohup java ${JVM_OPTIONS} \
            -jar ${JAR_FILE_PATH} \
            -p ${PRIVATE_KEY} --witness \
            -c ${CONF_FILE_PATH} \
            > ${LOG_FILE_PATH} 2>&1 \
            & echo $! > ${PID_FILE_PATH}

        if [ $? -eq 0 ]; then
            echo "Succeeded to start java-obc."
        else
            echo "Failed to start java-obc."
        fi
    ;;
    stop)
        kill $(cat ${PID_FILE_PATH})

        if [ $? -eq 0 ]; then
            rm ${PID_FILE_PATH}
            echo "Succeeded to stop java-obc."
        else
            echo "Failed to stop java-obc."
        fi
    ;;
    restart)
        ${0} stop && sleep 1 && ${0} start
    ;;
esac

