---
categories	: 开源代码
excerpt		: 本文介绍如何构建开源的 OpenSSL 代码仓库
title		: 构建 OpenSSL
tags		: OpenSSL Build
---

需要准备 perl 环境，然后执行下列命令（分别是 64 位和 32 位 ）

``` cmd
    perl configure VC-WIN64A-masm shared threads sctp zlib enable-mdc2 enable-rc5
    perl configure VC-WIN32 shared threads sctp zlib enable-mdc2 enable-rc5 no-asm
```

需要注意下列文件内容
>	crypto\include\internal\dso_conf.h
>	crypto\include\internal\bn_conf.h * ( win32 win64 diff )
>	crypto\include\buildinf.h *
>	include\openssl\opensslconf.h *

