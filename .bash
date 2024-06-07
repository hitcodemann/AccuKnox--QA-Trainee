#!/bin/bash

# Thresholds
CPU_THRESHOLD=80
MEMORY_THRESHOLD=80
DISK_THRESHOLD=80
LOG_FILE="system_health.log"

# Function to check CPU usage
check_cpu_usage() {
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
    echo "CPU Usage: $CPU_USAGE%"
    if (( $(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc -l) )); then
        echo "Alert: CPU usage is above $CPU_THRESHOLD%" | tee -a $LOG_FILE
    fi
}

# Function to check memory usage
check_memory_usage() {
    MEMORY_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
    echo "Memory Usage: $MEMORY_USAGE%"
    if (( $(echo "$MEMORY_USAGE > $MEMORY_THRESHOLD" | bc -l) )); then
        echo "Alert: Memory usage is above $MEMORY_THRESHOLD%" | tee -a $LOG_FILE
    fi
}

# Function to check disk usage
check_disk_usage() {
    DISK_USAGE=$(df / | grep / | awk '{ print $5 }' | sed 's/%//g')
    echo "Disk Usage: $DISK_USAGE%"
    if [ "$DISK_USAGE" -gt "$DISK_THRESHOLD" ]; then
        echo "Alert: Disk usage is above $DISK_THRESHOLD%" | tee -a $LOG_FILE
    fi
}

# Function to check running processes
check_running_processes() {
    RUNNING_PROCESSES=$(ps aux | wc -l)
    echo "Running Processes: $RUNNING_PROCESSES"
}

# Main function to check system health
check_system_health() {
    echo "Checking system health..."
    check_cpu_usage
    check_memory_usage
    check_disk_usage
    check_running_processes
    echo "System health check completed."
}

# Run the system health check
check_system_health
