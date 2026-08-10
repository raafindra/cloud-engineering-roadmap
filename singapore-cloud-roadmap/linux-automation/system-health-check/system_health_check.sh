#!/bin/bash

# Ensure script fails on unset variables
set -u

# ==========================================
# CONFIGURATION & GLOBAL VARIABLES
# ==========================================
HEALTH_STATUS=0
DISK_THRESHOLD=90                 # Maximum disk usage threshold percentage (%)
MEM_AVAILABLE_PCT_THRESHOLD=70     # Minimum free memory threshold percentage (%)

# Hostname setup
HOSTNAME=$(hostname)

# Portable Log File Path (Saved relative to the script's directory)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="${SCRIPT_DIR}/log"
LOG_FILE="${LOG_DIR}/system_health_check.log"

# Array of services to check via loop
SERVICES=("ssh" "cron" "docker")

# Associative array to store summary results
declare -A RESULTS

# Ensure log directory exists
mkdir -p "$LOG_DIR" 2>/dev/null || true

# ==========================================
# LOGGING & HELPER FUNCTIONS
# ==========================================
log() {
    local level="$1"
    local message="$2"
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local log_entry="$timestamp [$level] [$HOSTNAME] $message"

   
    echo "$log_entry" >&2

  
    if ! echo "$log_entry" >> "$LOG_FILE" 2>/dev/null; then
        echo "$timestamp [WARN] [$HOSTNAME] Logging failed: Unable to write to $LOG_FILE" >&2
    fi
}

# ==========================================
# HEALTH CHECK FUNCTIONS
# ==========================================
check_disk() {
    log "INFO" "Checking Disk Usage..."
    local usage
    usage=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')

    if [[ "$usage" -le "$DISK_THRESHOLD" ]]; then
        log "INFO" "Disk usage is OK (${usage}%)"
        RESULTS[Disk]="OK (${usage}%)"
    else
        log "ERROR" "Disk usage exceeds threshold (${usage}%)"
        RESULTS[Disk]="FAILED (${usage}%)"
        HEALTH_STATUS=1
    fi
}

check_memory() {
    log "INFO" "Checking Memory Usage..."
    local available_mem_pct
    
    # Calculate available memory percentage: (available / total) * 100
    available_mem_pct=$(free | awk '/Mem:/ {printf "%.0f", ($7/$2)*100}')

    if [[ "$available_mem_pct" -ge "$MEM_AVAILABLE_PCT_THRESHOLD" ]]; then
        log "INFO" "Memory availability is OK (${available_mem_pct}% free)"
        RESULTS[Memory]="OK (${available_mem_pct}% free)"
    else
        log "ERROR" "Low memory available (${available_mem_pct}% free, expected >= ${MEM_AVAILABLE_PCT_THRESHOLD}%)"
        RESULTS[Memory]="FAILED (${available_mem_pct}% free)"
        HEALTH_STATUS=1
    fi
}

# Reusable function to check service status
check_service() {
    local service="$1"
    log "INFO" "Checking $service service..."

    # Handle service active checks (supports common service aliases like sshd/crond)
    local active_check=1
    if systemctl is-active --quiet "$service"; then
        active_check=0
    elif [[ "$service" == "ssh" ]] && systemctl is-active --quiet sshd; then
        active_check=0
    elif [[ "$service" == "cron" ]] && systemctl is-active --quiet crond; then
        active_check=0
    fi

    if [[ $active_check -eq 0 ]]; then
        log "INFO" "$service is running"
        RESULTS[$service]="OK"
    else
        log "ERROR" "$service is not running"
        RESULTS[$service]="FAILED"
        HEALTH_STATUS=1
    fi
}

# ==========================================
# MAIN EXECUTION PROCESS
# ==========================================
log "INFO" "Starting health check"

# 1. Check Disk Usage
check_disk

# 2. Check Memory Availability
check_memory

# 3. Check All Services using Loop
for service in "${SERVICES[@]}"; do
    check_service "$service"
done

# ==========================================
# SUMMARY REPORT & EXIT STATUS
# ==========================================
log "INFO" "--- SUMMARY REPORT FOR ${HOSTNAME} ---"
log "INFO" "Disk        : ${RESULTS[Disk]}"
log "INFO" "Memory      : ${RESULTS[Memory]}"

for service in "${SERVICES[@]}"; do
    log "INFO" "$(printf '%-11s' "$service") : ${RESULTS[$service]}"
done

if [[ $HEALTH_STATUS -eq 0 ]]; then
    log "INFO" "Health check completed - OVERALL STATUS: HEALTHY"
    exit 0
else
    log "ERROR" "Health check completed - OVERALL STATUS: UNHEALTHY"
    exit 1
fi