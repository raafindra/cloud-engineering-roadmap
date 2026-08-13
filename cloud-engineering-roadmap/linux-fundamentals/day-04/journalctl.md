## Service Log
journalctl -u nginx

## Follow Log
journalctl -u nginx -f

## Boot Log
journalctl -b

## Error Only
journalctl -p err

## Notes

Use journalctl when:

Service fails to start
Application log is not created
Troubleshooting systemd services