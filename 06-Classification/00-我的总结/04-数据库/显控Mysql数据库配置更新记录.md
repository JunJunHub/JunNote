---
datetime: 2025-06-05T17:22:00
aliases: 
tags:
  - MPU/MYSQL
  - DB/MYSQL
---
[TOC]
<div STYLE="page-break-after: always;"></div>

## 问题记录

1、显控最初版MPU板上的数据库账户密码是 `msp123` ，新版本已修改为 `msp@123.com` ，项目现场存在一些旧设备需要升级时，可能需要更新数据库密码

2、一些项目现场，如果设备长时间未使用，可能会出现数据库连接超时问题，并且业务程序不能重连（旧版本缺陷）。如果不升级需要修改数据库连接超时时间

3、某些场景会导致 `binlog` 日志增长速度过快而撑爆磁盘空间
例如：网络点位较多时，频繁的重新同步网络点位；长期执行大屏轮循；等频繁更新数据的操作

4、机箱冗余同步数据修改

5、主控冗余同步数据修改

6、冗余环境Mysql服务UUID相同，配置数据库冗余失败



## 更新数据库配置

### MySQL 5.7

#### 修改用户密码

```shell
#step-1 ssh登录主控后台 
 略

#step-2 使用root登录数据库
root@localhost:/msp/mpuaps# mysql -uroot -pmsp123
mysql: [Warning] Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 1124
Server version: 5.7.23-0ubuntu0.16.04.1-log (Ubuntu)

Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> 
#step-3 切换到mysql库
mysql> use mysql;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> 
mysql> 
#step-4 查看数据库账户信息(密码已加密显示)
mysql> select user,host,authentication_string from user;
+------------------+-------------+-------------------------------------------+
| user             | host        | authentication_string                     |
+------------------+-------------+-------------------------------------------+
| root             | localhost   | *DFC8616D829E6D6CFAFC9AF49F440227D0E9DD93 |
| mysql.session    | localhost   | *THISISNOTAVALIDPASSWORDTHATCANBEUSEDHERE |
| mysql.sys        | localhost   | *THISISNOTAVALIDPASSWORDTHATCANBEUSEDHERE |
| debian-sys-maint | localhost   | *0A83B372C86BDF1EB6C25A0E892C15E0B51B6503 |
| msp              | %           | *DFC8616D829E6D6CFAFC9AF49F440227D0E9DD93 |
| newtest          | 10.22.79.2  | *6BB4837EB74329105EE4568DDA7DC67ED2CA2AD9 |
| repluser         | 10.22.67.2  | *D98280F03D0F78162EBDBB9C883FC01395DEA2BF |
| repluser         |             | *D98280F03D0F78162EBDBB9C883FC01395DEA2BF |
| root             | %           | *DFC8616D829E6D6CFAFC9AF49F440227D0E9DD93 |
| repl             | %           | *299D46B967844696EE756DEAC2021947BFEBEB30 |
| canal            | %           | *E3619321C1A937C46A0D8BD1DAC39F93B27D4458 |
| REPL             | %           |                                           |
| msp              | *           | *DFC8616D829E6D6CFAFC9AF49F440227D0E9DD93 |
| root             | 10.67.76.16 | *DFC8616D829E6D6CFAFC9AF49F440227D0E9DD93 |
| root             | 127.0.0.1   | *DFC8616D829E6D6CFAFC9AF49F440227D0E9DD93 |
+------------------+-------------+-------------------------------------------+
15 rows in set (0.01 sec)

mysql> 
mysql> 
mysql> 
#step-5 更新账户密码(root和msp账户一般要改成相同的密码)
mysql> update user set authentication_string=password('msp@123.com') where user='msp';
Query OK, 0 rows affected, 1 warning (0.00 sec)
Rows matched: 2  Changed: 2  Warnings: 1
mysql> 
mysql> update user set authentication_string=password('msp@123.com') where user='root';
Query OK, 0 rows affected, 1 warning (0.00 sec)
Rows matched: 4  Changed: 4  Warnings: 1
mysql> 
mysql> 
mysql> 
#step-6 刷新数据库权限
mysql>  flush privileges;
Query OK, 0 rows affected (0.00 sec)
mysql> 
#step-7 退出mysql命令行模式
mysql> quit
Bye

#step-8 使用新密码登录验证是否修改成功: 
root@localhost:/msp/mpuaps# mysql -umsp -pmsp@123.com

#step-9 更新/mpu.cfg配置文件
root@localhost:/msp/mpuaps# vim /msp/cfg/mpu.cfg
{
        "ftpu":"msp",
        "ftpp":"msp123",
        "ftp_port":2210,
        "mysql_host":"127.0.0.1",
        "mysql_port":3316,
        "mysql_user":"msp",
        "mysql_pw":"msp123"   #填写新密码
}
```

#### 修改连接超时配置

此配置也可通过修改业务代码实现，在连接数据库时配置连接超时参数即可

```shell
msp@localhost:~$ 
# 切 root
msp@localhost:~$ sudo su -
root@localhost:~# 
root@localhost:~#
root@localhost:~#
root@localhost:~#
# 执行以下命令，修改数据库配置
root@localhost:~# cd /etc/mysql/mysql.conf.d/
root@localhost:~#
root@localhost:~#
# 确认下目录下没有 my.cfg 这个文件，如果有就不要继续操作了，反馈一下
root@localhost:/etc/mysql/mysql.conf.d# ls
master   mysqld.cnf  mysqld_safe_syslog.cnf
root@localhost:/etc/mysql/mysql.conf.d#
root@localhost:/etc/mysql/mysql.conf.d#
# 创建 my.cfg 文件
root@localhost:/etc/mysql/mysql.conf.d# echo "[mysqld]" > my.cnf
root@localhost:/etc/mysql/mysql.conf.d# echo "wait_timeout=604800" >> my.cnf
root@localhost:/etc/mysql/mysql.conf.d# echo "interactive_timeout=604800" >> my.cnf
# 确认下文件内容
root@localhost:/etc/mysql/mysql.conf.d# cat my.cnf 
[mysqld]
wait_timeout=604800
interactive_timeout=604800
root@localhost:/etc/mysql/mysql.conf.d# 
root@localhost:/etc/mysql/mysql.conf.d# 
root@localhost:/etc/mysql/mysql.conf.d# 
# 重启服务
root@localhost:/etc/mysql/mysql.conf.d# systemctl restart mysql
Warning: mysql.service changed on disk. Run 'systemctl daemon-reload' to reload units.
root@localhost:/etc/mysql/mysql.conf.d# 
root@localhost:/etc/mysql/mysql.conf.d# 
# 登录数据库,确认配置参数,截图看一下
root@localhost:/etc/mysql/mysql.conf.d# mysql -uroot -p
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 4
Server version: 5.7.23-0ubuntu0.16.04.1-log (Ubuntu)

Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> 
mysql> show variables like '%timeout%';
+-----------------------------+----------+
| Variable_name               | Value    |
+-----------------------------+----------+
| connect_timeout             | 10       |
| delayed_insert_timeout      | 300      |
| have_statement_timeout      | YES      |
| innodb_flush_log_at_timeout | 1        |
| innodb_lock_wait_timeout    | 50       |
| innodb_rollback_on_timeout  | OFF      |
| interactive_timeout         | 604800   |   # 这个值
| lock_wait_timeout           | 31536000 |
| net_read_timeout            | 30       |
| net_write_timeout           | 60       |
| rpl_stop_slave_timeout      | 31536000 |
| slave_net_timeout           | 60       |
| wait_timeout                | 604800   |    # 这个值
+-----------------------------+----------+
13 rows in set (0.01 sec)

mysql> 
mysql> quit
Bye
root@localhost:/etc/mysql/mysql.conf.d# 
root@localhost:/etc/mysql/mysql.conf.d# 
# 重启
root@localhost:/etc/mysql/mysql.conf.d# reboot 
```

#### 修改日志存储策略

`binlog` `relay` `undo`
```
sync_binlog = 1
expire_logs_days = 3          -- 保存最近3天的日志
max_binlog_size  = 100M       -- binlog 单文件100M

#[Limiting the disk space used by binary log files - Percona Server for MySQL](https://docs.percona.com/percona-server/8.0/binlog-space.html)
#以下两个参数Mysql5.7 不支持，Mysql8.0也不支持；Percona Server 衍生版支持
#max_binlog_files = 50      -- binlog 文件个数上限                  
#binlog_space_limit = 2G    -- binlog 占用空间上限

relay_log_recovery = 1
max_relay_log_size = 100M    -- relay 单文件100M
relay_log_space_limit = 2G   -- relay 日志最多写 2G
```


`Mysql5.7` 版本无法限制 `binlog` 日志占用磁盘大小，因此在业务代码中添加相关逻辑，定时检测数据库分区剩余空间大小，空间超过 90% 自动清除 `binlog`

```shell
# mysql-bin.index 记录了当前存在哪些binlog, 最后一个文件是正在写的 binlog
# 根据此文件记录删除历史 binlog. 正在写的 binlog 不要删除, 否则会引起数据库异常重启 
root@msp-Default-string:/msp/db/mysql# cat mysql-bin.index 
./mysql-bin.000470
./mysql-bin.000471
./mysql-bin.000472
./mysql-bin.000473
./mysql-bin.000474
./mysql-bin.000475
./mysql-bin.000476
./mysql-bin.000477
./mysql-bin.000478
./mysql-bin.000479
root@msp-Default-string:/msp/db/mysql# 
```





#### 机箱冗余配置更新

> 详情见<<机箱冗余设计文档>>

#### 主控冗余配置更新

> 详情见<<主控冗余设计文档>>



#### 冗余两个数据库UUID重复

```shell
#1、检查主备机箱数据库服务UUID，如若相同，删掉 auto.cnf 文件重启 Mysql 服务  
cat /msp/db/mysql/auto.cnf
[auto]
server-uuid=67263f7a-8d5b-11ec-91f0-0014101ccb5b
-- 主备server-uuid不能相同
```



### 国际化脱敏修改

#### 1、默认账户密码 root@dcc@123.com dcc@dcc@123.com

#### 2、root 远程访问

#### 3、数据路径 /dcc/db/mysql

#### 4、tfpt 路径

#### 5、ssh 访问

















## 数据库服务异常问题排查

1、查看数据库错误日志 /var/log/mysql/error.log，根据报错网上搜索解决方案

#### 例1：

#### 例2：
