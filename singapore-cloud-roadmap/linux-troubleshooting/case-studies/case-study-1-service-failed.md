# Case Study 01

## Problem

Nginx service failed to start.

## Investigation

```bash
systemctl status nginx
journalctl -u nginx
nginx -t
```

## Root Cause

Configuration syntax error.

## Resolution

Fixed nginx.conf and restarted the service.

## Verification

```bash
systemctl status nginx
curl -I http://localhost
```