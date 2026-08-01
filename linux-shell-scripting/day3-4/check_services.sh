#!/bin/bash

# ==============================================================================
# SCRIPT PURPOSE:
# This script verifies the status of several critical system services 
# (such as SSH, Docker, Cron) on a Linux system using systemctl.
#
# HOW IT WORKS:
# - Accepts a service name as a parameter in the check_service() function.
# - Checks whether the service is active using `systemctl is-active`.
# - Displays the active/inactive status dynamically based on the service name.
# - Uses a loop to automatically process a list of services.
# ==============================================================================

# Function to check service status
check_service() {
    local service_name="$1"

    # Check if the service is active (suppressing output, checking exit code only)
    if systemctl is-active --quiet "$service_name"; then
        echo "$service_name is running"
    else
        echo "$service_name is not running"
    fi
}

# List of services to inspect
services=("ssh" "cron" "docker")

# Loop to check each service
for service in "${services[@]}"; do
    check_service "$service"
done