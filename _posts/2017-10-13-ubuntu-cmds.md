---
layout: post
title:  "搭建静态博客"
date:   2016-05-01
categories: 博客
tags: blog github jekyll
---

* content
{:toc}

# NAS Ubuntu Server
* Apache2 + PHP + SVN
* Nginx + MantisBT
* GoGitSrv
* OpenLDAP
* MySQL
* Samba
* DNS

## Enable Root Account

> sudo vi /etc/ssh/sshd_config

PermitRootLogin yes

:wq

> sudo passwd root

## Config source

> vi /etc/apt/source.list

:wq

## config network

> vi /etc/netplan/...

## install softwares

apt install mysql-server
apt install apache2
apt install nginx
apt install php

apt install libapache2-php 
apt install libapache2-mod-svn
apt install phpmyadmin

## update softwares
apt update
apt upgrade

//	
lvdisplay	

df -T  | df -h
du -hs

cat /proc/mdstat
top
vmstat
iotop
apt install iotop 

apt install ufw
ufw enable
ufw default deny
ufw allow from 192.168.20.244

apt install mdadm
apt install lvm2
reboot

mdadm -Asf && vgchange -ay

apt install smaba
/etc/smaba/smb.conf

find /path -type f -exec chmod 644 {} \;    #对目录和子目录里的文件
find /path -type d -exec chmod 755 {} \;  #对目录和子目录path  是路径  type 类型 d 是目录  f是 文件   exec  执行

## 挂在分区
> blkid 查看分区类型
> ls -l /dev/disk/by-uuid/ 查看 UUID 映射关系
> vi /etc/fstab

UUID=xxxx-xx-xx-xx-xxxxxx /volume/share ext4 defaults 0 0

> mount -a

## 配置 Samba

> useradd share -s /shin/nologin -d /dev/null


## 配置 MySQL

> mv /var/lib/mysql /volume/repos/dat/mysql
> ln -s /volume/repos/dat/mysql /var/lib/mysql

> cat /etc/apparmor.d/usr.sbin.mysqld

在 WINDOWS 上，初始化数据库目录，并启动一个单独的服务
> mysqld --initialize --datadir=W:/Database/MySQL --basedir=W:\Services\MySQL
> mysqld --standalone



## 配置 Apache2

> ln -s /volume/repos/www /nas/www
> ln -s /volume/repos/svn /nas/svn
> vi /etc/apache2/httpd.conf

IncludeOptional /nas/www/httpd.conf

> vi /etc/apache2/ports.conf

Listen 1080

## 配置 SubVersion

> apt install subversion
> apt install libapache2-mod-svn
> apt install libapache2-mod-ldap-userdir
> a2enmod authnz-ldap
> vi /etc/apache2/apache2.conf

IncludeOptional /volume/repos/svn/httpd.conf

## 配置 Nginx

> vi /etc/nginx/nginx.conf
> apt install php7.2-fpm
> /etc/init.d/php7.2-fpm start
> update-rc.d php7.2-fpm defaults

> ln -s /volume/repos/etc/ngx/sites/default /etc/nginx/sites-enabled/default
> ln -s /volume/repos/etc/ngx/sites/task /etc/nginx/sites-enabled/task
> ln -s /volume/repos/etc/ngx/sites/gogs /etc/nginx/sites-enabled/gogs
> ln -s /volume/repos/etc/ngx/sites/svn /etc/nginx/sites-enabled/svn

> apt install php7.2-mbstring
> apt install php7.2-sqlite3
> apt install php7.2-mysql
> apt install php7.2-ldap

## 安装 MySQL
> apt install mysql-server
> service mysql start
> mysql -u root

mysql> use mysql;
mysql> update user set authentication_string=password('XnGisRoot') where user='root';
mysql> update user set plugin='mysql_native_password' where user='root';
mysql> flush privileges;  

### 修改 MySQL DataDir

https://blog.csdn.net/qq_33571718/article/details/71425623


phpMyAdmin 连接失败的处理方式
mysql> use mysql;
mysql> ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'XnGisRoot'; ;
mysql> flush privileges;  

> apt install openssl
> a2enmod ssl
> openssl req -x509 -newkey rsa:1024 -keyout apache.pem -out apache.pem -nodes -days 999
> systemctl restart apache2

#?> mv /var/lib/mysql /volume/repos/dat/mysql
#?> ln /volume/repos/dat/mysql /var/lib/mysql

## 配置 GOGS

> cp /volume/repos/git/gogs/scripts/init/debian/gogs /etc/init.d/
> chmod +x /etc/init.d/gogs

## 配置 DNS

> vi /etc/bind/named.conf
include "/nas/dns/named.conf.nas";

> ln -s /volume/repos/nas/dns /nas/dns

> /etc/init.d/bind9 restart
> tail /var/syslog

## 配置 LDAP
> apt install slapd
> apt install ldap-utils
> slapcat > backup.ldif	// 备份数据
