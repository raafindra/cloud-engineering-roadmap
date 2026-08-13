# 📊 Performance Monitoring & Resource Triage

Essential Linux diagnostic commands for identifying resource bottlenecks across CPU, Memory, Disk, and I/O.

---

## ⚡ CPU & Load Average

```bash
# Inspect Load Average (1, 5, 15 min metrics)
uptime

# Real-time process and CPU triage
top
htop    # Interactive tree-view (if installed)

# Find top 10 CPU-consuming processes
ps aux --sort=-%cpu | head -n 11

# Check CPU core count to evaluate Load Average capacity
nproc

# Display total, used, free, and cached memory in human-readable format
free -h

# Check detailed memory breakdown, swap usage, and commit limits
cat /proc/meminfo

# Find top 10 Memory-consuming processes
ps aux --sort=-%mem | head -n 11

# Check filesystem space usage
df -h

# Check inode usage (prevents 'No space left on device' when storage seems free)
df -i

# Identify top directories taking up disk space
sudo du -h --max-depth=1 /var | sort -hr

# Monitor real-time disk Read/Write I/O and wait times (requires sysstat)
sudo iostat -xz 1 5

# Identify processes performing heavy disk I/O operations
sudo iotop -oP

# List all running processes
ps aux

# Find processes trapped in Uninterruptible Sleep ('D' state - usually waiting on I/O)
ps aux | awk '$8 ~ /D/'

# List files held open by deleted processes (reclaims hidden disk space)
sudo lsof | grep deleted

# Check listening network ports and associated processes
sudo ss -tulpn