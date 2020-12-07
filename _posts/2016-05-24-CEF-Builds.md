---
categories  : 编译
excerpt     : 本文介绍如何本地构建 CEF3
title       : 构建 CEF
tags        : CEF Build ninja chrome chromium VS2015
---

* content
{:toc}

## 写在前面
> 本次编译采用的是 2704 分支，也就是 Chorme 51 所使用的源代码  
> 该分支编译要求 Windows 7 + 操作系统，VS2015U2 编译环境， Win10.0.10580 SDK    
> 如果编译 32 和 64 为两套发行包，那么总共需要 100 GB 磁盘空间  

## 准备工作
* Visual Studio 2015 with Update 2 ( 需要安装在默认位置 )  
* Windows 10.0.10586 SDK  ( 需要安装在默认位置 ) 
* 需要使用 VPN 或者使用代理服务 ( 源代码在谷歌服务器上 ) 
* 需要将系统区域设置为`英语(美国)` ( 否则无法编译通过 )
* 需要安装 `Python` ( 最好使用 2.7.6 版 )

## 自动脚本
参考文档`版本分支与编译`中的自动化方法，下载 automate-git.py 文件，保存到本地构建目录中，例如 D:\Constructor\CEF\ 目录中  
然后编写下列的批处理脚本，名字保存为 automate-git.bat 批处理文件，该脚本可以在相关资源中找到下载地址  

    @ IF '$%CEF_BUILD_DIR%' NEQ '$' GOTO AUTOMATE

    @ SET CEF_BUILD_DIR=%~dp0
    @ SET GYP_MSVS_VERSION=2015
    @ SET GYP_GENERATORS=ninja,msvs-ninja
    @ SET CEF_DEPOT_DIR=%CEF_BUILD_DIR%\depot_tools
    @ SET PATH=%CEF_DEPOT_DIR%;%CEF_BUILD_DIR%\python276_bin;%PATH%

    :AUTOMATE
    @ echo 'CEF download and build directory is %CEF_BUILD_DIR%'
    @ python automate-git.py --download-dir=%CEF_BUILD_DIR% --branch=2704 %1 %2 %3 %4
    @ REM --no-update --no-distrib --x64-build

## 设置代理
* 如果有 VPN ，那么使用 VPN 是一个更好的办法，整个过程大约需要 12 GB 的流量，显然包月的方式更好  
* 修改系统 hosts 文件可以解决大部分代码下载的问题，但是有一些库必须通过 VPN 或者代理才能下载  
* 使用命令 git config --global http.proxy 127.0.0.1:8787 可以设置 git 的本地代理  

## 构建过程 
首先需要说明的是，构建分为几个部分，这些部分可以单独执行，例如`更新代码`、`编译代码`、`打包发布`  
使用 automate-git.bat --help 可以查看更多的控制参数，下面是部分参数及解释  
* --no-update 不更新代码，前提是你的代码已经全部下载好了  
* --no-build 不编译代码  
* --no-distrib 不创建发行包  
* --dry-run 输出命令，但并不实际执行这些命令  

--------------------------------------------------------------------------------  

如果环境准备好了，那么真正的构建过程很简单，执行命令 automate-git.bat 等待结束就可以了  
编译结束后，在 chromium/src/cef/binary_distrib 目录里面就可以看到三个 ZIP 包  
如果需要编译 64 位的，那么执行命令 automate-git.bat --x64-build 即可  
如果先编译了 32 位，那么需要删除 chromium/src/out 目录，否则报错  
如果代码已经下载好了，不需要更新那么可以附加上 --no-update 参数  

## 相关资源
* [Automate-git.bat](https://github.com/wonkerr/wonkerr.github.io/raw/master/static/res/automate-git.bat)
* [Automate-git.py](https://bitbucket.org/chromiumembedded/cef/raw/master/tools/automate/automate-git.py)
* [Python 2.7.6](https://storage.googleapis.com/chrome-infra/python276_bin.zip) 

## 参考文档
* [版本分支与编译](https://bitbucket.org/chromiumembedded/cef/wiki/BranchesAndBuilding)

