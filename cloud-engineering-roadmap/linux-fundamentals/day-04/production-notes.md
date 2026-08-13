```markdown
# Production Troubleshooting Workflow

## Application Down

1. Check process

```bash
ps -ef
Check service
systemctl status myapp
Check application log
tail -f application.log
Check system log
journalctl -u myapp
Check network
ping
ss -tulpn
curl
Find root cause
Restart if necessary