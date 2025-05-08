#!/bin/bash

LOG_DIR=~/system_log
DATE=$(date +%F)
mkdir -p "$LOG_DIR"

top -b -n 1 > "$LOG_DIR/system_monitor_$DATE.log"
df -h > "$LOG_DIR/disk_usage_$DATE.log"
sudo du -sh /home/* > "$LOG_DIR/home_dir_usage_$DATE.log"
ps aux --sort=-%mem | head -10 > "$LOG_DIR/top_mem_processes_$DATE.log"
ps aux --sort=-%cpu | head -10 > "$LOG_DIR/top_cpu_processes_$DATE.log"

echo "Monitoring logs saved to $LOG_DIR"
