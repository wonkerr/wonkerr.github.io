---
categories  : 开源代码
excerpt     : 本文介绍如何构建开源的 boost 运行时
title       : 构建 boost
tags        : boost build
---

* content
{:toc}

``` cmd
b2 --build-type=complete toolset=msvc-9.0 threading=multi runtime-link=shared address-model=64
```