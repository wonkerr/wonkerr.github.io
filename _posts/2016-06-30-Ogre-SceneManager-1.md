---
categories  : 渲染引擎
excerpt     : 从 Ogre 一代升级到 Ogre 二代额外需要注意的东西
title       : Ogre 2.0 SceneNode 管理说明
tags        : Ogre SceneNode SceneManager
---

* content
{:toc}

### SceneNode 属性
    在 Ogre 1.x 中，SceneNode 有一个 Ogre::String 类型的 Name 属性，这个属性必须全局唯一，因为要作为 map 的 key ，如果重复就会报错
    在 Ogre 2.x 中，SceneNode 的 Name 属性仍然保留，但是已经是一个普通属性了，名字可以随便的修改。
    同时增加了一个 Ogre::uint32 的 Id 属性，该属性在创建 SceneNode 时自动生成一个，外部可以只读访问
    该 Id 属性仅仅用来进行唯一标识一个 SceneNode ，似乎没有更多的其他用途
    如果是大型游戏可以将该属性的类型修改为 Ogre::uint64，（修改后发现无法编译通过，只好又修改了其他相关的地方）

### ScneeNode 管理
    在 Ogre 2.0 中，SceneNode 不再是存储在 map 中，而是存储在数组中，在 SceneNode 中有 size_t mGlobalIndex，该属性用来表明此 SceneNode 在全局数组中的位置，可以用来快速定位，例如当删除一个 SceneNode 时，可以快速在数组中找到位置，然后将数组中其他地方的 SceneNode 替换当前位置
