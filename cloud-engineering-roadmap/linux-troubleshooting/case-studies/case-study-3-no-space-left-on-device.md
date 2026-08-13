# Case Study 03

## Problem

Applications failed to write data returning "No space left on device" error despite 50% free disk storage.

## Investigation

df -h
df -i
sudo lsof | grep deleted

## Root Cause
Inode exhaustion (100% IUse) caused by millions of temporary cache files.

## Resolution
Cleared the directory containing accumulated unused cache files.

sudo find /var/tmp/cache -type f -delete

## Verification
df -i