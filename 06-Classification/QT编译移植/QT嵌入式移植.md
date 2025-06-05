---
date: 2025-06-03
aliases:
  - Qt5.15 编译移植
tags:
  - QT
  - Buildroot
  - RK3588
  - drm
  - eglfs
---
B站教程文档链接 [[QT源码编译移植]]

**前言：**
> 本次实践是使用 VMware 安装 Ubuntu22.04 虚拟机作为交叉编译宿主机
> 目标机器为基于 RK3588 芯片的嵌入式 Linux 系统（基于 BusyBox 制作的 Linux 极简系统）
>
> 注意：
> 1、编译 Qt 依赖的组件比较多，虚拟机空间预留 100G
> 2、编译过程中需要下载很多源码包，确保良好的网络环境

# 准备工作

## 资源清单

- VMWare 安装包
- Ubuntu22.04 系统镜像 [ubuntu-releases/22.04](https://mirrors.tuna.tsinghua.edu.cn/ubuntu-releases/22.04/)
- RK3588 交叉编译工具链
- QT6.8.1 源码包 [qt-everywhere-src-6.8.1.tar.xz](https://mirrors.tuna.tsinghua.edu.cn/qt/archive/qt/6.8/6.8.1/single/)
- QT6.8.1 在线安装程序（Qt5.15之后不提供完整的离线安装包，只能在线安装）  
    需要先登录 Qt 账户选择需要安装的工具 [qt_online_installers](https://download.qt.io/official_releases/online_installers/)
- buildroot-2024.02.9.tar.gz [Buildroot Download](https://buildroot.org/download.html)
- RockChipSDK -- 公司用RK的芯片厂家提供支持(包含一个厂家定制的buildroot)

## 知识扫盲

标签：busybox、buildroot、poky、kernel、mesa、libmali、mali gpu、OpenGL、OpenGL ES、OpenCL、Vulkan API、DirectFB、ffmpeg、qt、qpa、eglfs、drm、framebuffer、wayland、qtwebengine、qt-webengine-ffmpeg、eudev、medv

> 复制关键词问 ChatGPT 了解相关知识

### linux-drm

[https://www.kernel.org/doc/html/v5.4/gpu/drm-kms.html#](https://www.kernel.org/doc/html/v5.4/gpu/drm-kms.html#)

高版本 Linux 内核不支持 frameBuffer

[Linux显示机制三](https://www.cnblogs.com/arnoldlu/p/17978715)

[Linux显示机制五](https://www.cnblogs.com/arnoldlu/p/17267914.html)

[Linux无窗口图形界面开发](https://blog.csdn.net/zyy29182918/article/details/144182093)

​![image](linux-drm.png "linux-drm")​

### eglfs

[QT eglfs 配置](https://www.cnblogs.com/Amumu1/p/18027474)  
[QT eglfs 使用](https://cloud.tencent.com/developer/article/1761840)

### mesa

[https://zhuanlan.zhihu.com/p/11872007450](https://zhuanlan.zhihu.com/p/11872007450)

[https://docs.mesa3d.org/egl.html](https://docs.mesa3d.org/egl.html)

[mesa opengl 加载显示驱动流程](https://blog.csdn.net/czg13548930186/article/details/131204470#:~:text=%E6%96%87%E7%AB%A0%E8%AF%A6%E7%BB%86%E4%BB%8B%E7%BB%8D%E4%BA%86Linux%E7%8E%AF%E5%A2%83%E4%B8%AD%EF%BC%8CMesa%E5%A6%82%E4%BD%95%E9%80%89%E6%8B%A9%E5%92%8C%E5%8A%A0%E8%BD%BD%E9%80%82%E5%90%88%E7%9A%84OpenGL%E9%A9%B1%E5%8A%A8%EF%BC%8C%E5%8C%85%E6%8B%AC%E7%A1%AC%E4%BB%B6%E9%A9%B1%E5%8A%A8%E5%92%8C%E8%BD%AF%E4%BB%B6%E9%A9%B1%E5%8A%A8%E5%A6%82swrast%E3%80%82%20Mesa%E9%80%9A%E8%BF%87libGL.so%E8%87%AA%E5%8A%A8%E9%80%89%E6%8B%A9%E9%80%82%E9%85%8DGPU%E7%9A%84%E9%A9%B1%E5%8A%A8%EF%BC%8C%E5%B9%B6%E5%8F%AF%E9%80%9A%E8%BF%87%E7%8E%AF%E5%A2%83%E5%8F%98%E9%87%8F%E5%BC%BA%E5%88%B6%E4%BD%BF%E7%94%A8%E8%BD%AF%E4%BB%B6%E9%A9%B1%E5%8A%A8%E3%80%82,GLX%E4%BD%9C%E4%B8%BAXWindowSystem%E5%92%8COpenGL%E7%9A%84%E6%8E%A5%E5%8F%A3%EF%BC%8C%E6%8F%90%E4%BE%9B%E9%97%B4%E6%8E%A5%E5%92%8C%E7%9B%B4%E6%8E%A5%E7%8A%B6%E6%80%81%E3%80%82%20%E6%AD%A4%E5%A4%96%EF%BC%8Cglxinfo%E5%B7%A5%E5%85%B7%E7%94%A8%E4%BA%8E%E6%9F%A5%E8%AF%A2%E9%A9%B1%E5%8A%A8%E8%AF%A6%E6%83%85%E5%92%8COpenGL%E7%89%B9%E6%80%A7%E3%80%82)

# 编译步骤

## 1、虚拟机环境配置

### 1.1 VMWare 软件安装（破解版）

> 略 ...

### 1.2 Ubuntu22.04 虚拟机安装

> 略 ...

### 1.3 替换国内 apt 源

> 清华大学 apt

### 1.4 安装必备工具

> gcc、g++、make、vim、tree、

## 2、QT 编译环境配置

### 2.1 交叉编译工具链安装

> 安装交叉编译工具至 /opt 目录下，并配置环境变量
> 
> - 企业级嵌入式设备开发使用的交叉编译工具一般由芯片厂商提供
> - 学习香橙派、数莓等开发板网上应该能直接下载到

### 2.2 宿主机安装 QT6.8

使用 Qt 在线安装程序安装，

> 虚拟机启动 QtCreate 报错，需要安装 mesa 驱动
> 
> sudo apt-get install libgl1-mesa-dev

安装 QT 打包工具

git clone https://github.com/probonopd/linuxdeployqt.git  
cd linuxdeployqt  
cmake .  
make

### 2.2 构建 sysroot

> 因为目标机器是个极简的嵌入式 Linux 系统，编译 Qt 依赖的很多组件都未提供，也不支持 apt yum 安装软件  
> 先使用 buildroot 编译制作根文件系统，并勾选要用到的软件包（不编译内核）。
> 
> buildroot 很强大，开发常用的很多开源组件都有，并提供 make menuconfig 图形化配置界面配置需要编译的组件
> 
> 可以直接编译 Qt5、Qt6（支持的模块要看 buildroot 版本说明? 如何自动以编译参数 -- TODO 确认）
> 
> TODO：Buildroot、Poky、Busybox、Linux 单独开篇学习介绍。
> 
> [Buildroot - org](https://buildroot.org/)
> 
> [Buildroot - Download Last Release](https://buildroot.org/download.html)
> 
> [Buildroot - Document](https://buildroot.org/docs.html)

#### 2.2.1 配置 buildroot

[Linux学习 - buildroot构建根文件系统 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/656731184)

[Linux kernel + busybox自制Linux系统_飞腾 busybox-CSDN博客](https://blog.csdn.net/itas109/article/details/107737843)

make menuconfig

- Target options [目标平台配置：交叉编译工具链、目标平台CPU架构]
    
- 内核配置
    
- 软件配置
    
- 文件系统
    

#### 2.2.2 问题记录

##### 1、Busybox 编译报错

```shell
#编译 Busybox network 工具时报错
In file included from networking/inetd.c:243:
networking/inetd.c: 在函数‘inetd_main’中:
include/libbb.h:2418:51: 错误： 无名数组的大小为负
 2418 | #define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
      |                                                   ^
networking/inetd.c:430:2: 附注： in expansion of macro ‘BUILD_BUG_ON’
  430 |  BUILD_BUG_ON(sizeof(G) > COMMON_BUFSIZE); \
      |  ^~~~~~~~~~~~
networking/inetd.c:1225:2: 附注： in expansion of macro ‘INIT_G’
 1225 |  INIT_G();
      |  ^~~~~~
scripts/Makefile.build:197: recipe for target 'networking/inetd.o' failed
make[3]: *** [networking/inetd.o] Error 1
Makefile:744: recipe for target 'networking' failed
make[2]: *** [networking] Error 2
make[2]: *** 正在等待未完成的任务....

#修改代码
```

##### 2、Qt 模块编译报错

```shell
#编译
```

##### 3、Buildroot 下载源码时校验 ca 证书报错

低版本 Ubuntu 系统环境 buildroot 下载源码时报错（系统版本低，安装的ca证书校验失败）

```shell
make WGET_OPTS="--no-check-certificate"
```

### 2.3 源码编译 QT6.8（自定义编译模块）

[Index of /qt/archive/qt/6.8/6.8.1/single/ | 清华大学开源软件镜像站](https://mirrors.tuna.tsinghua.edu.cn/qt/archive/qt/6.8/6.8.1/single/)

[Cross-Compile Qt 6 for Raspberry Pi - Qt Wiki](https://wiki.qt.io/Cross-Compile_Qt_6_for_Raspberry_Pi#Further_Readings)

[面向嵌入式 Linux 的 Qt](https://doc.qt.io/qt-5/embedded-linux.html)

[交叉编译Qt库(Qt6) — [野火]嵌入式Qt应用开发实战指南—基于LubanCat-RK开发板 文档](https://doc.embedfire.com/linux/rk356x/Qt/zh/latest/lubancat_qt/install/install_arm_3.html)

#### 2.3.1 替换 eglfs 插件代码

#### 2.3.2 配置编译参数

#### 2.3.3 问题记录

## 3、嵌入式 Linux 环境 Qt 程序运行测试

> 交叉编译调试工具：gdb、ldd、strace
> 
> strace 跟踪程序：
> 
> strace -e open,openat,dlopen,dlsym ./your_qt_application

# QT 开发

[Qt Quick 和 Widgets 的对比 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/656231132)

> 开发框架：
> 
> 1、QtQuick + qml https://lxblog.com/qianwen/share?shareId=0cf1dacc-b22c-41e8-8ccd-98f9c7d71172
> 
> 2、QWidget + qss
> 
> 3、QWebEngine + Vue.js

KVMGUI 开发框架采用 QtQuick 及 Qt 封装的系统级接口，暂不考虑用 OSP。例如 QThread ...  
日志组件 QDebug 或者 log4Qt https://github.com/MEONMedical/Log4Qt https://zhuanlan.zhihu.com/p/657361483  
数据库组件支持Sqllite，RK3588已编译支持对应模块  
Qt 支持 i18n 多语种翻译

HMI -- Human Machine Interface 人机界面，侧重如何让人与及其之间的沟通和操作变得更直观、高效、友好.  
UI -- User Interface 用户界面，聚焦在美学表现、用户视觉体验  
UE -- User Experience 用户体验设计，关注的是用户使用产品过程中的整体感受  
对于软件工程师而言，上面这些概念可以认为都是 UI、UE 设计，不必纠结区别。

Figma -- 知名的在线 UI 设计工具，貌似可以自动生成代码  
我们用慕客

1、QtQuick + qml 开发坐席 GUI 客户端大致流程 [qml c++ js]  
-- 需求分解，功能设计  
-- UI、UE 设计  
-- 分析 Figma HMI(GUI) 模块构成  
-- 工程目录结构设计  
-- HMI 切换  
-- HMI 实现  
1、分析 HMI 元素构成  
2、分析 HMI 布局  
3、自定义控件  
4、布局  
-- HMI 与 C++ 业务逻辑

汇总QT学习文档的开源项目  
https://github.com/mikeroyal/Qt-Guide

qml学习  
https://github.com/Furkanzmc/QML-Coding-Guide  
https://www.qt.io/product/qt6/qml-book  
https://github.com/qmlbook/qmlbook

Qt Quick Layouts 布局管理组件  
Qt Quick Controls 控件库官方文档  
https://doc.qt.io/qt-6/qtquickcontrols-index.html?spm=5176.28103460.0.0.86cc5d27eLGgbG

https://blog.csdn.net/qq_15409121/article/details/144314626

B站收费课程(没必要买)  
https://www.bilibili.com/video/BV1hk2mYkE7w/?spm_id_from=333.1391.0.0&vd_source=a5dad22e3c51af843449bc470f4caca5

GitHub 开源项目  
https://github.com/nuoqian-lgtm/QianWindow

# 参考

## 博客

[RK3588的QT交叉编译环境搭建_rk3588 qt-CSDN博客](https://blog.csdn.net/u011436603/article/details/143429082)

[Qt编写RK3588视频播放器/支持RKMPP硬解/支持各种视音频文件](https://www.qter.org/forum.php?mod=viewthread&tid=23582)

[Qt与Web混合开发(一) - lsgxeva - 博客园 (cnblogs.com)](https://www.cnblogs.com/lsgxeva/p/12418553.html)

[Cross-Compile Qt 6 for Raspberry Pi - Qt Wiki](https://wiki.qt.io/Cross-Compile_Qt_6_for_Raspberry_Pi#Further_Readings)

[Qt 6.2 长周期版正式发布_qt6长期支持版本有哪些-CSDN博客](https://blog.csdn.net/Qt_China/article/details/120683547)

## 热门社区 -- 没什么活跃的社区吗？

[Home | Qt Forum](https://forum.qt.io/) -- 国际论坛

[Qt开源社区 linux 嵌入式 教程!](https://www.qter.org/portal.php) -- 国内某大佬个人创建的论坛，有点东西。卖课。

[QTCN开发网](http://www.qtcn.org/bbs/index-htm-m-bbs.html) -- 都死了，没动静了

[Qt社区-CSDN社区云](https://bbs.csdn.net/forums/Qt) -- 啥玩意