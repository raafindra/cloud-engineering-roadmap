# 🔍 Log Analysis & Incident Investigation

Log investigation commands for diagnosing system errors, authentication failures, and service crashes using `journalctl` and core text utilities.

---

## 📜 Systemd Journal (`journalctl`)

```bash
# View real-time logs for a specific service (follow mode)
sudo journalctl -u nginx -f

# Jump directly to the end of logs without paging (great for quick terminal scans)
sudo journalctl -u nginx -e --no-pager

# View logs generated since the current system boot
sudo journalctl -b

# Filter logs by priority (e.g., Error level and above: err, crit, alert, emerg)
sudo journalctl -u nginx -p err..emerg

# View logs within a specific time window
sudo journalctl -u nginx --since "1 hour ago"
sudo journalctl --since "2026-04-01 10:00:00" --until "2026-04-01 10:30:00"

# Combine flags: Explanation of crash logs with context (-x) jumped to end (-e)
sudo journalctl -xeu nginx

# Follow real-time system logs
tail -f /var/log/syslog         # Ubuntu / Debian
tail -f /var/log/messages       # RHEL / CentOS / Rocky

# Inspect recent authentication & SSH access attempts
sudo tail -n 50 /var/log/auth.log   # Ubuntu / Debian
sudo tail -n 50 /var/log/secure     # RHEL / CentOS / Rocky

# Search for specific errors within compressed log archives
zgrep -i "error" /var/log/nginx/error.log.*.gz

# Monitor multiple log files simultaneously
tail -f /var/log/nginx/error.log /var/log/nginx/access.log