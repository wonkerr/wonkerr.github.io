
apt install mysql-server
apt install apache2
apt install nginx
apt install php

apt install libapache2-php 
apt install libapache2-svn
apt install phpmyadmin



apt update
apt upgrade


//	
lvdisplay	


df -T
du

apt install sysstat
iostat -d -x 10 3
sar -pd 10 3


cat /proc/mdstat
top
vmstat
iostat
mpstat
iotop	apt install iotop 

apt install ufw
ufw enable
ufw default deny
ufw allow from 192.168.20.244

apt install mdadm
apt install lvm2
reboot

mdadm -Asf && vgchange -ay

vi /etc/mdadm.conf
MAILADDR wonkerr@foxmail.com

vi /etc/corntab
@reboot /sbin/mdadm --monitor --scan --oneshot

apt install smaba
/etc/smaba/smb.conf

find /path -type f -exec chmod 644 {} \;    #对目录和子目录里的文件
find /path -type d -exec chmod 755 {} \;  #对目录和子目录path  是路径  type 类型 d 是目录  f是 文件   exec  执行


RAID 监控
apt install smartmontools

smartctl -H /dev/sda 检查硬盘的监控状况
smartctl -t short /dev/sda 快速自检，然后等待一段时间后执行 
	smartctl -l selftest /dev/sda 查看进度和结果
	smartctl -l error /dev/sda 查看错误日志

update-rc.d gogs default
