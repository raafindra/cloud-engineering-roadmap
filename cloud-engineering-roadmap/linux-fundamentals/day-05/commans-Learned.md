##Package Management
apt update
apt upgrade
apt install
apt remove
apt purge
apt search

##Environment Variables
echo $HOME
printenv
which
export

##Archive
tar -cvf
tar -xvf
tar -czvf
tar -xzvf
gzip

##Disk Usage
df -h
du -sh
lsblk

##Mount
mount
findmnt
umount
mount -a
cat /etc/fstab

##Cron
crontab -l
crontab -e
systemctl status cron

##Shell Script
chmod +x
./script.sh
if
variable
$(date)