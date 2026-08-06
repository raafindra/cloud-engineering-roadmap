# Case Study 02

## Problem

Server latency spike with High Load Average (14.2) despite low CPU (25%) and Memory (45%) usage.

## Investigation

```bash
top
sudo iostat -xz 1 5
ps aux | awk '$8 ~ /D/'

## Root Cause

High I/O Wait (%wa). Processes trapped in Uninterruptible Sleep (D state) due to disk I/O thrashing.

## Resolution

Killed stuck I/O-heavy processes and optimized application logging.

sudo iotop -oP
sudo kill -9 <PID>

## Verification

uptime
top