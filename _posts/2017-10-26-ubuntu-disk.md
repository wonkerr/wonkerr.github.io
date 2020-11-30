---
layout: post
title:  "磁盘阵列管理"
date:   2016-05-01
categories: NAS
tags: RAID
---

这里是摘要内容
<!-- more -->

* content
{:toc}

# 安装工具
* 安装磁盘阵列管理工具和 LVM 系统
> apt install mdadm lvm2

# 磁盘阵列管理功能


# 逻辑卷管理

## 物理卷
*   创建物理卷是将磁盘标记为卷组的物理设备，可以是分区、可以是整块硬盘
>   pvcreate /dev/md0 
>   pvcreate /dev/sdb
>   pvcreate /dev/hdb1

*   可以将设备增加到物理卷中，也可以将设备从物理卷中移除

## 卷组
*   创建卷组命令比较简单，指定卷组名称和物理卷就可以了，卷组是虚拟概念，可以将多个物理卷增加到卷组中
>   vgcreate vg0 /dev/md0 /dev/sde 

*   创建卷组后需要重启激活卷组，或者使用命令
>   vgchange -ay vg0

*   如果对卷组的名字不满意，可以修改
>   vgrename old-name new-name

*   可以增加或减少卷组中设备的数量
>   vgextend vg0 /dev/sdc1

*   卷组创建成功后，可以在 /dev 目录下看到卷组
>   /dev/vg0/

## 逻辑卷
*	逻辑卷就是虚拟的分区了，创建后就可以直接进行文件系统的格式化
>	lvcreate -L81500 -n share vg0
>	mkfs.ext4 /dev/vg0/share

*	需要注意的是逻辑卷的大小是以 PE 的多少指定的，可以查看卷组 PE 的多少
>	vgdisplay vg0 | grep "TotalPE"
>	TotalPE	81500
