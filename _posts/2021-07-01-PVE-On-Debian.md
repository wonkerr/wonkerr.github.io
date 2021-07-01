---
categories  : 网络存储
excerpt     : 
title       : 在 Debian 系统上安装 PVE
tags        : Debian PVE
---

在 Debian 上部署 PVE 其实比较简单的，关键是每一步都要注意，不能犯原则性错误。
好吧此处记录一些处理问题的过程，以作警醒！
<!--- more --->

* content
{:toc}

## 为什么使用 Debian
之前我是直接使用 PVE 的安装镜像进行的安装，因为使用 MDADM 进行 RAID 的管理，不大喜欢 LVM ，所以对系统安装时的 LVM 分区非常不爽。
但是 PVE 安装时又不方便深度定制磁盘分区和文件系统，所以决定首先安装 Debian ，然后在 Debian 上安装 PVE，幸好网上有教程

## 安装 Debian
这个过程是比较简单的，下载最新的 ISO 镜像，使用工具将 ISO 写入 U 盘，然后启动安装
系统有一块 128 GB 的 SSD ，所以首先分区 8GB 安装系统，如果是 PVE 直接安装 8GB 的分区是不行的。

## 修改更新源
默认的源更新速度较慢，所以可以选择 163 或者 aliyun，这里我使用的是阿里云的

``` bash
    # cat /etc/apt/sources.list
    deb http://mirrors.aliyun.com/debian/ buster main non-free contrib
    deb http://mirrors.aliyun.com/debian-security buster/updates main
    deb http://mirrors.aliyun.com/debian/ buster-updates main non-free contrib
    deb http://mirrors.aliyun.com/debian/ buster-backports main non-free contrib
```
## 安装 PVE
具体安装过程不再细说，具体参见 https://blog.csdn.net/wy7651421/article/details/104091348

### 问题 一
安装文中的镜像地址（官网地址），65 MB 的安装包，需要下载几个小时，还不一定成功，只好搜索镜像地址，好在找到了 163 的镜像地址。
但是更新源的时候局让报错，并友情提示你的镜像库是不是正在同步？因为哈希和大小对不上
然后使用‘中国科学技术大学‘的镜像，发现可以正常安装，虽然每次刚开始会卡顿一下，但是后面速度溜溜额，几分钟搞定。
当然如果你知道自己的网络是什么线路，可以参考 https://mirrors.ustc.edu.cn/ 给出的线路说明使用更好的线路

### 问题二
配置好第一个虚拟机之后，试一试开机自启动，结果 PVE 的 Web 管理页面打不开了，更加神奇的是端口能够 telnet 通，可就是没响应
重启 pve-cluster 服务？  -- 不行
重启 pveproxy 服务？ -- 还是不行
使用 netstat -ntlp 看看，发现一个神奇的结果
``` bash
    # netstat -ntlp
    Active Internet connections (only servers)
    Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
    tcp        0      0 0.0.0.0:111             0.0.0.0:*               LISTEN      1/init
    tcp        0      0 0.0.0.0:80              0.0.0.0:*               LISTEN      930/nginx: master p
    tcp        0      0 127.0.0.1:85            0.0.0.0:*               LISTEN      1166/pvedaemon
    tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      902/sshd
    tcp        0      0 127.0.0.1:631           0.0.0.0:*               LISTEN      675/cupsd
    tcp        0      0 127.0.0.1:25            0.0.0.0:*               LISTEN      1127/master
    tcp        0      0 0.0.0.0:445             0.0.0.0:*               LISTEN      1010/smbd
    tcp        0      0 127.0.0.1:16062         0.0.0.0:*               LISTEN      712/phtunnel
    tcp        0      0 127.0.0.1:11011         0.0.0.0:*               LISTEN      708/phddns_mini_htt
    tcp        0      0 0.0.0.0:139             0.0.0.0:*               LISTEN      1010/smbd
    tcp6       0      0 :::111                  :::*                    LISTEN      1/init
    tcp6       0      0 :::80                   :::*                    LISTEN      930/nginx: master p
    tcp6       0      0 :::22                   :::*                    LISTEN      902/sshd
    tcp6       0      0 :::8006                 :::*                    LISTEN      20049/pveproxy
    tcp6       0      0 ::1:631                 :::*                    LISTEN      675/cupsd
    tcp6       0      0 :::3128                 :::*                    LISTEN      1183/spiceproxy
    tcp6       0      0 ::1:25                  :::*                    LISTEN      1127/master
    tcp6       0      0 :::445                  :::*                    LISTEN      1010/smbd
    tcp6       0      0 :::139                  :::*                    LISTEN      1010/smbd
```
为什么 pveproxy 监听的是 IPV6 的地址呢？会不会和这个有关，好吧，经过一番搜索，找到了一个方法，就是创建 /etc/default/pveproxy 文件，然后写入
``` ini
    Bash:

    LISTEN_IP=0.0.0.0
```
再然后呢重启 pveproxy 服务，查看网络状态
``` bash
    # service pveproxy restart
    # netstat -ntlp
    Active Internet connections (only servers)
    Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
    tcp        0      0 0.0.0.0:111             0.0.0.0:*               LISTEN      1/init
    tcp        0      0 0.0.0.0:80              0.0.0.0:*               LISTEN      930/nginx: master p
    tcp        0      0 127.0.0.1:85            0.0.0.0:*               LISTEN      1166/pvedaemon
    tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      902/sshd
    tcp        0      0 127.0.0.1:631           0.0.0.0:*               LISTEN      675/cupsd
    tcp        0      0 127.0.0.1:25            0.0.0.0:*               LISTEN      1127/master
    tcp        0      0 0.0.0.0:445             0.0.0.0:*               LISTEN      1010/smbd
    tcp        0      0 127.0.0.1:16062         0.0.0.0:*               LISTEN      712/phtunnel
    tcp        0      0 127.0.0.1:11011         0.0.0.0:*               LISTEN      708/phddns_mini_htt
    tcp        0      0 0.0.0.0:8006            0.0.0.0:*               LISTEN      20049/pveproxy
    tcp        0      0 0.0.0.0:139             0.0.0.0:*               LISTEN      1010/smbd
    tcp6       0      0 :::111                  :::*                    LISTEN      1/init
    tcp6       0      0 :::80                   :::*                    LISTEN      930/nginx: master p
    tcp6       0      0 :::22                   :::*                    LISTEN      902/sshd
    tcp6       0      0 ::1:631                 :::*                    LISTEN      675/cupsd
    tcp6       0      0 :::3128                 :::*                    LISTEN      1183/spiceproxy
    tcp6       0      0 ::1:25                  :::*                    LISTEN      1127/master
    tcp6       0      0 :::445                  :::*                    LISTEN      1010/smbd
    tcp6       0      0 :::139                  :::*                    LISTEN      1010/smbd
```
好吧监听 IPV4 的本地地址了，但是仍然没有用，直到我发现了这篇文章 [https://forum.proxmox.com/threads/pveproxy-is-usually-error.46805/]
抱着试一试的态度，输入命令
``` bash
    # service pveproxy status
    pveproxy.service - PVE API Proxy Server
    Loaded: loaded (/lib/systemd/system/pveproxy.service; enabled; vendor preset: enabled)
    Active: active (running) since Thu 2021-07-01 12:04:17 CST; 7min ago
    Process: 20036 ExecStartPre=/usr/bin/pvecm updatecerts --silent (code=exited, status=0/SUCCESS)
    Process: 20045 ExecStart=/usr/bin/pveproxy start (code=exited, status=0/SUCCESS)
    Main PID: 20049 (pveproxy)
        Tasks: 4 (limit: 4915)
    Memory: 133.7M
    CGroup: /system.slice/pveproxy.service
            ├─20049 pveproxy
            ├─21522 pveproxy worker
            ├─21523 pveproxy worker
            └─21524 pveproxy worker

    Jul 01 12:11:34 pve pveproxy[20049]: starting 2 worker(s)
    Jul 01 12:11:34 pve pveproxy[20049]: worker 21522 started
    Jul 01 12:11:34 pve pveproxy[20049]: worker 21523 started
    Jul 01 12:11:34 pve pveproxy[21522]: /etc/pve/local/pve-ssl.pem: failed to use local certificate chain (cert_file or cer
    Jul 01 12:11:34 pve pveproxy[21523]: /etc/pve/local/pve-ssl.pem: failed to use local certificate chain (cert_file or cer
    Jul 01 12:11:34 pve pveproxy[21500]: worker exit
    Jul 01 12:11:34 pve pveproxy[20049]: worker 21500 finished
    Jul 01 12:11:34 pve pveproxy[20049]: starting 1 worker(s)
    Jul 01 12:11:34 pve pveproxy[20049]: worker 21524 started
    Jul 01 12:11:34 pve pveproxy[21524]: /etc/pve/local/pve-ssl.pem: failed to use local certificate chain (cert_file or cer
```
注意到了 failed to use local certificate chain 这个错误了吗？证书有问题，这个可是之前试过没有问题的啊，打开看看
``` bash
    # cat /etc/pve/local/pve-ssl.pem
```
这个文件怎么是空的，好吧貌似发现问题了，把证书重新复制到该文件中，然后重启 pveproxy
``` bash
    # service pveproxy restart
    # service pveproxy status
    pveproxy.service - PVE API Proxy Server
    Loaded: loaded (/lib/systemd/system/pveproxy.service; enabled; vendor preset: enabled)
    Active: active (running) since Thu 2021-07-01 12:13:23 CST; 2s ago
    Process: 21882 ExecStartPre=/usr/bin/pvecm updatecerts --silent (code=exited, status=0/SUCCESS)
    Process: 21893 ExecStart=/usr/bin/pveproxy start (code=exited, status=0/SUCCESS)
    Main PID: 21901 (pveproxy)
        Tasks: 4 (limit: 4915)
    Memory: 133.9M
    CGroup: /system.slice/pveproxy.service
            ├─21901 pveproxy
            ├─21902 pveproxy worker
            ├─21903 pveproxy worker
            └─21904 pveproxy worker

    Jul 01 12:13:20 pve systemd[1]: Starting PVE API Proxy Server...
    Jul 01 12:13:23 pve pveproxy[21893]: /etc/default/pveproxy: line 1: Bash:: command not found
    Jul 01 12:13:23 pve pveproxy[21901]: starting server
    Jul 01 12:13:23 pve pveproxy[21901]: starting 3 worker(s)
    Jul 01 12:13:23 pve pveproxy[21901]: worker 21902 started
    Jul 01 12:13:23 pve pveproxy[21901]: worker 21903 started
    Jul 01 12:13:23 pve pveproxy[21901]: worker 21904 started
    Jul 01 12:13:23 pve systemd[1]: Started PVE API Proxy Server.
```
现在证书好了，没有报错了，使用浏览器看看，PVE 管理页面正常展示出来了

## 其他一
netstat 和 ifconfig 命令都在 net-tools 包里面，如果需要，那么使用下列命令进行安装
``` bash
    # apt install net-tools
```

## 其他二
关于监听 IPv4 还是 IPv6 的问题，在问题解决后，尝试把 /etc/default/pveproxy 文件删除，然后重启服务。
使用浏览器打开 https://192.168.x.x:8006/ 能够正常工作，说明监听 IPv6 是兼容 IPv4 的。
