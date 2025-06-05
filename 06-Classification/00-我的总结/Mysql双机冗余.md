<img src="./resource_images/kedacom_logo.png" alt="kedacom" style="zoom:100%;margin-right:auto; margin-left:0; display:block;" />

***
<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>

<h1 align = "center" > 显控双机冗余案例 </h1>
<center> (仅供内部使用) </center>

<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>

|                                    版  本  号： | V0.1                |
| ---------------------------------------------: | :------------------ |
| &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;保 密 等 级： | ■秘密  □机密  □绝密 |
|                                           编 制： | 李永军             |
|                                           审 核： | 李永军             |

<div STYLE="page-break-after: always;"></div>
<br>
<img src="./resource_images/kedacom_logo.png" alt="kedacom" style="zoom:100%;margin-right:auto; margin-left:0; display:block;" />

***
<h2 align = "left" > 修订记录 </h2>

| 日期       | 版本号 | 描述     | 作者   |
| ---------- | ------ | -------- | ------ |
| 2024-05-03 | 0.1    | 初稿完成 | 李永军 |
|            |        |          |        |
|            |        |          |        |
|            |        |          |        |
|            |        |          |        |
|            |        |          |        |
|            |        |          |        |
|            |        |          |        |
|            |        |          |        |
|            |        |          |        |
|            |        |          |        |
|            |        |          |        |



<div STYLE="page-break-after: always;"></div>
<br>
<img src="./resource_images/kedacom_logo.png" alt="kedacom" style="zoom:100%;margin-right:auto; margin-left:0; display:block;" />

***
<h2 align = "left" > 目录 </h2>
[TOC]



<div STYLE="page-break-after: always;"></div>
<br>
<img src="./resource_images/kedacom_logo.png" alt="kedacom" style="zoom:100%;margin-right:auto; margin-left:0; display:block;" />

***
## 前言

### 关键词
`MSP`、`显控`、`冗余`、`mysql`

### 摘要
>   ​    显控应用 web 化之后，不兼容之前的双机冗余方案。原显控机箱冗余方案**依赖客户端**实现，如果配置了机箱冗余，客户端登录时同时连接主备机箱，并将操作请求同时发给主备机箱，以实现主备机箱**数据实时同步**和**矩阵切换同步**。
>   ​    本文记录在原机箱冗余方案基础上，扩展开发显控 web 客户端支持机箱冗余设计方案。  





<div STYLE="page-break-after: always;"></div>
<br>
<img src="./resource_images/kedacom_logo.png" alt="kedacom" style="zoom:100%;margin-right:auto; margin-left:0; display:block;" />

***
## 案例描述










<div STYLE="page-break-after: always;"></div>
<br>
<img src="./resource_images/kedacom_logo.png" alt="kedacom" style="zoom:100%;margin-right:auto; margin-left:0; display:block;" />

***
## 案例分析

### 显控机箱冗余基本功能

- 支持**双机箱**板卡设备冗余热备
- 主备机箱主控板**数据实时同步**
- **音视频传输双链路冗余**，结合**双链路收发盒**支持一路信号传输链路异常时自动切换至备链路

### 原机箱冗余方案
#### 方案框图

#### 缺陷
- 1. Mysql数据自增ID分配机制，新增数据类接口主备机箱分配的ID可能不同（窗口ID、场景ID、矩阵预案ID、矩阵调度ID、用户ID ...）

- 2. 不支持配置类数据同步（创建大屏、修改信号源名称、KVM相关功能）

- 3. 存在用户登录抢占问题（一个账户登录主机箱，就不可以用相同的账户登录备机箱）

- 4. 配置冗余后，初次数据同步或某一机箱重启，主备数据同步机制有缺陷

- 5. 一个机箱挂了不能无缝切换到另一个（需要重新登陆）

- 6. 配置机箱冗余后不支持级联（级联不支持同时有多个上级）

- 7. 无法支持Https登录冗余机箱
   机箱冗余配置需支持添加对端机箱SSL证书
  
- 8. 主备机箱数据库密码必须相同

      机箱冗余配置需支持配置对端机箱数据库信息

- 9. 


### 新机箱冗余方案








<div STYLE="page-break-after: always;"></div>
<br>
<img src="./resource_images/kedacom_logo.png" alt="kedacom" style="zoom:100%;margin-right:auto; margin-left:0; display:block;" />

***
## 解决过程










<div STYLE="page-break-after: always;"></div>
<br>
<img src="./resource_images/kedacom_logo.png" alt="kedacom" style="zoom:100%;margin-right:auto; margin-left:0; display:block;" />

***
## 解决结果










<div STYLE="page-break-after: always;"></div>
<br>
<img src="./resource_images/kedacom_logo.png" alt="kedacom" style="zoom:100%;margin-right:auto; margin-left:0; display:block;" />

***
## 总结











<div STYLE="page-break-after: always;"></div>
<br>
<img src="./resource_images/kedacom_logo.png" alt="kedacom" style="zoom:100%;margin-right:auto; margin-left:0; display:block;" />

***
## 引用
