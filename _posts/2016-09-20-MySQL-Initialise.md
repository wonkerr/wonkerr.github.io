---
categories  : 数据库
excerpt     : 
title       : MySQL 初始化
tags        : Database MySQL
---

在 Windows 上部署 MySQL 其实比较简单的，只要注意配置文件并执行几个命令即可，具体如下
<!--- more --->

* content
{:toc}

## 配置文件
my.ini 文件只需要配置程序和数据的目录就可以了
``` ini
    [mysqld]
    basedir = W:\Services\MySQL
    datadir = W:\Database
```
## 初始化库
将 share 目录下的 mysql_system_tables.sql 文件开始增加一行
``` sql
    use mysql;
```
然后执行命令
``` bat
    mysqld --console --initialise < ../share/mysql_system_tables.sql
```
等待数据库初始化成功，注意系统会提示你 root 的密码，这是一个随机生成的密码，非常难输入，一定复制下来

## 启动服务
``` cmd
    mysqld --console
```

## 修改密码
如果需要修改 root 账号的密码，使用如下命令
```batch
    mysql -u root -p
```
然后按照提示输入 root 的密码，就是之前复制下来的那个密码，进入 mysql 命令行界面后，输入如下指令
``` batch
    set password for root@localhost = password('MyNewPswd');
```

## 帮助信息
如果追求尽善尽美的化，那么在上述命令行界面上，可以将执行 share 目录下的 fill_help_tables.sql 脚本
