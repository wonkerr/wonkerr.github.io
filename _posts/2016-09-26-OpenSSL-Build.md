---
layout: post
title:  "构建 OpenSSL"
date:   2016-09-26
categories: MantisBT
tags: MantisBT Custom
---



    perl configure VC-WIN64A-masm shared threads sctp zlib enable-mdc2 enable-rc5

    perl configure VC-WIN32 shared threads sctp zlib enable-mdc2 enable-rc5 no-asm

	crypto\include\internal\dso_conf.h
	crypto\include\internal\bn_conf.h * ( win32 win64 diff )
	crypto\include\buildinf.h *
	include\openssl\opensslconf.h *
