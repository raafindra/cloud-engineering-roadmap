# Case Study 05

## Problem

Custom service `myapp.service` failed to start with a "Permission denied" error.

## Investigation

systemctl status myapp
journalctl -u myapp -e --no-pager
ls -la /opt/myapp/bin/exec

## Root Cause
Incorrect file permissions and ownership on the application binary (root:root with 700 permission instead of service user).

## Resolution
Updated ownership and permissions of the application binary to match the service user.

sudo chown -R myapp:myapp /opt/myapp
sudo chmod 755 /opt/myapp/bin/exec
sudo systemctl restart myapp

## Verification
systemctl status myapp