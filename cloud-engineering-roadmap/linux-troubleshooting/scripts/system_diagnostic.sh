#!/bin/bash

# Define log filename based on the current date
LOG_FILE="diagnostic-report-$(date +'%Y%m%d_%H%M%S').log"

# Main function to generate the system diagnostic report
generate_report() {
    echo "=================================="
    echo "Linux System Diagnostic Report"
    echo "=================================="
    echo ""
    echo "Hostname     : $(hostname)"
    echo "Timestamp    : $(date +'%Y-%m-%d %H:%M:%S')"
    echo ""
    echo "Load Average:"
    uptime | awk -F'load average:' '{ print $2 }' | sed 's/^ //'
    echo ""
    echo "CPU Cores:"
    nproc
    echo ""
    echo "Disk Usage:"
    df -h --total | grep -E 'Filesystem|total'
    echo ""
    echo "Memory Usage:"
    free -h
    echo ""
    echo "Running Services:"
    systemctl list-units --type=service --state=running --no-pager | head -n -5
    echo ""
    echo "Failed Services:"
    systemctl list-units --type=service --state=failed --no-pager
    echo ""
    echo "Top CPU Processes:"
    ps aux --sort=-%cpu | head -n 6 | awk '{printf "%-10s %-8s %-6s %-6s %s\n", $1, $2, $3, $4, $11}'
    echo ""
    echo "Top Memory Processes:"
    ps aux --sort=-%mem | head -n 6 | awk '{printf "%-10s %-8s %-6s %-6s %s\n", $1, $2, $3, $4, $11}'
    echo ""
    echo "=================================="
    echo "End of Report"
    echo "=================================="
}

# Run the diagnostic function (capturing both stdout and stderr), stream to screen, and save to log file
generate_report 2>&1 | tee "$LOG_FILE"

echo ""
echo "Report successfully saved to: $LOG_FILE"