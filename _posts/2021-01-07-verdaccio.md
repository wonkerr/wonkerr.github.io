---
categories  : 环境
excerpt     : 搭建 NPM 镜像
title       : 搭建 NPM 镜像
tags        : npm pm2 verdaccio
---

* content
{:toc}

# 安装 NPM
''' 
apt install npm
''' 

# 安装 verdaccio
''' 
npm install -g verdaccio
verdaccio
''' 

# 启动 verdaccio
''' 
verdaccio
''' 
输出内容如下：
> *** WARNING: Verdaccio doesn't need superuser privileges. Don't run it under root! ***
>  warn --- config file  - /root/.config/verdaccio/config.yaml
>  warn --- Verdaccio started
> (node:30211) Warning: N-API is an experimental feature and could change at any time.
>  warn --- Plugin successfully loaded: verdaccio-htpasswd
>  warn --- Plugin successfully loaded: verdaccio-audit
>  warn --- http address - http://localhost:4873/ - verdaccio/4.10.0

# 配置 verdaccio
根据提示打开 verdaccio/config.yaml 文件，在最后添加一行
''' 
listen: 0.0.0.0:4873
''' 
重启 verdaccio ，就可以通过网络访问了，在浏览器中输入 http://IP:4873/ 可以看到访问页面
根据页面提示使用 
> npm adduser --registry http://npm.server.net:4873/ 增加用户
增加用户成功后可以在页面上登录了

# 使用 PM2 管理 verdaccio
''' 
npm install -g pm2
pm2 start verdaccio
pm2 startup
''' 
1、安装 PM2 进程管理工具
2、通过 PM2 启动 verdaccio
3、设置 PM2 为开机自动启动

# 配置 NPM 源
''' 
npm config set registry http://npm.server.nas:4873/
''' 
直接设置 NPM 源为私服源，或者使用 NRM
''' 
npm install nrm -g
nrm add server http://npm.server.nas:4873/
nrm use server
nrm ls
''' 
1、安装 nrm 工具
2、增加 npm 源
3、使用私服源
4、查看源列表