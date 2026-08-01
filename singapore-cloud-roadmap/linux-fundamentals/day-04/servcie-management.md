## command

systemctl status
systemctl restart
systemctl start
systemctl stop

## proses
Website Down
      │
      ▼
systemctl status nginx
      │
      ▼
Active?
 ┌────┴────┐
 │         │
Yes       No
 │         │
 ▼         ▼
curl localhost
journalctl -u nginx
nginx -t
      │
      ▼
Configuration OK?
      │
      ▼
Reload
      │
      ▼
Restart (if needed)

## Notes
Check status first
Check logs
Restart only if necessary