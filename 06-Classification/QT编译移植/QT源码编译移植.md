---
date: 2025-06-03
aliases: 
tags:
  - QT
---
实践总结文档 [[QT嵌入式移植]]
# 编译PC 端

1. sudo apt update 

2. sudo apt upgrade

    - wget https://mirrors.tuna.tsinghua.edu.cn/qt/archive/qt/5.15/5.15.9/single/qt-everywhere-opensource-src-5.15.9.tar.xz

    - tar -xf qt-everywhere-opensource-src-5.15.9.tar.xz

    - 注意增加swap容量

    - 注意不要增加不稳定源 sid 

3. 安装以下包：备注： libassimp-dev 谨慎安装

```sh

sudo apt install libnss3-dev libpng-dev libwebp-dev libfreetype-dev libjpeg-dev  bison flex pkg-config gperf nodejs autoconf npm python2.7 build-essential cmake libtool automake autoconf autoconf-archive  ccache ninja-build

```



```sh

 sudo apt install libxcb-xinerama0-dev \

    libx11-dev libxcb1-dev  \

    libxkbcommon-x11-dev libx11-xcb-dev libxext-dev  \

    libicu-dev libxslt1-dev ruby  \

    libssl-dev libxcursor-dev \

    libxcomposite-dev  \

    libxdamage-dev libxrandr-dev  \

    libfontconfig1-dev libcap-dev  \

    libxtst-dev libpulse-dev  \

    libudev-dev libpci-dev  \

    libnss3-dev libasound2-dev  ffmpeg libclang-dev \

    libgstreamer-plugins-bad1.0-dev llvm libfontconfig-dev  liblttng-ust-dev \

    libxss-dev libegl1-mesa-dev  libbluetooth-dev \

    libegl1-mesa-dev libgles2-mesa-dev  \

    libglu1-mesa-dev libglw1-mesa-dev    \

    libbz2-dev libgcrypt20-dev libdrm-dev  \

    libcups2-dev libatkmm-1.6-dev  \

    libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev  \

    libdbus-1-dev  \

    libgbm-dev  \

    x11proto-dev  \

    libatspi2.0-dev  \

    libsdl2-dev  libmtdev-dev  \

    libmd4c-dev  \

    libjpeg-dev libpng-dev  \

    libsctp-dev  \

    libproxy-dev   \

    libzstd-dev  \

    libminizip-dev  \

    libltdl-dev   \

    liblcms2-dev  \

    libevent-dev  \

    libwebp-dev   \

    libopus-dev   \

    libopusfile-dev \

    libre2-dev  \

    libsnappy-dev  \

    libinput-dev   \

    zlib1g-dev \

    libgtkmm-3.0-dev libgtkd-3-dev  \

    libspeechd-dev libvpx-dev   \

    mesa-common-dev libosmesa6-dev libgbm-dev  \

    libavcodec-dev libavutil-dev     \

    libavformat-dev   \

    libopenal-dev  \

    libdbus-c++-dev  libdbus-glib-1-dev  \

    libmng-dev  \

    libxcb-xinput-dev   \

    libglobus-gssapi-gsi-dev \

    libglobus-gssapi-error-dev \

    libglobus-gss-assist-dev \

    libharfbuzz-dev \

    libdbuskit-dev \

    flite1-dev \

    libpq-dev \

    libsqlite3-dev \

    libxcb-dri2-0-dev -y

```



```sh

sudo apt-get install libboost-all-dev libudev-dev libinput-dev libts-dev libmtdev-dev libjpeg-dev libfontconfig1-dev libssl-dev libdbus-1-dev libglib2.0-dev libxkbcommon-dev libegl1-mesa-dev libgbm-dev libgles2-mesa-dev mesa-common-dev libasound2-dev libpulse-dev gstreamer1.0-omx libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev  gstreamer1.0-alsa libvpx-dev libsrtp2-dev libsnappy-dev libnss3-dev "^libxcb.*" flex bison libxslt-dev ruby gperf libbz2-dev libcups2-dev libatkmm-1.6-dev libxi6 libxcomposite1 libfreetype6-dev libicu-dev libsqlite3-dev libxslt1-dev 

```



```sh

sudo apt install libxkbfile-dev libmariadbd-dev libmariadb-dev libmariadb-dev-compat libmariadb-dev unixodbc-dev

```



```sh

sudo apt-get install libavcodec-dev libavformat-dev libswscale-dev libx11-dev freetds-dev libsqlite3-dev libpq-dev libiodbc2-dev firebird-dev libgst-dev libxext-dev libxcb1 libxcb1-dev libx11-xcb1 libx11-xcb-dev libxcb-keysyms1 libxcb-keysyms1-dev libxcb-image0 libxcb-image0-dev libxcb-shm0 libxcb-shm0-dev libxcb-icccm4 libxcb-icccm4-dev libxcb-sync1 libxcb-sync-dev libxcb-render-util0 libxcb-render-util0-dev libxcb-xfixes0-dev libxrender-dev libxcb-shape0-dev libxcb-randr0-dev libxcb-glx0-dev libxi-dev libdrm-dev libxcb-xinerama0 libxcb-xinerama0-dev libatspi2.0-dev libxcursor-dev libxcomposite-dev libxdamage-dev libxss-dev libxtst-dev libpci-dev libcap-dev libxrandr-dev libdirectfb-dev libaudio-dev libxkbcommon-x11-dev

```



```sh

sudo apt-get install make build-essential libclang-dev ninja-build gcc git bison python3 gperf pkg-config libfontconfig1-dev libfreetype6-dev libx11-dev libx11-xcb-dev libxext-dev libxfixes-dev libxi-dev libxrender-dev libxcb1-dev libxcb-glx0-dev libxcb-keysyms1-dev libxcb-image0-dev libxcb-shm0-dev libxcb-icccm4-dev libxcb-sync-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-randr0-dev libxcb-render-util0-dev libxcb-util-dev libxcb-xinerama0-dev libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev libatspi2.0-dev libgl1-mesa-dev libglu1-mesa-dev freeglut3-dev

```

    - # 卸载掉libassimp-dev libassimp5



4. touch butilqt-pc.sh

5. chmod u+x butilqt-pc.sh

6. 在buildqt-pc.sh中写入以下内容：

```sh

#!/bin/bash



rm config.cache

rm config.log

mkdir build-pc

cd build-pc



../configure -prefix /home/ubuntu/qt-pc \

-opensource \

-release \

-confirm-license \

-shared \

-nomake examples  \

-nomake test  \

-qt-doubleconversion  \

-qt-pcre \

-qt-zlib  \

-qt-freetype \

-qt-harfbuzz  \

-qt-libpng \

-qt-libjpeg \

-qt-sqlite \

-qt-assimp \

-qt-tiff \

-qt-webp  \

-qt-webengine-icu  \

-qt-webengine-ffmpeg  \

-qt-webengine-opus \

-qt-webengine-webp \

-xcb \

-opengl \

-webengine-jumbo-build 0 \

-webengine-proprietary-codecs \

--feature-pdf-v8 \

-syslog -trace lttng \

-recheck-all



```

7. NINJAJOBS=-j4 gmake -j7





# 编译arm端

1. sudo apt update 

2. sudo apt upgrade

3. 安装以下包：

    ```sh

    (在PC上)

    sudo apt install gcc-aarch64-linux-gnu g++-aarch64-linux-gnu 

    ```



    ```sh

    #(在开发板上)

    sudo apt install libxcb-xinerama0-dev \

        libx11-dev libxcb1-dev  \

        libxkbcommon-x11-dev libx11-xcb-dev libxext-dev  \

        libicu-dev libxslt1-dev ruby  \

        libssl-dev libxcursor-dev \

        libxcomposite-dev  \

        libxdamage-dev libxrandr-dev  \

        libfontconfig1-dev libcap-dev  \

        libxtst-dev libpulse-dev  \

        libudev-dev libpci-dev  \

        libnss3-dev libasound2-dev ffmpeg libclang-dev \

        libgstreamer-plugins-bad1.0-dev llvm libfontconfig-dev fontconfig liblttng-ust-dev \

        libxss-dev libegl1-mesa-dev libbluetooth-dev  \

        libegl1-mesa-dev libgles2-mesa-dev  \

        libglu1-mesa-dev libglw1-mesa-dev    \

        libbz2-dev libgcrypt20-dev libdrm-dev  \

        libcups2-dev libatkmm-1.6-dev  \

        libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev  \

        libdbus-1-dev  \

        libgbm-dev  \

        x11proto-dev  \

        libatspi2.0-dev  \

        libsdl2-dev  libmtdev-dev  \

        libmd4c-dev  \

        libjpeg-dev libpng-dev  \

        libsctp-dev  \

        libproxy-dev   \

        libzstd-dev  \

        libminizip-dev  \

        libltdl-dev   \

        liblcms2-dev  \

        libevent-dev  \

        libwebp-dev   \

        libopus-dev   \

        libopusfile-dev \

        libre2-dev  \

        libsnappy-dev  \

        libinput-dev   \

        zlib1g-dev \

        libgtkmm-3.0-dev libgtkd-3-dev  \

        libspeechd-dev libvpx-dev   \

        mesa-common-dev libosmesa6-dev libgbm-dev  \

        libavcodec-dev libavutil-dev     \

        libavformat-dev   \

        libopenal-dev  \

        libdbus-c++-dev  libdbus-glib-1-dev  \

        libmng-dev  \

        libxcb-xinput-dev   \

        libglobus-gssapi-gsi-dev \

        libglobus-gssapi-error-dev \

        libglobus-gss-assist-dev \

        libharfbuzz-dev \

        libdbuskit-dev \

        flite1-dev \

        libpq-dev \

        libsqlite3-dev \

        libxcb-dri2-0-dev -y

    ```



    ```sh

    sudo apt-get install libboost-all-dev libudev-dev libinput-dev libts-dev libmtdev-dev libjpeg-dev libfontconfig1-dev libssl-dev libdbus-1-dev libglib2.0-dev libxkbcommon-dev libegl1-mesa-dev libgbm-dev libgles2-mesa-dev mesa-common-dev libasound2-dev libpulse-dev gstreamer1.0-omx libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev  gstreamer1.0-alsa libvpx-dev libsrtp2-dev libsnappy-dev libnss3-dev "^libxcb.*" flex bison libxslt-dev ruby gperf libbz2-dev libcups2-dev libatkmm-1.6-dev libxi6 libxcomposite1 libfreetype6-dev libicu-dev libsqlite3-dev libxslt1-dev 

    ```



    ```sh

    sudo apt install libxkbfile-dev libmariadbd-dev libmariadb-dev libmariadb-dev-compat libmariadb-dev unixodbc-dev

    ```



    ```sh

    sudo apt-get install libavcodec-dev libavformat-dev libswscale-dev libx11-dev freetds-dev libsqlite3-dev libpq-dev libiodbc2-dev firebird-dev libgst-dev libxext-dev libxcb1 libxcb1-dev libx11-xcb1 libx11-xcb-dev libxcb-keysyms1 libxcb-keysyms1-dev libxcb-image0 libxcb-image0-dev libxcb-shm0 libxcb-shm0-dev libxcb-icccm4 libxcb-icccm4-dev libxcb-sync1 libxcb-sync-dev libxcb-render-util0 libxcb-render-util0-dev libxcb-xfixes0-dev libxrender-dev libxcb-shape0-dev libxcb-randr0-dev libxcb-glx0-dev libxi-dev libdrm-dev libxcb-xinerama0 libxcb-xinerama0-dev libatspi2.0-dev libxcursor-dev libxcomposite-dev libxdamage-dev libxss-dev libxtst-dev libpci-dev libcap-dev libxrandr-dev libdirectfb-dev libaudio-dev libxkbcommon-x11-dev

    ```



    ```sh

    sudo apt-get install make build-essential libclang-dev ninja-build gcc git bison python3 gperf pkg-config libfontconfig1-dev libfreetype6-dev libx11-dev libx11-xcb-dev libxext-dev libxfixes-dev libxi-dev libxrender-dev libxcb1-dev libxcb-glx0-dev libxcb-keysyms1-dev libxcb-image0-dev libxcb-shm0-dev libxcb-icccm4-dev libxcb-sync-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-randr0-dev libxcb-render-util0-dev libxcb-util-dev libxcb-xinerama0-dev libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev libatspi2.0-dev libgl1-mesa-dev libglu1-mesa-dev freeglut3-dev

    ```





    - 安装完制作sysroot(复制方式)

        - 复制开发板的/usr/lib /usr/include /usr/share/pkgconfig /lib(这个目录其实是/usr/lib的软链接) 到PC机上，把这个目录当作sysroot，也就是后面所指的/opt/sysroot-arm64

        - 在cp时加上-P参数（保留软连接），在tar打包解包时带上-p

    - 安装完制作sysroot(网络同步方式)

        - mkdir -p   /opt/sysroot-arm64/usr/

        - mkdir -p   /opt/sysroot-arm64/usr/share

        - rsync -avzS --rsync-path="rsync" --delete ubuntu@192.168.240.44:/usr/include /opt/sysroot-arm64/usr/

        - rsync -avzS --rsync-path="rsync" --delete ubuntu@192.168.240.44:/usr/lib /opt/sysroot-arm64/usr/

        - rsync -avzS --rsync-path="rsync" --delete ubuntu@192.168.240.44:/usr/share/pkgconfig /opt/sysroot-arm64/usr/share

    - 运行 sudo ./link.py /opt/sysroot-arm64

    - link.py 内容：

        ```sh

        #!/usr/bin/env python3

        import sys

        import os

         

        # Take a sysroot directory and turn all the abolute symlinks and turn them into

        # relative ones such that the sysroot is usable within another system.

         

        if len(sys.argv) != 2:

            print("Usage is " + sys.argv[0] + "<directory>")

            sys.exit(1)

         

        topdir = sys.argv[1]

        topdir = os.path.abspath(topdir)

         

        def handlelink(filep, subdir):

            link = os.readlink(filep)

            if link[0] != "/":

                return

            if link.startswith(topdir):

                return

            #print("Replacing %s with %s for %s" % (link, topdir+link, filep))

            print("Replacing %s with %s for %s" % (link, os.path.relpath(topdir+link, subdir), filep))

            os.unlink(filep)

            os.symlink(os.path.relpath(topdir+link, subdir), filep)

         

        for subdir, dirs, files in os.walk(topdir):

            for f in files:

                filep = os.path.join(subdir, f)

                if os.path.islink(filep):

                    #print("Considering %s" % filep)

                    handlelink(filep, subdir)

        ```

    - 不要用自己配置的交叉编译工具链，不然qtwebengine编译不了

4. touch butilqt-arm64.sh

5. chmod u+x butilqt-arm64.sh

6. 在buildqt-arm64.sh中写入以下内容：

    ```sh

    #!/bin/bash



    rm config.cache

    rm config.log

    sysroot=/opt/sysroot-arm64

    machineTuple=aarch64-linux-gnu

    export PKG_CONFIG_SYSROOT_DIR=$sysroot

    export PKG_CONFIG_LIBDIR=$sysroot/usr/lib/$machineTuple/pkgconfig:$sysroot/usr/lib/pkgconfig:$sysroot/usr/share/pkgconfig

    mkdir build-arm64

    cd build-arm64



    ../configure -prefix qt-arm64 \

    -opensource \

    -release \

    -confirm-license \

    -shared \

    -xplatform linux-aarch64-gnu-g++ \

    -nomake examples  \

    -qt-doubleconversion  \

    -qt-pcre \

    -qt-zlib  \

    -qt-freetype \

    -qt-harfbuzz  \

    -qt-libpng \

    -qt-libjpeg \

    -qt-sqlite \

    -qt-assimp \

    -qt-tiff \

    -qt-webp  \

    -qt-webengine-icu  \

    -qt-webengine-ffmpeg  \

    -qt-webengine-opus \

    -qt-webengine-webp \

    -xcb \

    -egl \

    -eglfs \

    -opengl es2 \

    -webengine-jumbo-build 0 \

    -webengine-proprietary-codecs \

    --feature-pdf-v8 \

    -sysroot $sysroot \

    -syslog \

    -recheck-all



    ```

7. 将对应平台的qmake.config重写(./qtbase/mkspecs/linux-aarch64-gnu-g++/qmake.conf)

    ```sh

    #

    # qmake configuration for building with aarch64-linux-gnu-g++

    #



    MAKEFILE_GENERATOR      = UNIX

    CONFIG                 += incremental

    QMAKE_INCREMENTAL_STYLE = sublib



    #QMAKE_INCDIR_POST += \

    #    $$[QT_SYSROOT]/usr/include \

    #    $$[QT_SYSROOT]/usr/include/aarch64-linux-gnu



    #QMAKE_LIBDIR_POST += \

    #    $$[QT_SYSROOT]/usr/lib \

    #    $$[QT_SYSROOT]/usr/lib/aarch64-linux-gnu



    #QMAKE_RPATHLINKDIR_POST += \

    #    $$[QT_SYSROOT]/usr/lib \

    #    $$[QT_SYSROOT]/usr/lib/aarch64-linux-gnu



    QMAKE_INCDIR_OPENGL_ES2 += \

        $$[QT_SYSROOT]/usr/include \

        $$[QT_SYSROOT]/usr/include/aarch64-linux-gnu



    QMAKE_LIBDIR_OPENGL_ES2 += \

        $$[QT_SYSROOT]/usr/lib \

        $$[QT_SYSROOT]/usr/lib/aarch64-linux-gnu

        

    QMAKE_INCDIR_EGL        += \

        $$[QT_SYSROOT]/usr/include \

        $$[QT_SYSROOT]/usr/include/aarch64-linux-gnu



    QMAKE_LIBDIR_EGL        += \

        $$[QT_SYSROOT]/usr/lib \

        $$[QT_SYSROOT]/usr/lib/aarch64-linux-gnu

        

    QMAKE_LIBS_EGL         += -lEGL -lGLESv2

    QMAKE_LIBS_OPENGL[_ES2] += -lEGL -lGLESv2





    include(../common/linux.conf)

    include(../common/gcc-base-unix.conf)

    include(../common/g++-unix.conf)



    # modifications to g++.conf

    QMAKE_CC                = aarch64-linux-gnu-gcc

    QMAKE_CXX               = aarch64-linux-gnu-g++

    QMAKE_LINK              = aarch64-linux-gnu-g++

    QMAKE_LINK_SHLIB        = aarch64-linux-gnu-g++



    # modifications to linux.conf

    QMAKE_AR                = aarch64-linux-gnu-ar cqs

    QMAKE_OBJCOPY           = aarch64-linux-gnu-objcopy

    QMAKE_NM                = aarch64-linux-gnu-nm -P

    QMAKE_STRIP             = aarch64-linux-gnu-strip

    load(qt_config)

    ```

    - 在另一个进程下编译 screen -S makeqt

8. NINJAJOBS=-j4 gmake -j7





# arm 编译后在qtcreator配置

- 在make install 后，打包并解压到其他位置时会出现 `qt没有被正确安装 请运行make install`

- 在解压位置/bin/qtpaths qtpaths --install-prefix <修改后的路径>



## 一些参考网站

===================================

vim ../qtwebengine/src/3rdparty/chromium/third_party/pdfium/core/fxcodec/png/png_decoder.cpp +61





https://bugreports.qt.io/browse/QTBUG-117950

https://codereview.qt-project.org/c/qt/qtbase/+/510764

first_dts:



https://bugreports.qt.io/browse/QTBUG-116553?jql=text%20~%20%22has%20no%20member%20named%20%E2%80%98first_dts%E2%80%99%22



https://bugs.chromium.org/p/chromium/issues/attachmentText?aid=546472



https://codereview.qt-project.org/

https://chromium-review.googlesource.com/



链接时出错可以看看linux-g++.pri

Note: Also available for Linux: linux-clang linux-icc





linux-clang



Note: journald, syslog or slog2 integration is enabled.

If your users intend to develop applications against this build,

ensure that the IDEs they use either set QT_FORCE_STDERR_LOGGING to 1

or are able to read the logged output from journald, syslog or slog2.



=======================================





# 同步PC开发的软件到开发板

```sh

rsync -avzS --rsync-path="rsync" ubuntu@192.168.240.70:/home/ubuntu/data/qt/build-webengine_demo-arm64-Release/webengine_demo . 

- rsync -avzS --rsync-path="rsync" ubuntu@192.168.240.70:/usr/local/sysroot-orangepi/usr/lib/aarch64-linux-gnu/libGLESv2.so .

- rsync -avzS --rsync-path="rsync" ubuntu@192.168.240.70:/usr/local/sysroot-orangepi/usr/lib/aarch64-linux-gnu/libGLESv2.so.2 .

- rsync -avzS --rsync-path="rsync" ubuntu@192.168.240.70:/usr/local/sysroot-orangepi/usr/lib/aarch64-linux-gnu/libGLESv2.so.2.1.0 .

```



## 在开发板设置环境变量

```sh

#!/bin/sh



export QTDIR=/home/orangepi/qt-arm-v8-5.15.5

export LD_LIBRARY_PATH=$QTDIR/lib

export QT_QPA_PLATFORM_PLUGIN_PATH=$QTDIR/plugins

export QT_QPA_PLATFORM=linuxfb:tty=/dev/fb0

export QT_QPA_FONTDIR=$QTDIR/lib/fonts

export QML2_IMPORT_PATH=$QTDIR/qml

#export QT_QPA_PLATFORM=eglfs

#export QT_EGLFS_IMX6_NO_FB_MULTI_BUFFER=2

#export QT_QPA_EGLFS_PHYSICAL_WIDTH=698             #根据你的显示器设置宽度，单位mm

#export QT_QPA_EGLFS_PHYSICAL_HEIGHT=392           #根据你的显示器设置高度，单位mm

QTWEBENGINEPROCESS_PATH=$QTDIR/libexec

QTWEBENGINE_RESOURCES_PATH=$QTDIR/resources

QTWEBENGINE_LOCALES_PATH=$QTDIR/translations/qtwebengine_locales

```



## qt.conf

```sh

[Paths]

Entry = .

Prefix = .

Documentation = doc

Headers = include

Libraries = lib

LibraryExecutables = libexec

Binaries = bin

Plugins = plugins

QmlImports = qml

ArchData = .

Data = .

Translations = translations

Examples = examples

Tests = tests

Settings = .

```





environment variable