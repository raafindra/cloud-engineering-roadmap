## Route
ip route

## Ping
ping google.com
ping 8.8.8.8

## Listening Ports
ss -tulpn

## HTTP Test
curl http://localhost:8080

## DNS
nslookup google.com
dig google.com

## Notes

Troubleshooting flow:

Application
↓
Service
↓
Logs
↓
DNS
↓
Network
↓
Port
↓
Root Cause