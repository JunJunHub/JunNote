<img src="./kedacom_logo.png" alt="kedacom" style="zoom:100%;margin-right:auto; margin-left:0; display:block;" />
<br><br><br><br><br>
<h1 align = "center" > 基于Docker搭建Linux编译环境 </h1>

<center> (仅供内部使用) </center>
<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>

|                                   版  本  号：| V0.1                |
| --------------------------------------------: | :------------------ |
| &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;保 密 等 级：| ■秘密  □机密  □绝密 |
|                                          编 制： | 李永军              |
|                                          审 核： | 李永军              |

<br><br><br>
<div STYLE="page-break-after: always;"></div>
<img src="./kedacom_logo.png" alt="kedacom" style="zoom:100%;margin-right:auto; margin-left:0; display:block;" />
<br>
<h1 align = "left" > 修订记录 </h1>

| 日期           | 版本号  | 描述         | 作者       |
| -------------- | ------- | ------------ | ---------- |
| 2024-05-03     | 0.1     | 初稿完成     | 李永军     |
|                |         |              |            |
|                |         |              |            |
|                |         |              |            |
|                |         |              |            |
|                |         |              |            |
|                |         |              |            |
|                |         |              |            |
|                |         |              |            |
|                |         |              |            |
|                |         |              |            |
|                |         |              |            |



<div STYLE="page-break-after: always;"></div>
<img src="./kedacom_logo.png" alt="kedacom" style="zoom:100%;margin-right:auto; margin-left:0; display:block;" />
<br>
<h2 align = "left" > 目录 </h2>
[TOC]



<div STYLE="page-break-after: always;"></div>
<img src="./kedacom_logo.png" alt="kedacom" style="zoom:100%;margin-right:auto; margin-left:0; display:block;" />
<br>
#### 前言

##### 关键词
`Linux`、`交叉编译`、`Docker`

##### 摘要
    在一台编译机上，可以方便的编译不同 Linux 发行版本(不同 gcc 版本)的程序
在一台编译机上，可以使用各外厂商提供的编译工具链，编译生成目标平台可运行的二进制程序. 
我们使用到的交叉编译工具链一般由目标平台厂商提供(32位的工具链/64位的工具链).
例如： freescale-2010.09、arm-himix100-linux、arm-himix200-linux、arm-hisiv300-linux、arm-hisiv500-linux
要搭建的编译环境既能运行32位的工具链、也要能运行64位的工具链。

##### 交叉编译

可以理解为，在当前编译平台下，编译出来的程序能运行在体系结构不同的另一种目标平台上，但是编译平台本身却不能运行该程序.

比如，我们在 x86 平台上，编写程序并编译成能运行在 ARM 平台的程序，编译得到的程序在 x86 平台上是不能运行的，必须放到 ARM 平台上才能运行.



##### 交叉编译工具链

编译过程包括了预处理、编译、汇编、链接等.  编译过程是按照不同的子功能，依照先后顺序组成的一个复杂的流程.

**那每个子功能都是一个单独的工具(32位或64位二进制可执行文件)**来实现，它们合在一起形成了一个完整的工具集。

如下图：

![img](https://img-blog.csdn.net/20161024170548772)

**工具链包含的工具：**Binutils、GCC、GLibc、GDB      

https://blog.csdn.net/fangxiangeng/article/details/80604093    


##### 方案选择       

要使用这些工具链，我们的编译机要能同时运行x86、x86_64的程序. (一般选择安装ubuntu_x86_64、centos7_x86_84)

① 直接在64位编译机上安装32位运行环境(装一些32位的库，编译机环境会比较乱).

② 安装虚拟机

③ 使用docker, 安装32位编译环境与宿主机64位编译环境隔离. 同时可以安装部署多个Linux发行版.

























#### 编译环境使用流程概述

##### 1、win设置共享

?      共享自己的项目工程目录.  略.



##### 2、ssh远程登陆编译机

```shell
#ssh远程登录编译机, 密码admin123
ssh ubuntu@10.67.76.23 22

#切换root权限, 密码admin123
su
或
sudo su -
```



##### 3、挂载win目录到编译机

```shell
#创建自己的挂载路径
#统一在宿主机 /mnt 路径下创建自己的挂载路径, /mnt 路径会映射到容器内的 /home 路径 (提醒当前是在容器内还是在主机侧)

root@ubuntu-Vostro-3268:/mnt# mkdir -p /mnt/lyjwin/project
root@ubuntu-Vostro-3268:/mnt# 
root@ubuntu-Vostro-3268:/mnt#
root@ubuntu-Vostro-3268:/mnt# mount.cifs //10.67.76.16/project /mnt/lyjwin/project -o user=administrator,pass=1qaz@wsx    
root@ubuntu-Vostro-3268:/mnt# 
root@ubuntu-Vostro-3268:/mnt# 
root@ubuntu-Vostro-3268:/mnt# ls /mnt/lyjwin/project/MPC/mpc_vob/
10-common  20-alg  30-client  40-servers  50-media  70-protocol  target
root@ubuntu-Vostro-3268:/mnt# 
root@ubuntu-Vostro-3268:/mnt#

#问题:    在/mnt下新增一个挂载节点, 不同于直接在 /mnt 目录下新增文件, 新增挂载节点的文件不能共享到容器中.
#
#解答:    docker绑定数据卷默认模式是[private]. 使用挂载目录做容器的数据卷, 在宿主机上进行mount/umount操作不能同步到容器内
#        需要在容器进行绑定挂载前, 在宿主机的指定目录上, 先挂载远程目录.
#        容器启动时, -v 绑定数据卷设置模式位shared
#
#        docker run -itd --restart=always --net=host --privileged -v /opt:/opt -v /mnt:/home:shared --name centos7_74  centos7.4_64 /bin/sh
root@ubuntu-Vostro-3268:/mnt#  

```



##### 3、查看已安装镜像

```shell
##当前已安装ubuntu32、centos64、centos32的编译环境
##ubuntu64位的程序编译, 直接在宿主机中编译即可
##交叉编译配置
#交叉编译工具链统一安装到宿主机 /opt 路径下, 如果工具链是64位的, 可直接在宿主机使用. 如果是32位的, 要在32位的容器环境中使用.

root@ubuntu-Vostro-3268:/mnt# docker ps -a                      
CONTAINER ID   IMAGE            COMMAND     CREATED          STATUS          PORTS     NAMES
f8e46d4885b1   centos7.4_64     "/bin/sh"   38 minutes ago   Up 38 minutes             centos64
c151e9affec6   centos7.5_32     "/bin/sh"   39 minutes ago   Up 39 minutes             centos32
30b947c5cc59   ubuntu14.04_32   "/bin/sh"   39 minutes ago   Up 39 minutes             ubuntu32

##例如寒武纪交叉编译工具链为64位的(x86_64), 可直接在宿主机中使用该工具链.
root@ubuntu-Vostro-3268:/opt# ls /opt/cambricon/gcc-linaro-6.2.1-2016.11-x86_64_aarch64-linux-gnu
aarch64-linux-gnu  bin  gcc-linaro-6.2.1-2016.11-linux-manifest.txt  include  lib  libexec  share
root@ubuntu-Vostro-3268:/opt# 
root@ubuntu-Vostro-3268:/opt#       
root@ubuntu-Vostro-3268:/opt# file /opt/cambricon/gcc-linaro-6.2.1-2016.11-x86_64_aarch64-linux-gnu/bin/aarch64-linux-gnu-gcc
/opt/cambricon/gcc-linaro-6.2.1-2016.11-x86_64_aarch64-linux-gnu/bin/aarch64-linux-gnu-gcc: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, for GNU/Linux 2.6.24, BuildID[sha1]=dfec1a1c34b791582e69a236ebf2f7b95df3fea0, stripped
root@ubuntu-Vostro-3268:/opt# 
root@ubuntu-Vostro-3268:/opt# 
root@ubuntu-Vostro-3268:/opt# file /opt/cambricon/gcc-linaro-6.2.1-2016.11-x86_64_aarch64-linux-gnu/bin/aarch64-linux-gnu-g++
/opt/cambricon/gcc-linaro-6.2.1-2016.11-x86_64_aarch64-linux-gnu/bin/aarch64-linux-gnu-g++: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, for GNU/Linux 2.6.24, BuildID[sha1]=e024ca6a1219efd5fc49ca176fe5bba879fde918, stripped
root@ubuntu-Vostro-3268:/opt# 
root@ubuntu-Vostro-3268:/opt# 
root@ubuntu-Vostro-3268:/opt# 

```



##### 4、docker exec 进入容器内编译对应版本

```shell
###编译centos_64版本为例

##查看编译环境镜像
root@ubuntu-Vostro-3268:/mnt# docker ps -a                      
CONTAINER ID   IMAGE            COMMAND     CREATED          STATUS          PORTS     NAMES
f8e46d4885b1   centos7.4_64     "/bin/sh"   38 minutes ago   Up 38 minutes             centos64
c151e9affec6   centos7.5_32     "/bin/sh"   39 minutes ago   Up 39 minutes             centos32
30b947c5cc59   ubuntu14.04_32   "/bin/sh"   39 minutes ago   Up 39 minutes             ubuntu32
root@ubuntu-Vostro-3268:/mnt# 
root@ubuntu-Vostro-3268:/mnt# 
root@ubuntu-Vostro-3268:/mnt# 

##进入centos64容器内
#这里使用docker exec进入容器内
#不要使用docker attach, 防止误操作Ctrl+q停止容器(可能别人也在用)
root@ubuntu-Vostro-3268:/mnt# docker exec -it f8e46d4885b1 /bin/sh     
sh-4.2# 
sh-4.2# 

##cd进入到自己的工作目录
sh-4.2# cd /home/lyjwin/project/MPC/mpc_vob/
10-common/   20-alg/      30-client/   40-servers/  50-media/    70-protocol/ .svn/        target/      

sh-4.2# cd /home/lyjwin/project/MPC/mpc_vob/40-servers/pcsm
sh-4.2# 
sh-4.2# cd prj_linux/
sh-4.2# ls
compile_centos  compile_linux  compile_linux_centos_64  compile_linux_uos_64  makefile_centos_64_release_common  makefile_ubuntu_x86_debug  makefile_ubuntu_x86_release  makefile_uos_64_release_common  pcsmrest
sh-4.2# 
sh-4.2# 
sh-4.2# make -f makefile_centos_64_release_common 
install -D -m 644 pcsmrest ../../../10-common/version/release/linux64/pcsmrest
sh-4.2# 

##Ctrl+q 或 Ctrl+p+q退出容器
root@ubuntu-Vostro-3268:/mnt# 
root@ubuntu-Vostro-3268:/mnt# 
root@ubuntu-Vostro-3268:/mnt#
```





#### docker编译系统镜像安装流程

```shell
##以安装uos.tar镜像文件为例

root@ubuntu-Vostro-3268:/home/docker_images# ls
centos7.4-64.tar  centos7.5-32.tar  ubuntu14.04-32.tar  ubuntu16.04-64.tar  uos.tar
root@ubuntu-Vostro-3268:/home/docker_images#
root@ubuntu-Vostro-3268:/home/docker_images#
root@ubuntu-Vostro-3268:/home/docker_images#
root@ubuntu-Vostro-3268:/home/docker_images# docker load -i uos.tar 
4658d01a0836: Loading layer [==================================================>]  323.1MB/323.1MB
Loaded image: shmirror.cmo.kedacom.com/mss/dolphin/arm64/uos:local-uos-arm64
root@ubuntu-Vostro-3268:/home/docker_images#
root@ubuntu-Vostro-3268:/home/docker_images#
root@ubuntu-Vostro-3268:/home/docker_images#
root@ubuntu-Vostro-3268:/home/docker_images# docker images 
REPOSITORY                                       TAG               IMAGE ID       CREATED         SIZE
hello-world                                      latest            d1165f221234   6 weeks ago     13.3kB
ubuntu14.04_32                                   latest            90dc5b201a0d   2 months ago    708MB
shmirror.cmo.kedacom.com/all/ubuntu14.04-32-p    test              90dc5b201a0d   2 months ago    708MB
centos7.4_64                                     latest            3f1d4479ab01   9 months ago    748MB
shmirror.cmo.kedacom.com/all/centos7.4-64-p      test              3f1d4479ab01   9 months ago    748MB
ubuntu16.04_64                                   latest            4ee9f6168ff8   11 months ago   1.47GB
shmirror.cmo.kedacom.com/all/ubuntu16.04-64-p    test              4ee9f6168ff8   11 months ago   1.47GB
shmirror.cmo.kedacom.com/mss/dolphin/arm64/uos   local-uos-arm64   8d01a28fa6aa   12 months ago   315MB
centos7.5_32                                     latest            ec00d2b8d9c7   19 months ago   482MB
shmirror.cmo.kedacom.com/all/centos7.5-32-kdm    test              ec00d2b8d9c7   19 months ago   482MB
root@ubuntu-Vostro-3268:/home/docker_images# 
root@ubuntu-Vostro-3268:/home/docker_images# 
```

```shell
###
##shmirror.cmo.kedacom.com/mss/dolphin/arm64/uos 重命名为 uos_64
root@ubuntu-Vostro-3268:/home/docker_images# docker tag shmirror.cmo.kedacom.com/mss/dolphin/arm64/uos:local-uos-arm64 uos_64
root@ubuntu-Vostro-3268:/home/docker_images# 
root@ubuntu-Vostro-3268:/home/docker_images# 
root@ubuntu-Vostro-3268:/home/docker_images# 
root@ubuntu-Vostro-3268:/home/docker_images# 
root@ubuntu-Vostro-3268:/home/docker_images# docker images
REPOSITORY                                       TAG               IMAGE ID       CREATED         SIZE
hello-world                                      latest            d1165f221234   6 weeks ago     13.3kB
shmirror.cmo.kedacom.com/all/ubuntu14.04-32-p    test              90dc5b201a0d   2 months ago    708MB
ubuntu14.04_32                                   latest            90dc5b201a0d   2 months ago    708MB
centos7.4_64                                     latest            3f1d4479ab01   9 months ago    748MB
shmirror.cmo.kedacom.com/all/centos7.4-64-p      test              3f1d4479ab01   9 months ago    748MB
shmirror.cmo.kedacom.com/all/ubuntu16.04-64-p    test              4ee9f6168ff8   11 months ago   1.47GB
ubuntu16.04_64                                   latest            4ee9f6168ff8   11 months ago   1.47GB
uos_64                                           latest            8d01a28fa6aa   12 months ago   315MB
shmirror.cmo.kedacom.com/mss/dolphin/arm64/uos   local-uos-arm64   8d01a28fa6aa   12 months ago   315MB
centos7.5_32                                     latest            ec00d2b8d9c7   19 months ago   482MB
shmirror.cmo.kedacom.com/all/centos7.5-32-kdm    test              ec00d2b8d9c7   19 months ago   482MB
root@ubuntu-Vostro-3268:/home/docker_images# 

##启动uso_64容器
root@ubuntu-Vostro-3268:/home/docker_images#root@ubuntu-Vostro-3268:/home/docker_images# docker run -itd --net=host --privileged -v /opt:/opt -v /mnt:/home:shared --name uos64  uos_64 /bin/sh
005d755e7707189179f08b40bf0989bf92bf300d265891d6880ecdd673c2546f
root@ubuntu-Vostro-3268:/home/docker_images# 
root@ubuntu-Vostro-3268:/home/docker_images# 

```



#### docker系统镜像制作