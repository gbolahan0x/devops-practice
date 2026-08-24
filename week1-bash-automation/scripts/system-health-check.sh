##!/bin/bash

##############################################
# System Health Check Script
# Purpose: Monitor system resources
# Author: KLAUD
# Date: 24/8/26
# Updated for macOS compatibility
##############################################

# Configuration
LOG_DIR="./logs"
LOG_FILE="$LOG_DIR/system-health-$(date +%Y%m%d).log"

# Create log directory if it doesn't exist
if [ ! -d "$LOG_DIR" ]; then
    mkdir -p "$LOG_DIR"
fi

# Function to log with timestamp
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# Function to get disk usage and check threshold
get_disk_usage() {
    df -h | grep -vE '^Filesystem|^dev|loop' | awk '
    {
        usage=$5
        gsub("%","",usage)

        printf "%s - Used: %s/%s (%s%%)\n", $1, $3, $2, usage

        if (usage >= 80) {
            printf "WARNING: %s disk usage is above 80%%!\n", $1
        }
    }'
}

# Function to get memory usage (macOS)
get_memory_usage() {
    local total=$(sysctl -n hw.memsize | awk '{printf "%.1f GB", $1/1073741824}')
    local pages_active=$(vm_stat | grep "Pages active:" | awk '{print $3}' | sed 's/\.//g')
    local pages_wired=$(vm_stat | grep "Pages wired:" | awk '{print $4}' | sed 's/\.//g')

    local used_bytes=$(( (pages_active + pages_wired) * 4096 ))
    local used=$(awk "BEGIN {printf \"%.1f GB\", $used_bytes/1073741824}")

    echo "Total: $total | Used: $used"
}

# Function to get CPU load (macOS)
get_cpu_load() {
    uptime | sed 's/.*load average: //' | awk '{print "1min: " $1 " | 5min: " $2 " | 15min: " $3}'
}

# Function to get process count
get_process_count() {
    ps aux | wc -l
}

# Function to get top 5 memory-consuming processes
get_top_memory_processes() {
    ps aux | sort -nrk 4 | head -6 | tail -5 | \
    awk '{printf "%-15s %-8s %-8s %s\n", $1, $2, $4, $11}'
}

# Function to get system uptime (macOS compatible)
get_system_uptime() {
    uptime | sed 's/.*up //' | sed 's/,.*user.*//'
}

# Main script
echo "========================================" >> "$LOG_FILE"
log_message "=== SYSTEM HEALTH CHECK STARTED ==="

log_message "DISK USAGE:"
get_disk_usage | while read line; do
    log_message "  $line"
done

log_message "MEMORY USAGE:"
log_message "  $(get_memory_usage)"

log_message "TOP 5 MEMORY-CONSUMING PROCESSES:"
get_top_memory_processes | while read line; do
    log_message "  $line"
done

log_message "CPU LOAD:"
log_message "  $(get_cpu_load)"

log_message "PROCESS COUNT:"
log_message "  $(get_process_count) processes running"

log_message "SYSTEM UPTIME:"
log_message "  $(get_system_uptime)"

log_message "=== SYSTEM HEALTH CHECK COMPLETED ==="

# Print to console as well
echo ""
echo "✓ Health check complete. Log saved to: $LOG_FILE"
echo ""
echo "Recent entries:"
tail -25 "$LOG_FILE"