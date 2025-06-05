---
Date: 2025-06-03T17:28:00
aliases:
  - Simple Network Management Protocol, SNMP；简单的网络管理协议
tags:
  - SNMP
  - Linux
---
[[Linux常用调试方法记录]]


多哥乌班图版本 MPU 安装 SNMP 服务安装对接运维
   1、网上下载 ubuntu iso 镜像文件
   
   2、挂载镜像，并修改 apt 配置使用本地源
      mount -t iso9660 -o loop ubuntu-16.04.7-server-amd64.iso /mnt/iso
      deb file:///mnt/ xenial main restricted
	  
   3、安装SNMP服务
      apt install snmp snmpd
      apt -y install
	  
   4、测试服务是否正常  https://www.cnblogs.com/ncayu2025/p/17646028.html 
      snmpwalk -v 2c -c public@123 127.0.0.1 -Os
   
   5、配置显控 SNMP 服务
      snmpget -v 2c -c public@123 127.0.0.1 .1.3.6.1.2.1.1.1.0  设备系统信息(设备描述)
   
      https://support.huawei.com/enterprise/zh/doc/EDOC1100075489/53a54b

   6、记录配置项
	   public@123  -- 可修改