#!/bin/bash

# =====================================================
# SCRIPT PURPOSE
# Generate a simple linux system health report.
#
# FEATURES :
# - Hostname
# - Current Date
# - Disk Usage
# - Memory Usage
# - Service Status
# =====================================================

# List of Variable
HOST=$(hostname)
TODAY=$(date)

# Generate log filename automatically based on timestamp
LOG_DATE=$(date +'%Y%m%d_%H%M%S')
LOG_FILE="system_report_${LOG_DATE}.log"

# Direct all output(stdout + stderr) to terminal + Log file
exec > >(tee -a "$LOG_FILE") 2>&1

echo "Log file saved to: $LOG_FILE"

# Function to check each service
check_service(){
    local service=$1
    if systemctl is-active --quiet "$service"; then
        echo "$service : Running"
    else
        echo "$service : Not Running"
    fi
}

# List of service
SERVICES=("ssh" "cron" "docker")

# System Health Report
echo "===================================="
echo "System Health Report"
echo "===================================="

echo
echo "Hostname : $HOST"
echo "Date     : $TODAY"

echo
echo "Disk Usage"
df -hT

echo "Memory Usage"
free -h

# Looping to check each service

echo
echo "service Status"

for service in "${SERVICES[@]}"; do
    check_service "$service"
done