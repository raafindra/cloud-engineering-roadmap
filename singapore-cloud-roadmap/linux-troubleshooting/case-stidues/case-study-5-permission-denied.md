# Case Study 05

## Problem

SSH access timed out unexpectedly while server still responded to ICMP ping.

## Investigation

ssh -vvv user@server_ip
sudo systemctl status sshd
sudo ss -tulpn | grep ssh
sudo fail2ban-client status sshd

## Root Cause
Client IP address was banned by Fail2ban due to repeated authentication failures from an outdated background script.

## Resolution
Unbanned the client IP address and updated authentication credentials in the script.

sudo fail2ban-client set sshd unbanip <CLIENT_IP>

## Verification

ssh user@server_ip