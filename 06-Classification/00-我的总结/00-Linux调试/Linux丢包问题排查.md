---
datetime: 2025-06-05T17:16:00
aliases:
  - 显控服务器丢包问题排查记录
tags:
  - Linux
  - Net
  - MPU
  - Linux/tools/ethtool
---
## Linux丢包问题排查

**关键字**：/sys/class/net/em2/statistics/、/proc/net/dev、ethtool、ifconfig、netstat、iftop

### 1、确认硬件信息(网卡)

```shell
#查看对应网卡信息
root@msp-Default-string:~# ethtool enp6s0
Settings for enp6s0:
        Supported ports: [ TP ]
        Supported link modes:   10baseT/Half 10baseT/Full 
                                100baseT/Half 100baseT/Full 
                                1000baseT/Full 
        Supported pause frame use: Symmetric
        Supports auto-negotiation: Yes
        Advertised link modes:  10baseT/Half 10baseT/Full 
                                100baseT/Half 100baseT/Full 
                                1000baseT/Full 
        Advertised pause frame use: Symmetric
        Advertised auto-negotiation: Yes
        Speed: 1000Mb/s
        Duplex: Full
        Port: Twisted Pair
        PHYAD: 1
        Transceiver: internal
        Auto-negotiation: on
        MDI-X: on (auto)
        Supports Wake-on: pumbg
        Wake-on: g
        Current message level: 0x00000007 (7)
                               drv probe link
        Link detected: yes
root@msp-Default-string:~# 
root@msp-Default-string:~# 
root@msp-Default-string:~# 
root@msp-Default-string:~# ethtool  enp6s0 | egrep 'Speed|Duplex'   
        Speed: 1000Mb/s
        Duplex: Full
root@msp-Default-string:~# 
root@msp-Default-string:~# 
root@msp-Default-string:~# ethtool -S enp6s0 | grep crc
     rx_crc_errors: 0
root@msp-Default-string:~# 
root@msp-Default-string:~# 
############################################################
# Speed, Duplex, CRC 之类的都没问题，基本可以排除物理层面的干扰
############################################################
root@msp-Default-string:~# 
root@msp-Default-string:~# ethtool -S enp6s0
NIC statistics:
     rx_packets: 800275
     tx_packets: 466833
     rx_bytes: 180556453
     tx_bytes: 143594007
     rx_broadcast: 183556
     tx_broadcast: 2189
     rx_multicast: 1764
     tx_multicast: 63
     multicast: 1764
     collisions: 0
     rx_crc_errors: 0
     rx_no_buffer_count: 0
     rx_missed_errors: 0
     tx_aborted_errors: 0
     tx_carrier_errors: 0
     tx_window_errors: 0
     tx_abort_late_coll: 0
     tx_deferred_ok: 0
     tx_single_coll_ok: 0
     tx_multi_coll_ok: 0
     tx_timeout_count: 0
     rx_long_length_errors: 0
     rx_short_length_errors: 0
     rx_align_errors: 0
     tx_tcp_seg_good: 6397
     tx_tcp_seg_failed: 0
     rx_flow_control_xon: 46
     rx_flow_control_xoff: 46
     tx_flow_control_xon: 0
     tx_flow_control_xoff: 0
     rx_long_byte_count: 180556453
     tx_dma_out_of_sync: 0
     tx_smbus: 0
     rx_smbus: 0
     dropped_smbus: 0
     os2bmc_rx_by_bmc: 0
     os2bmc_tx_by_bmc: 0
     os2bmc_tx_by_host: 0
     os2bmc_rx_by_host: 0
     tx_hwtstamp_timeouts: 0
     rx_hwtstamp_cleared: 0
     rx_errors: 0
     tx_errors: 0
     tx_dropped: 0
     rx_length_errors: 0
     rx_over_errors: 0
     rx_frame_errors: 0
     rx_fifo_errors: 4300
     tx_fifo_errors: 0
     tx_heartbeat_errors: 0
     tx_queue_0_packets: 194901
     tx_queue_0_bytes: 69769159
     tx_queue_0_restart: 0
     tx_queue_1_packets: 271932
     tx_queue_1_bytes: 71828660
     tx_queue_1_restart: 0
     rx_queue_0_packets: 795975
     rx_queue_0_bytes: 175919597
     rx_queue_0_drops: 4300
     rx_queue_0_csum_err: 0
     rx_queue_0_alloc_failed: 0
     rx_queue_1_packets: 0
     rx_queue_1_bytes: 0
     rx_queue_1_drops: 0
     rx_queue_1_csum_err: 0
     rx_queue_1_alloc_failed: 0
```



### 2、确认丢包

通过 ifconfig 可以看到 dropped|overruns 字段是否在不停的增大，确认存在丢包现象。通常dropped 增大现象比较多，overruns 的情况较少。

```shell
root@msp-Default-string:~#
root@msp-Default-string:~# ethtool -S enp6s0 | grep drop      
     dropped_smbus: 0
     tx_dropped: 0
     rx_queue_0_drops: 5451
     rx_queue_1_drops: 0
root@msp-Default-string:~# 
root@msp-Default-string:~# 
root@msp-Default-string:~# for i in `seq 1 1000`; do ifconfig enp6s0 | grep RX | grep overruns; sleep 1; done
          RX packets:994704 errors:0 dropped:570 overruns:5451 frame:0
          RX packets:995667 errors:0 dropped:570 overruns:5451 frame:0
          RX packets:995733 errors:0 dropped:570 overruns:5451 frame:0
          RX packets:996043 errors:0 dropped:570 overruns:5451 frame:0
          RX packets:997148 errors:0 dropped:571 overruns:5451 frame:0
          RX packets:997211 errors:0 dropped:571 overruns:5451 frame:0
          RX packets:997597 errors:0 dropped:571 overruns:5571 frame:0
          RX packets:997919 errors:0 dropped:571 overruns:5571 frame:0
          RX packets:998882 errors:0 dropped:571 overruns:5571 frame:0
          RX packets:999203 errors:0 dropped:572 overruns:5571 frame:0
root@msp-Default-string:~# 
root@msp-Default-string:~# 
root@msp-Default-string:~# ifconfig enp6s0
enp6s0    Link encap:Ethernet  HWaddr 00:14:10:21:0c:44  
          inet addr:10.67.24.101  Bcast:10.67.31.255  Mask:255.255.240.0
          inet6 addr: fe80::214:10ff:fe21:c44/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:1067177 errors:0 dropped:603 overruns:7144 frame:0
          TX packets:625793 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:277417811 (277.4 MB)  TX bytes:173002462 (173.0 MB)
          Memory:df600000-df61ffff 
root@msp-Default-string:~# 
root@msp-Default-string:~# 
############################
# ifconfig 参数含义
############################
RX errors: 表示总的收包的错误数量，包括：
           1、too-long-frames 错误
           2、Ring Buffer 溢出错误
           3、crc 校验错误，帧同步错误
           4、fifo overruns
           5、missed pkg 等等。 
RX dropped: 表示数据包已经进入了 Ring Buffer，但是由于内存不够等系统原因，导致在拷贝到内存的过程中被丢弃。 

RX overruns: 表示了 fifo 的 overruns，这是由于 Ring Buffer(aka Driver Queue) 传输的 IO 大于 kernel 能够处理的 IO 导致的，而 Ring Buffer 则是指在发起 IRQ 请求之前的那块 buffer。很明显，overruns 的增大意味着数据包没到 Ring Buffer 就被网卡物理层给丢弃了，而 CPU 无法即使的处理中断是造成 Ring Buffer 满的原因之一，上面那台有问题的机器就是因为 interruprs 分布的不均匀(都压在 core0)，没有做 affinity 而造成的丢包。 

RX frame: 表示 misaligned 的 frames。

对于 TX 的来说，出现上述 counter 增大的原因主要包括 aborted transmission, errors due to carrirer, fifo error, heartbeat erros 以及 windown error，而 collisions 则表示由于 CSMA/CD 造成的传输中断。

在梳理这些 error/drop/discard 的时候，由于涉及到不同的 NIC 型号，ethtool/netstat 或者是直接从 proc 里面获取到的数据所代表的意思还不完全一样，比如上面通过 ethtool 得到的「丢包」是通过 rx_queue_NUM_drops 这个字段表示的，而通过 netstat 看到的却是 RX-OVR 表示的，一个是 overruns 一个是 dropped，字面意思完全不同:
root@msp-Default-string:~# netstat -i | column -t
Kernel  Interface  table
Iface   MTU        Met    RX-OK     RX-ERR  RX-DRP  RX-OVR  TX-OK     TX-ERR  TX-DRP  TX-OVR  Flg
enp2s0  1500       0      0         0       0       0       0         0       0       0       BMU
enp3s0  1500       0      0         0       0       0       0         0       0       0       BMU
enp4s0  1500       0      182586    0       0       0       102660    0       0       0       BMRU
enp5s0  1500       0      0         0       0       0       0         0       0       0       BMU
enp6s0  1500       0      1090148   0       616     7144    634362    0       0       0       BMRU
enp7s0  1500       0      0         0       0       0       0         0       0       0       BMU
enp9s0  1500       0      231335    0       0       0       129884    0       0       0       BMRU
lo      65536      0      13479800  0       0       0       13479800  0       0       0       LRU
root@msp-Default-string:~# 
root@msp-Default-string:~# 

#不管是使用何种工具，最终的数据无外乎是从下面这两个文件获取到的：/sys/class/net/em2/statistics/、/proc/net/dev
root@msp-Default-string:~# cat /proc/net/dev | column -t
Inter-|  Receive     |         Transmit
face     |bytes      packets   errs      drop  fifo  frame  compressed  multicast|bytes  packets     errs      drop  fifo  colls  carrier  compressed
enp4s0:  16637508    186607    0         0     0     0      0           4                10767293    104915    0     0     0      0        0           0
enp2s0:  0           0         0         0     0     0      0           0                0           0         0     0     0      0        0           0
enp9s0:  98251539    233738    0         0     0     0      0           3                10338773    131349    0     0     0      0        0           0
enp7s0:  0           0         0         0     0     0      0           0                0           0         0     0     0      0        0           0
enp6s0:  283475674   1115688   0         630   7144  0      0           2304             179414036   646488    0     0     0      0        0           0
enp3s0:  0           0         0         0     0     0      0           0                0           0         0     0     0      0        0           0
enp5s0:  0           0         0         0     0     0      0           0                0           0         0     0     0      0        0           0
lo:      2770443695  13733698  0         0     0     0      0           0                2770443695  13733698  0     0     0      0        0           0
root@msp-Default-string:~# 
```



### 3、分析端口流量

iftop工具使用：[Linux 网络流量监控利器 iftop 中文入门指南-CSDN博客](https://blog.csdn.net/qq_40907977/article/details/115066452)

```
iftop -i enp6s0 -nNB -m 1000M

L 显示进度条

T 显示总流量

3 根据平均值排序

t 发送盒接收合并

l 过滤IP

p 显示端口



2.交互操作
在 iftop 的实时监控界面中，可以对输出结果进行交互式操作，用于对输出信息进行整理和过滤，在上图所示界面中，按键 “h” 即可进入交互选项界面。iftop 的交互功能和 Linux 下的 top 命令非常类似，交互参数主要分为 4 个部分，分别是一般参数、主机显示参数、端口显示参数和输出排序参数。相关参数的含义如下所示：

参数      含义
P        通过此键可切换暂停/继续显示
h        通过此键可在交互参数界面/状态输出界面之间来回切换
b        通过此键可切换是否显示平均流量图形条
B        通过此键可切换显示2秒、10秒、40秒内的平均流量
T        通过此键可切换是否显示每个连接的总流量
j/k      按j键或k键可以向上或向下滚动屏幕显示当前的连接信息
l        通过此键可打开iftop输出过滤功能，比如输入要显示的IP，按回车后，屏幕就只显示与这个IP相关的流量信息
L        通过此键可切换显示流量刻度范围，刻度不同，流量图形条会跟着变化
q        通过此键可退出iftop流量监控界面
n        通过此键可使iftop输出结果以IP或主机名的方式显示
s        通过此键可切换是否显示源主机信息
d        通过此键可切换是否显示远端目标主机信息
t        通过此键可切换iftop显示格式，连续按此键可依次显示：以两行显示发送接收流量、以一行显示发送接收流量、只显示发送流量/接收流量
N        通过此键可切换显示端口号/端口号对应服务名称
S        通过此键可切换是否显示本地源主机的端口信息
D        通过此键可切换是否显示远端目标主机的端口信息
p        通过此键可切换是否显示端口信息
1/2/3    根据最近 2 秒、10 秒、40 秒的平均网络流量排序
<        通过此键可根据左边的本地主机名或IP地址进行排序
>        通过此键可根据远端目标主机的主机名或IP地址进行排序
o        通过此键可切换是否固定显示当前的连接
```

### 4、测试两个设备间的网络带宽

两个设备都支持SSH协议，可以借助scp命令，估算两个设备间的网络带宽。也可以通过其它方式测试。

```shell
#!/bin/bash

server_host="10.67.24.193"  # 目标服务器的 IP 地址 mspumt123
file_size_mb=2000           # 文件大小（MB）
file_name="test_file.txt"   # 文件名

# 在客户端生成测试文件
dd if=/dev/zero of="$file_name" bs=1M count="$file_size_mb"

# 使用scp将文件从客户端传输到服务器
start_time=$(date +%s)
scp "$file_name" "$server_host":~
end_time=$(date +%s)

# 计算传输时间
transfer_time=$((end_time - start_time))

# 计算带宽
bandwidth=$((file_size_mb / transfer_time))

# 显示结果
echo "传输时间: $transfer_time 秒"
echo "估算带宽: $bandwidth MB/s"

# 清理测试文件
rm "$file_name"
```



### 5、问题总结

根据以上情况大致可以推测出丢包原因，并根据端口流量情况找到对应业务程序，结合测试场景分析对应代码。

当网络包阻塞在接收端的缓冲区时，这通常是因为接收端的应用程序处理能力跟不上网络传输速度，或者是网络带宽突然暴增，导致接收端缓冲区无法及时处理所有到达的数据包。这种情况通常出现在以下几种情形下：
1、**接收端处理速度不足：**接收端的应用程序或服务处理数据包的速度较慢，无法及时处理接收到的大量数据包。这可能是因为接收端的硬件性能较低，或者应用程序本身存在性能问题。
2、**网络突发流量：**突然间网络传输的数据量大幅增加，例如在网络拥塞时，大量数据包涌入接收端，而接收端无法立即处理所有的数据包，导致缓冲区阻塞。
3、**网络传输速度不匹配：**如果发送端的网络传输速度高于接收端，接收端无法处理那么多的数据包，数据包就会积压在接收端的缓冲区中。
4、**应用层处理延迟：**接收端应用程序对于数据包的处理可能涉及复杂的逻辑，或者需要执行其他操作，导致处理时间较长，从而影响到后续数据包的处理。
5、**缓冲区大小不足：**接收端的缓冲区容量限制，不能容纳突然涌入的大量数据包，导致数据包被丢弃或积压常见的丢包原因：



本次排查丢包原因属于第四种：
umtio模块封装的Http接口接收数据效率低，向统一设备同步点位时每次查询10000条点位数据，数据包不能及时接收处理导致缓冲区溢出，表现为SSH登录和web登录总是断开连接。

```c++
bool CHttpProcess::POST_EX(u32 dwDestIP, u16 wPort, std::string strSendBuf, int nLenSend, s8* pRcvBody, u32& nLenRcv, s32& nError, bool bSynch /*= true*/, u32 dwTimeOut /*= 20000*/)
{
	if (0 == nLenSend)
	{
		return false;
	}

	u32 dwHandle = Connect(dwDestIP, wPort);
	if (!dwHandle)
	{
		nError = EMUMT_ERR_UNCONN;
		return false;
	}

#ifdef _LINUX_
	int nREUSEADDR = 1;
	::setsockopt(dwHandle, SOL_SOCKET, SO_REUSEADDR, (char*)&nREUSEADDR, sizeof(int));
#endif

	// HTTP请求
	timeval tWait = { 0, 300 };
	char szMsg[260] = { 0 };

	int nCurSend = 0;
	s8 achTime[128] = { 0 };
	while (nCurSend < nLenSend)
	{
		int nTmp = send(dwHandle, strSendBuf.data() + nCurSend, nLenSend - nCurSend, 0);
		if (nTmp <= 0)
		{
			Disconnect(dwHandle);
			return false;
		}
		nCurSend += nTmp;
	}

	if (nCurSend != nLenSend)
	{
		Disconnect(dwHandle);
		return false;
	}

	// 接收
	if (!bSynch)//非阻塞，不等待回传，立即返回
		return true;

	bool bFindLength = false;
	bool bFindEnd = false;
	u32 nRecved = 0, nRcvLen = 0xFFFFFFFF;
	u32 nRet = 0;
	std::string strTemp, strRcvTemp;
	u32 dwStartTime = GETTIME();
	fd_set fd;
	FD_ZERO(&fd);
	while (nRecved < nRcvLen)
	{
		FD_ZERO(&fd);
		if (!FD_ISSET(dwHandle, &fd))
		{
			FD_SET(dwHandle, &fd);
		}

		tWait.tv_sec = 0;
		tWait.tv_usec = 300;
		nRet = select(FD_SETSIZE, &fd, NULL, NULL, &tWait);
		if (nRet == 0)
		{
#ifdef WIN32

			LPVOID lpMsgBuf;
			FormatMessage(FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM | FORMAT_MESSAGE_IGNORE_INSERTS,
				NULL, WSAGetLastError(), MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),
				(LPTSTR)&lpMsgBuf, 0, NULL);
// 			UMTLog(EMUMT_LOG_ERR, "POST select error = %s(errno = %d)", lpMsgBuf, WSAGetLastError());
			LocalFree(lpMsgBuf);
			nError = WSAGetLastError();
#endif // WIN32
			if (GETTIME() - dwStartTime > dwTimeOut)
			{
				Disconnect(dwHandle);
				return false;
			}
			else
				continue;
		}
		else if (nRet == SOCKET_ERROR)
		{
#ifdef WIN32
			LPVOID lpMsgBuf;
			FormatMessage(FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM | FORMAT_MESSAGE_IGNORE_INSERTS,
				NULL, WSAGetLastError(), MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),
				(LPTSTR)&lpMsgBuf, 0, NULL);
// 			UMTLog(EMUMT_LOG_ERR, "POST select error = %s(errno = %d)", lpMsgBuf, WSAGetLastError());
			LocalFree(lpMsgBuf);
			if (WSAGetLastError() == WSAECONNRESET)
			{//对端断开，清除本地socket
				Disconnect(dwHandle);
				return false;
			}
#endif
			if (GETTIME() - dwStartTime > dwTimeOut)
			{
				Disconnect(dwHandle);
				return false;
			}
			else
				continue;
		}
		
		memset(m_pRecvBuf, 0, sizeof(UMT_MAX_MSG_LEN));
		nRet = recv(dwHandle, m_pRecvBuf, UMT_MAX_MSG_LEN, 0);
		if (nRet > 0)
		{
#ifdef WIN32
			LPVOID lpMsgBuf;
			FormatMessage(FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM | FORMAT_MESSAGE_IGNORE_INSERTS,
				NULL, WSAGetLastError(), MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),
				(LPTSTR)&lpMsgBuf, 0, NULL);
			LocalFree(lpMsgBuf);
			s32 nErr = WSAGetLastError();
			if (nErr == WSAEINTR || nErr == WSAEWOULDBLOCK)
			{
				if (GETTIME() - dwStartTime > dwTimeOut)
				{
					Disconnect(dwHandle);
					return false;
				}
				continue;
			}
#else
			if (errno == EINTR && errno == EWOULDBLOCK && errno == EAGAIN)
			{
				if (GETTIME() - dwStartTime > dwTimeOut)
				{
					Disconnect(dwHandle);
					return false;
				}
				continue;
			}
#endif
			if (nRecved + nRet > nLenRcv)
			{
				//接收缓存已满
				OspPrintf(TRUE, TRUE, "[line = %d] receive buffer = %u, receive string len = %u\n", nLenRcv, nRecved + nRet);
				break;
			}
			memcpy(pRcvBody + nRecved, m_pRecvBuf, nRet);
			nRecved += nRet;

			strRcvTemp.clear();
			strRcvTemp = pRcvBody;

			// HTTP应答收到后退出
			if (!bFindLength && nRecved != 0)
			{
				// 先找头的长度
				char * pBodyBegin = strstr((s8*)strRcvTemp.data(), "\r\n{");
				if (pBodyBegin != NULL)
				{
					s8* pFind = strstr((s8*)strRcvTemp.data(), "}\r\n0\r\n");//块编码时以\r\n0\r\n标识包结束

					if (pFind)
					{
						nRcvLen = nRecved;
						bFindEnd = true;
						break;
					}	
				}
				else //\r\n\r\n找不到关键字
				{
					Disconnect(dwHandle);
					return false;
				}
			}
		}
		else
		{
			if (nRecved != 0 && bFindEnd)
				break;
			else
			{//从来都没有收到过数据
				if (GETTIME() - dwStartTime > dwTimeOut)
				{
					break;
				}
			}
		}
	}
	nLenRcv = nRecved;
	Disconnect(dwHandle);
	return true;
}
```

