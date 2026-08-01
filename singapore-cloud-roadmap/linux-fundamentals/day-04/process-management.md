# Linux Process Management

## Check Process

```bash
ps -ef
top

## Kill Process

kill PID
kill -9 PID
pkill java
killall python3

##Background Process

jobs
bg
fg
nohup ./backup.sh > backup.log 2>&1 &

## Notes

Use kill before kill -9
Use nohup for long-running jobs
Monitor logs with tail -f