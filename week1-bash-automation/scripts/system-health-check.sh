```bash
#!/bin/bash

##############################################
# System Health Check Script
# Purpose: Monitor system resources
# Author: [Your Name]
# Date: $(date +%Y-%m-%d)
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

# Function to get disk usage
get_disk_usage() {
    df -h | grep -E '^/dev/' | awk '{print $1 " - Used: " $3 "/" $2 " (" $5 ")"}'
}

# Function to get memory usage
get_memory_usage() {
    free -h | grep "^Mem:" | awk '{print "Total: " $2 " | Used: " $3 " | Available: " $7}'
}

# Function to get CPU load
get_cpu_load() {
    uptime | awk -F'load average:' '{print $2}'
}

# Function to get process count
get_process_count() {
    ps aux | wc -l
}

# Function to get system uptime
get_system_uptime() {
    uptime -p
}

# Main script
echo "========================================" >> "$LOG_FILE"
log_message "=== SYSTEM HEALTH CHECK STARTED ==="

log_message "DISK USAGE:"
get_disk_usage | while read line; do log_message "  $line"; done

log_message "MEMORY USAGE:"
log_message "  $(get_memory_usage)"

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
tail -15 "$LOG_FILE"
```

