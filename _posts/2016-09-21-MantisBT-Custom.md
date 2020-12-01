---
categories  : 任务管理
excerpt     : 本文介绍如何在任务管理软件小螳螂中自定义角色
title       : 任务管理：自定义角色、
tags        : MantisBT Custom
---

* content
{:toc}

## 增加角色

### 增加定义
打开 core/constant_inc.php 文件 找到 access_level，进行修改，结果如下：

    # access levels
    define( 'ANYBODY', 0 );
    define( 'VIEWER', 10 );
    define( 'TESTER', 20 );
    define( 'REPORTER', 30 );
    define( 'MODELER', 40 );
    define( 'DEVELOPER' , 50 );
    define( 'DESIGNER', 60 );
    define( 'PROJECTOR', 70 );
    define( 'MANAGER', 80 );
    define( 'ADMINISTRATOR', 90 );
    define( 'NOBODY', 100 );

### 默认说明
打开 config_defaults_inc.php , 找到 $g_access_levels_enum_string，将其修改为配套的字符串定义 

    $g_access_levels_enum_string = '10:viewer,20:tester,30:reporter,40:modeler,50:developer,60:designer,70:projector,80:manager,90:administrator';

### 中文翻译
打开 lang/strings_chinese_simplified.txt 文件，找到 $s_access_levels_enum_string

    $s_access_levels_enum_string = '10:观察人员,20:测试人员,30:报告人员,40:建模人员,50:研发人员,60:设计人员,70:项目经理,80:资源经理,90:系统管理';

