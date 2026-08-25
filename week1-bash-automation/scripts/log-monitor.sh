#!/bin/bash

#######################################
# Log Monitor Script
#Purpose: Analyse and summarize logs
#Usage: ./log-monitor.sh      [log_file_path]
########################################

#check if log file provided
if [ $# -eq 0 ]; then
echo "usage: $0 <log_file_path>"
exit 1
fi

LOG_FILE=$1

#check if file exists
if [ ! -f "$LOG_FILE" ]; then
echo "Error: Log file '$LOG_FILE' not found"
exit 1
fi

echo "====================================="
echo "Log Analysis for: $LOG_FILE"
echo "====================================="
echo ""

#Count different log levels
echo "Log Level Summary:"
echo "-------------------"
grep -oE "ERROR|WWARNING|INFO|DEBUG" "$LOG_FILE" 2>/dev/null | sort | uniq -c | sort -rn || echo "No Standard log levels found"

#show most recent entries
echo "Most Recent Entries (Last 10):"
echo "------------------------------"
tail -10 "$LOG_FILE"
echo ""

#count total line
TOTAL_LINES=$(wc -l < "$LOG_FILE")
echo "Total log entries: $TOTAL_LINES"

#find lines with error 
ERROR_COUNT=$(grep -ic "error" "$LOG_FILE")
echo "Lines containing 'error'': $ERROR_COUNT"
echo ""

# Error rate
if [ $TOTAL_LINES -gt 0 ]; then
ERROR_RATE=$((ERROR_COUNT * 100 / total_lines))
echo "Error rate: $ERROR_RATE%"
fi

echo "======================================="
