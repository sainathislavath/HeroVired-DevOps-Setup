# HeroVired-DevOps-Setup

# Task 1: System Monitoring Setup

---

## Objective

Configure a monitoring system to track **CPU**, **memory**, **disk usage**, and **processes**. 
Ensure logs are saved for capacity planning and performance monitoring.

---

## Tools Used

- **htop**: Real-time process viewer.
- **df**: Disk space usage.
- **du**: Directory-level space usage.
- **ps/top**: Resource-intensive process tracking.
- **Bash script**: For automation and logging.

---

## Log File Structure

```
/system_log/
├── system_monitor_YYYY-MM-DD.log
├── disk_usage_YYYY-MM-DD.log
├── home_dir_usage_YYYY-MM-DD.log
├── top_mem_processes_YYYY-MM-DD.log
└── top_cpu_processes_YYYY-MM-DD.log

```

## Output

Run the script with: `./monitor.sh`

You’ll see log files generated under /system_log/ relative to the script.
Use ls to view them and cat <filename> to verify the content.

---

### 1. System Monitoring with htop

![System Monitoring](./images/1.png)

### 2. Disk Usage with df

![Disk Usage](./images/2.png)

### 3. Directory Space with du

![Directory Usage](./images/3.png)

### 4. Top Memory-Consuming Processes

![Top Memory](./images/4.png)

### 5. Top CPU-Consuming Processes

![Top CPU](./images/5.png)

### 6. Log Files in /system_log

![Log Files](./images/6.png)
