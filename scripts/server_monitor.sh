#!/bin/bash

LOGFILE="$HOME/server-monitor/logs/server_monitor.log"

exec > >(tee -a "$LOGFILE") 2>&1

echo "=========================================="
echo "       LINUX SERVER MONITORING"
echo "=========================================="
echo "Hostname : $(hostname)"
echo "Date     : $(date)"
echo

echo "===== CPU INFORMATION ====="
top -bn1 | grep "Cpu(s)"
echo

echo "===== MEMORY INFORMATION ====="
free -h
echo

echo "===== DISK INFORMATION ====="
df -h
echo

echo "===== TOP PROCESSES ====="
ps aux --sort=-%cpu | head -n 6
echo

echo "===== SERVICE STATUS ====="

for service in sshd crond
do
    if systemctl is-active --quiet "$service"; then
        echo "$service : RUNNING"
    else
        echo "$service : NOT RUNNING"
    fi
done

echo

echo "===== NETWORK STATUS ====="

if ping -c 1 -W 2 8.8.8.8 > /dev/null 2>&1
then
    echo "Internet : CONNECTED"
else
    echo "Internet : NOT CONNECTED"
fi

echo
echo "=========================================="
echo "       MONITORING COMPLETED"
echo "=========================================="
echo
