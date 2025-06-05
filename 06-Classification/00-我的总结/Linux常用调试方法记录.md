---
datetime: 
aliases:
  - Linux 调试手段
tags:
  - Linux
  - GDB
---

[TOC]

# Ⅰ Linux常用调试手段(C/C++)

## 1、GDB 调试

> GDB 是 GNU 开源组织发布的一个强大的 UNIX 下的程序调试工具，可以查看程序的内部结构、打印变量值、设置断点以及单步调试源代码。

> 一般来说，GDB 主要帮忙你完成下面四个方面的功能：
> 1、启动你的程序，可以按照你的自定义的要求随心所欲的运行程序。
> 2、可让被调试的程序在你所调置的断点处停住。**（断点可以是条件表达式）**
> 3、当程序被停住时，可以检查此时你的程序中所发生的事。
> 4、动态的改变你程序的执行环境。

> **GDB 加载程序三种方式：**
> a、`gdb procexe` 直接加载可执行程序
> b、先启动 `gdb`，然后 `file procexe` 加载程序。如果执行程序需要命令行参数：set args <参数列表>
> c、`gdb -p procPid` 加载已启动的程序

> **注意：** 程序编译时添加 -g 参数，编译调试版本

### 1.1、常用的 GDB 调试命令
- (gdb) run  执行程序
- (gdb) Ctrl+C 暂停
- (gdb) continue  继续执行
- (gdb) quit  退出
- 
- (gdb) info threads 查看线程信息
- (gdb) thread [id] 切换至线程
- (gdb) bt 显示线程堆栈信息
- (gdb) f 3 察看所有的调用栈，调用框层次
- (gdb) i locals  显示所有当前调用栈的所有变量
- (gdb) backtrace  显示程序中的当前位置和表示如何到达当前位置的栈跟踪（同义词：where）
- (gdb) display  程序停止时显示变量和表达时
- (gdb) undisplay  display 命令的反命令，不要显示表达式
- (gdb) info  显示与该程序有关的各种信息
- 
- (gdb) breakpoint  在程序中设置一个断点。break <function>;  break <linenum>;  break <filename:linenum>;  break <filename:function>;  break <* address>;  **break …if<condition>**;  break(没有参数表示在下一行代码处停住);  info break 显示设置的所有断点信息。
-  
- (gdb) delete   删除一个断点或监测点；也可与其他命令一起使用
- (gdb) clear  删除刚才停止处的断点
- (gdb) watch 在程序中设置一个监测点（即数据断点）
- (gdb) commands  命中断点时，列出将要执行的命令
- 
- (gdb) down  下移栈帧，使得另一个函数成为当前函数
- (gdb) up 上移栈帧，使另一函数成为当前函数
- (gdb) next  执行下一个源程序行，从而执行其整体中的一个函数
- (gdb) step  执行下一个源程序行，必要时进入下一个函数
- (gdb) frame  选择下一条 continue 命令的帧
- (gdb) until  结束当前循环
- (gdb) jump  在源程序中的另一点开始运行
- (gdb) print  显示变量或表达式的值，可以结合 (gdb) i locals 使用
- (gdb) list  列出相应于正在执行的程序的原文件内容
- (gdb) pype  显示一个数据结构（如一个结构或 C++类）的内容
- (gdb) whatis 显示变量或函数类型
- 
- (gdb) set  variable  给变量赋值
-
- (gdb) reverse-search  在源文件中反向搜索正规表达式
- (gdb) search  在源文件中搜索正规表达式
- 
- (gdb) cd  改变当前工作目录
- (gdb) pwd  显示当前工作目录
-
- (gdb) kill  异终止在 gdb  控制下运行的程序
- (gdb) signal  将一个信号发送到正在运行的进程

### 1.2、高级的 GDB 调试方式
#### 1.2.1、执行Python脚本
##### 栈溢出问题排查
```shell
dddd
```

#### 1.2.1、启动时指定参数

### 1.2、GDB 调试基本步骤

#### 1.2.1、GDB 下运行可执行程序

1、加载程序
三种方法：
a、gdb procexe 
b、先启动gdb，然后file procexe加载程序。如果执行程序需要命令行参数：set args <参数列表>
c、gdb -p 'pid'

2、break/b - 设置断点
例如：break <function>;  break <linenum>;  break <filename:linenum>;  break <filename:function>;  break <* address>;  break …if<condition>;  break(没有参数表示在下一行代码处停住);  info break 显示设置的所有断点信息。

2、run/r  -  开始运行加载的程序

3、list/l  -  查看源代码
需要注意的是，GDB之所以可以查看到源代码，是因为它知道源代码放在哪里。调试版的可执行程序记录了源代码的路径信息。在一个调试会话中，GDB维护了一个源代码查找目录列表，默认值是编译目录和当前工作目录。当GDB需要一个源文件的时候，它依次在这些目录中查找，直到找到一个或者抛出错误。

如果移动了源文件的位置，则需要把源文件的路径添加到GDB的搜索路径中。添加路径有两种方法：
方法1、directory 命令，但需要主要，directory添加的搜索路径不是递归的，即GDB只搜索添加的目录下源文件，不会搜素该目录下的其他目录里的源文件。所以添加路径的时候，要将所有路径全部添加，中间用空格隔开。
方法2、gdb filename –d srcfilepath

4、print <var>   - 查看变量值，只能打印当前函数内的变量。或者用info <locals>显示局部变量值。

5、backtrace/bt - 程序停止时，查看程序在哪里停住，并显示函数调用关系。

当程序调用一个函数时，函数的地址、函数参数、以及函数的内部局部变量都会被压入栈（stack）中。使用bt查看栈信息。

6、frame <num>。当我们要查看某一栈层的信息时，使用frame切换当前栈。一般来说，程序停止时，所在的函数就是当前栈，也是最顶层的栈。如frame 0表示当前栈为栈顶，frame 1是下移层函数栈，该函数调用0层函数。
另外，up <n> 表示向上移动n层； down <n>表示向下移动n层。不带n参数的话，表示移动1层。
![img](file:///C:/Users/李永军/AppData/Local/Temp/msohtmlclip1/01/clip_image017.png)

调用wib函数的上一次是main函数，查看main函数的局部变量值
![img](file:///C:/Users/李永军/AppData/Local/Temp/msohtmlclip1/01/clip_image018.png)
我们发现在i = 2及循环第3次是出现错误。

使用命令run 重新运行程序，直到中断为止。
![img](file:///C:/Users/李永军/AppData/Local/Temp/msohtmlclip1/01/clip_image021.jpg)

可以用print 或者info locals 查看变量。
也可以用 break 17 if value == div。当value与div相等时，程序停止在17行。
注意break num if expr 这里的expr中的变量必须在num行中，否则没有意义。
![img](file:///C:/Users/李永军/AppData/Local/Temp/msohtmlclip1/01/clip_image023.jpg)

8、continue/c。执行到下一个断点处。
单步调试next/n； step/s(运行到函数，进入函数内部)。
![img](file:///C:/Users/李永军/AppData/Local/Temp/msohtmlclip1/01/clip_image024.png)

9、delete <breaknum> 删除断点， breaknum为断点号。
![img](file:///C:/Users/李永军/AppData/Local/Temp/msohtmlclip1/01/clip_image026.jpg)

10、watch <expr>。设置观察点。观察表达式或变量expr的值是否变化，当其变化时，程序停止。

另外还有两种观察点：rwatch <expr> 当表达式或变量被读时，停止程序；awatch <expr>当表达式（变量）的值被读或者写时，程序停止。

需要注意的是，设置观察点，需要expr中的变量在作用域时设置，即当程序执行到表达式中变量所在的作用域时，再设置观察点。为此，我们可以先在变量作用域设置断点，然后运行程序，但程序在断点处停止时，再设置观察点。继续运行程序continue，当表达式值变化时将停止。

![img](file:///C:/Users/李永军/AppData/Local/Temp/msohtmlclip1/01/clip_image027.png)
表达式的值从0（假）变成1（真）。
Info watch 查看观察点 相当于Info break

#### 1.2.2、GDB 调试 coredump 文件

有些情况下，程序发生崩溃时，无法直接使用GDB运行程序进行调试。比如程序可能在另一台机器上运行，或者程序对时间比较敏感，手动跟踪调试会造成无法接收的延迟等。此时，只能等到程序运行结束后来判断崩溃原因。Linus 的 core dump 机制可以在程序崩溃时产生 core 文件。我们可以使用 GDB 对 core 文件进行分析，找出崩溃原因。

##### !!! coredump 生成配置
**这里有几点需要注意的：**
1、GDB 分析 core 文件，程序必须在编译时加 -g 选项产生调试符号表。
2、确认系统是否允许产生 core 文件。一般情况下，Linux 系统默认禁止生成 core 文件。
（1）使用 **ulimit –c** 查看 core 文件生成开关。若结果为 0，则表示系统不允许生成 core 文件。
（2）使用 **ulimit –c filesize** 开启 core 文件生成并限制文件大小为 filesize。可使用 **ulimit –c unlimited** 使生成的 core 文件大小不受限制。
3、core文件生成路径：输入可执行文件运行命令的同一路径下。
若系统生成的 core 文件不带其它任何扩展名称，则全部命名为 core。新的 core 文件生成将覆盖原来的 core 文件。
（1）**/proc/sys/kernel/core_uses_pid** 可以控制 core 文件的文件名中是否添加 pid 作为扩展。文件内容为 1，表示添加 pid 作为扩展名，生成的 core 文件格式为 core.xxxx；为 0 则表示生成的core 文件同一命名为 core。
可通过以下命令修改此文件：
echo "1" > /proc/sys/kernel/core_uses_pid

（2）proc/sys/kernel/core_pattern 可以控制 core 文件保存位置和文件名格式。
 可通过以下命令修改此文件：
echo "/corefile/core-%e-%p-%t"  > core_pattern，可以将 core 文件统一生成到 /corefile 目录下，产生的文件名为"core-%e[命令名]-%p[PID]-%t[时间戳]"
 以下是参数列表:
 %p - insert pid into filename 添加 pid
 %u - insert current uid into filename 添加当前 uid
 %g - insert current gid into filename 添加当前 gid
 %s - insert signal that caused the coredump into the filename 添加导致产生 core 的信号
 %t - insert UNIX time that the coredump occurred into filename 添加 core 文件生成时的 unix 时间
 %h - insert hostname where the coredump happened into filename 添加主机名
 %e - insert coredumping executable name into filename 添加命令名

##### 1.2.2.1、core 文件调试示例

测试程序：bugging.c
```c
#include "stdio.h"

static char buf[256];
static char* string;
int main()
{
  char byVar = 0;
  printf("please input a string: ");
  gets(string);
  printf("\n your string is: %s\n", string);

  while(1)
  {
    printf("exit(Y/N):");
    byVar = getchar();
    if(byVar == 'y')break;
  }
  return 1;
}
```

1、查看系统是否运行生成 core 文件，如果为 0，则开启 core 文件生成。
![img](file:///C:/Users/李永军/AppData/Local/Temp/msohtmlclip1/01/clip_image028.png)

2、编译 bugging.c：gcc –g bugging.c –o bugging； 并运行 bugging，程序会报段错误，此时错误信息将被记录在 core 文件中。
![img](file:///C:/Users/李永军/AppData/Local/Temp/msohtmlclip1/01/clip_image029.png)

3、ls core.* ：显示core文件
![img](file:///C:/Users/李永军/AppData/Local/Temp/msohtmlclip1/01/clip_image030.png)

4、gdb program core.XXX ：调试 core 文件。program 是程序名，core.xxx 是生成的 core 文件名。
![img](file:///C:/Users/李永军/AppData/Local/Temp/msohtmlclip1/01/clip_image032.jpg)

5、bt：查看段错误发生的函数调用信息。
![img](file:///C:/Users/李永军/AppData/Local/Temp/msohtmlclip1/01/clip_image033.png)

可以看出程序在 gets(string) 出发生段错误，查看发现 string 为空，造成的段错误。
![img](file:///C:/Users/李永军/AppData/Local/Temp/msohtmlclip1/01/clip_image034.png)


##### 1.2.2.2、调试开发板上的 core 文件

如果开发板的操作系统也是 linux，core 调试方法依然适用。如果开发板上不支持 gdb，可将开发板的程序运行环境（依赖库）、可执行文件和 core 文件拷贝到 PC 的 linux 下。
在 PC 上调试开发板上产生的 core 文件，**需要使用交叉编译器自带的 gdb**，并且需要在 gdb 中指定 **solib-absolute-prefix** 和 **solib-search-path** 两个变量以保证 gdb 能够找到可执行程序的依赖库路径。有一种建立配置文件的方法，不需要每次启动 gdb 都配置以上变量，即：在待运行gdb的路径下建立 .gdbinit。
配置文件内容：
 set solib-absolute-prefix YOUR_CROSS_COMPILE_PATH
 set solib-search-path YOUR_CROSS_COMPILE_PATH
 set solib-search-path YOUR_DEVELOPER_TOOLS_LIB_PATH
 handle SIG32 nostop noprint pass

**注意：**待调试的可执行文件，在编译的时候需要加 -g，core 文件才能正常显示出错信息！有时候 core 信息很大，超出了开发板的空间限制，生成的 core 信息会残缺不全而无法使用，可以通过挂载到 PC 的方式来规避这一点。

#### 1.2.3、GDB查看内存

如果在知道崩溃地址或阻塞地址的情况下，即使没有调试信息（无代码信息），也可以利用GDB查看该地址内存信息，获取异常原因。

##### 1.2.3.1、命令

x/ <n/f/u> <addr>
n、f、u是可选的参数，<addr> 表示一个内存地址
1）n 是一个正整数，表示显示内存的长度，也就是说从当前地址向后显示几个地址的内容
2）f 表示显示的格式
3）u 表示将多少个字节作为一个值取出来，如果不指定的话，GDB 默认是 4 个 bytes，如果不指定的话，默认是 4 个 bytes。当我们指定了字节长度后，GDB 会从指内存定的内存地址开始，读写指定字节，并把其当作一个值取出来。
4）addr 是地址

**参数 f 的可选值：**
 x 按十六进制格式显示变量。
 d 按十进制格式显示变量。
 u 按十六进制格式显示无符号整型。
 o 按八进制格式显示变量。
 t 按二进制格式显示变量。
 a 按十六进制格式显示变量。
 c 按字符格式显示变量。
 f 按浮点数格式显示变量。

**参数 u 可以用下面的字符来代替：**
b 表示单字节
h 表示双字节
w 表示四字节
g 表示八字节

例如：以两字节为单位显示前面的那个数组的地址后32字节内存信息如下.
(gdb) x /16uh arr
 0xbffff4cc: 2 0 4 0 6 0 8 0
 0xbffff4dc: 10 0 34032 2052 0 0 0 0

#### 1.2.3.2、GDB调试示例
如以下一段简单的代码
```
#include "stdio.h"

unsigned int test[10] = {1,2,3,4,5,6,7,8,9,10};

int main(int argc, char *argv[])
{
  printf("start test : %x\n", test);
  return 0;
}
```

运行后打印：
![img](file:///C:/Users/李永军/AppData/Local/Temp/msohtmlclip1/01/clip_image035.png)

可通过以下命令来查看该地址的值：
![img](file:///C:/Users/李永军/AppData/Local/Temp/msohtmlclip1/01/clip_image036.png)

如果是崩溃则可以借助反汇编或者core文件查看崩溃原因

#### 1.3    GDB调试多线程（正在运行多线程）
### 1.3.1     线程调试命令
(gdb) info threads
显示当前可调试的所有线程，每个线程会有一个 GDB 为其分配的ID，后面操作线程的时候会用到这个ID。
前面有 * 的是当前调试的线程。

//切换当前调试的线程为指定ID的线程。
(gdb) thread ID

//让一个或者多个线程执行 GDB 命令 command
(gdb) thread apply ID1 ID2 command

//让所有被调试线程执行 GDB 命令 command
(gdb) thread apply all command

(gdb) set scheduler-locking off|on|step
在使用 step 或者 continue 命令调试当前被调试线程的时候，其他线程也是同时执行的，怎么只让被调试程序执行呢？通过这个命令就可以实现这个需求。
 off 不锁定任何线程，也就是所有线程都执行，这是默认值。
 on 只有当前被调试程序会执行。
 step 在单步的时候，除了 next 过一个函数的情况(熟悉情况的人可能知道，这其实是一个设置断点然后 continue 的行为)以外，只有当前线程会执行。

//显示线程堆栈信息
(gdb) bt

//察看所有的调用栈
(gdb) f 3
调用框层次

//显示所有当前调用栈的所有变量
(gdb) i locals

例程 debugthread.c
```
#include <stdio.h>
#include <pthread.h>

int wib(int no1, int no2)
{
  int result, diff;

  diff = no1 - no2;
  result = no1 / diff;

  return result;
}

void* myThread1(void)
{
  int i = 15;
  int value = 15;
  int div = -1;
  int result = 0;
  int total = 0;

  while(i > 0)
  {
    printf("1st thread\n");
    sleep(8);

    result = wib(value, div);
    total += result;
    div++;
    value--;
    i--;    

    printf("%d wibed by %d equals %d\n", value, div, total);
  }
  pthread_exit(0);
}

void* myThread2(void)
{
  int i = 30;
  while(i > 0)
  {
    printf("2nd thread\n");
    sleep(4);
    i--;
  }
  pthread_exit(0);
}

int main()
{
  int ret = 0;
  pthread_t thread_id1,thread_id2; 

  ret = pthread_create(&thread_id1, NULL, (void*)myThread1,NULL); 
  if (ret) 
  {
    printf("Create pthread error!\n");
    return 1;
  }

  ret = pthread_create(&thread_id2, NULL, (void*)myThread2, NULL);
  if (ret)
  {
    printf("Create pthread error!\n");
    return 1;
  } 

  pthread_join(thread_id1, NULL);
  pthread_join(thread_id2, NULL); 
  return 0;
}
```

上述例程创建两个线程。线程1存在除数为0的异常。
1、 gcc –g degugthread.c –o debugthread –lpthread
2、 ./debugthread &

![img](file:///C:/Users/李永军/AppData/Local/Temp/msohtmlclip1/01/clip_image037.png)![img](file:///C:/Users/李永军/AppData/Local/Temp/msohtmlclip1/01/clip_image038.png)

3、 进入gdb 并挂在到执行进程中

![img](file:///C:/Users/李永军/AppData/Local/Temp/msohtmlclip1/01/clip_image040.jpg)![img](file:///C:/Users/李永军/AppData/Local/Temp/msohtmlclip1/01/clip_image042.jpg)

这里的进程id为1079， attach到进程后，会暂停所有线程，此时可设置各调试命令

4、 设置线程1断点

![img](file:///C:/Users/李永军/AppData/Local/Temp/msohtmlclip1/01/clip_image044.jpg)

可以看出线程1的id号为3，这里无法确定线程id号与线程创建先后顺序是否有关系，最好是在要调试的线程中加断点，然后切换到该线程(thread命令)

5、 如果此时仅希望调试该线程，而不希望其他线程也被调试命令影响的话，可以调用set scheduler on，此时step或continue命令时，其他线程不会同时运行； 如果希望其他线程同时运行的话，则要set scheduler off。

![img](file:///C:/Users/李永军/AppData/Local/Temp/msohtmlclip1/01/clip_image045.png)

6、 切换线程 thread <threadId>，在测试中发现该命令并不起作用，可通过设置断点切换线程

![img](file:///C:/Users/李永军/AppData/Local/Temp/msohtmlclip1/01/clip_image047.jpg)

从上边发现，从线程3切换到线程2，next下一步时，gdb又从线程2自动切换到线程3了。

为了调试线程2，我们可以进行以下操作：

（1）   在线程2设置断点，并set schedualer off 这样continue时，所有线程都运行，

（2）   Continue运行程序。当线程2运行时会停在断点处，这时gdb进入线程2中，

（3）   set schedualer on 开始仅调试线程2，next/step/continue时其他线程不在运行。

![img](file:///C:/Users/李永军/AppData/Local/Temp/msohtmlclip1/01/clip_image049.jpg)

### 1.4    GDB调试多进程（正在运行的多进程）
一般有三种方法调试多进程，分别是follow-fork-mode方法、GDB wrapper 方法和 attach 进程方法

#### 1.4.1、follow-fork-mode

在 2.5.60 版 Linux 内核及以后，GDB 对使用 fork/vfork 创建子进程的程序提供了 follow-fork-mode 选项来支持多进程调试。follow-fork-mode 的用法为：

set follow-fork-mode [parent|child]
parent: fork之后继续调试父进程，子进程不受影响。
child: fork之后调试子进程，父进程不受影响。

因此如果需要调试子进程，在启动gdb后：

(gdb) set follow-fork-mode child

并在子进程代码设置断点。

此外还有 detach-on-fork 参数，指示 GDB 在 fork 之后是否断开（detach）某个进程的调试，或者都交由 GDB 控制：

set detach-on-fork [on|off]

on: 断开调试follow-fork-mode指定的进程。

off: gdb 将控制父进程和子进程。follow-fork-mode 指定的进程将被调试，另一个进程置于暂停（suspended）状态。

注意，最好使用 GDB 6.6 或以上版本，如果你使用的是 GDB6.4，就只有follow-fork-mode模式。

follow-fork-mode/detach-on-fork 的使用还是比较简单的，但由于其系统内核/gdb 版本限制，我们只能在符合要求的系统上才能使用。而且，由于 follow-fork-mode 的调试必然是从父进程开始的，对于fork多次，以至于出现孙进程或曾孙进程的系统，例如上图3进程系统，调试起来并不方便。

#### 1.4.2     GDB wrapper

很多时候，父进程 fork 出子进程，子进程会紧接着调用 exec 族函数来执行新的代码。对于这种情况，我们也可以使用 gdb wrapper 方法。它的优点是不用添加额外代码。

其基本原理是以 gdb 调用待执行代码作为一个新的整体来被 exec 函数执行，使得待执行代码始终处于 gdb 的控制中，这样我们自然能够调试该子进程代码。该方法这里不做介绍。

#### 1.4.3     Attach

GDB 通过 attach 命令可以附着到正在运行的进程上，并进行调试。

首先获取进程id：# ps -ax | grep 程序名

方法1：gdb 程序名 pid， pid 为程序进程ID
方法2：首先 gdb program 进入，然后attach pid

例程：

Debugproc.c
```
\#include <stdio.h>

int wib**(**int no1**,** int no2**)**

**{**

  int result**,** diff**;**

  diff **=** no1 **-** no2**;**

  result **=** no1 **/** diff**;**

  **return** result**;**

**}**

 

int main**()**

**{**

  int pid**;**

  pid **=** fork**();**

  **if****(**pid **<** 0**)**

  **{**

​    printf**(**"fork err!\n"**);**

​    exit**(-**1**);**

  **}**

  **else** **if****(**pid **==** 0**)**

  **{**

​    //child process

​    sleep**(**60**);**//休眠60s 等待gdb attach上进程后有时间设置断点

​    int value**,** div**,** result**,** i**,** total**;**

​    value **=** 10**;**

​    div **=** 6**;**

​    total **=** 0**;**

​    **for****(**i **=** 0**;** i **<** 10**;** i**++)**

​    **{**

​      result **=** wib**(**value**,** div**);**

​      total **+=** result**;**

​      div**++;**

​      value**--;**

​    **}**

​    printf**(**"%d wibed by %d equals %d\n"**,** value**,** div**,** total**);**

​    exit**(**0**);**

  **}**

  **else****{**

​    //parent process

​     sleep**(**4**);**

​    wait**(-**1**);**

​    exit**(**0**);**

  **}**

  

**}**
```

先编译：Gcc –g debugproc.c –o debugproc

1、 运行degugproc

![img](file:///C:/Users/李永军/AppData/Local/Temp/msohtmlclip1/01/clip_image050.png)

814是父进程的pid

2、 获得进程ID 包括父进程 子进程

![img](file:///C:/Users/李永军/AppData/Local/Temp/msohtmlclip1/01/clip_image051.png)

3、 Gdb加载程序 并attach到子进程

![img](file:///C:/Users/李永军/AppData/Local/Temp/msohtmlclip1/01/clip_image053.jpg)

4、 stop 子进程 并break调试

![img](file:///C:/Users/李永军/AppData/Local/Temp/msohtmlclip1/01/clip_image054.png)

停止子进程，并设置断点。

![img](file:///C:/Users/李永军/AppData/Local/Temp/msohtmlclip1/01/clip_image056.jpg)

### 1.4.4     总结

1、 在gdb下运行多进程程序，需要用set follow-fork-mode [parent|child]切换进程，但多个子进程时，用这种方法比较麻烦；如果用attach的话，则需要知道各进程ID，如何获得进程ID呢？

2、 先运行多进程程序（后台运行），然后ps获取进程Id，进入gdb 并attach进程ID，这种方法需要进程有一定的等待时间，以便gdb附着到进程，然后stop并设置断点。

# 2     ObjDump调试

ObjDump命令可用来查看目标文件和可执行文件构成的GCC工具。一般用来查段错误崩溃。

参数如下：

-C --demangle 将底层的符号名解码成用户级名字，除了去掉所开头的下划线之外，还使得C++函数名以可理解的方式显示出来。 

-D --disassemble-all 与 -d 类似，但反汇编所有section.

-S --source 尽可能反汇编出源代码，尤其当编译的时候指定了-g这种调试参数时，效果比较明显。隐含了-d参数。 

--archive-headers -a 显示档案库的成员信息,类似ls -l将lib*.a的信息列出。

-b bfdname --target=bfdname 指定目标码格式。这不是必须的，objdump能自动识别许多格式，比如： objdump -b oasys -m vax -h fu.o 显示fu.o的头部摘要信息，明确指出该文件是Vax系统下用Oasys编译器生成的目标文件。objdump -i将给出这里可以指定的目标码格式列表。

--debugging -g 显示调试信息。企图解析保存在文件中的调试信息并以C语言的语法显示出来。仅仅支持某些类型的调试信息。有些其他的格式被readelf -w支持。 

-e --debugging-tags 类似-g选项，但是生成的信息是和ctags工具相兼容的格式。 

--disassemble -d 从objfile中反汇编那些特定指令机器码的section。 

--prefix-addresses 反汇编的时候，显示每一行的完整地址。这是一种比较老的反汇编格式。

-EB -EL --endian={big|little} 指定目标文件的小端。这个项将影响反汇编出来的指令。在反汇编的文件没描述小端信息的时候用。例如S-records. -f --file-headers 显示objfile中每个文件的整体头部摘要信息。

-h --section-headers --headers 显示目标文件各个section的头部摘要信息。

-H --help 简短的帮助信息。

-i --info 显示对于 -b 或者 -m 选项可用的架构和目标格式列表。

-j name --section=name 仅仅显示指定名称为name的section的信息

-l --line-numbers 用文件名和行号标注相应的目标代码，仅仅和-d、-D或者-r一起使用使用-ld和使用-d的区别不是很大，在源码级调试的时候有用，要求编译时使用了-g之类的调试编译选项。

-m machine --architecture=machine 指定反汇编目标文件时使用的架构，当待反汇编文件本身没描述架构信息的时候(比如S-records)，这个选项很有用。可以用-i选项列出这里能够指定的架构. --reloc -r 显示文件的重定位入口。如果和-d或者-D一起使用，重定位部分以反汇编后的格式显示出来。 --dynamic-reloc -R 显示文件的动态重定位入口，仅仅对于动态目标文件意义，比如某些共享库。

-s --full-contents 显示指定section的完整内容。默认所有的非空section都会被显示。

--show-raw-insn 反汇编的时候，显示每条汇编指令对应的机器码，如不指定--prefix-addresses，这将是缺省选项。

--no-show-raw-insn 反汇编时，不显示汇编指令的机器码，如不指定--prefix-addresses，这将是缺省选项。

--start-address=address 从指定地址开始显示数据，该选项影响-d、-r和-s选项的输出。 --stop-address=address 显示数据直到指定地址为止，该项影响-d、-r和-s选项的输出。

-t --syms 显示文件的符号表入口。类似于nm -s提供的信息

-T --dynamic-syms 显示文件的动态符号表入口，仅仅对动态目标文件意义，比如某些共享库。它显示的信息类似于 nm -D|--dynamic 显示的信息。

-V --version 版本信息

--all-headers -x 显示所可用的头信息，包括符号表、重定位入口。

-x 等价于-a -f -h -r -t 同时指定。

-z --disassemble-zeroes 一般反汇编输出将省略大块的零，该选项使得这些零块也被反汇编。

@file 可以将选项集中到一个文件中，然后使用这个@file选项载入。
 例子：mainmaster.cpp

u32 dwDelay **=** 0**;**

**while** **(**dwDelay **<** 8**)**

**{**

  dwDelay **+=** 2**;**

  printf**(**"vmp %d set enc param...\n"**,** dwSessionId**);**

  OspTaskDelay**(**2000**);**

**}**

 

TVideoEncParam *****ptVidEncParam**;**// = new TVideoEncParam;

 

ptVidEncParam**->**m_byEncType **=** MEDIA_TYPE_H264**;**

ptVidEncParam**->**m_wVideoWidth **=** 1920**;**      /*图像宽度(default:1280)*/

ptVidEncParam**->**m_wVideoHeight **=** 1080**;**      /*图像高度(default:720)*/

ptVidEncParam**->**m_dwMaxKeyFrameInterval **=** 3000**;** /*I帧间最大P帧数目*/

ptVidEncParam**->**m_wBitRate **=** 4096**;**        /*编码比特率(Kbps)*/

 

ptVidEncParam**->**m_byRcMode **=** 0**;**        /*图像压缩码率控制参数*/  

ptVidEncParam**->**m_byMaxQuant **=** 45**;**       /*最大量化参数(1-51)*/

ptVidEncParam**->**m_byMinQuant **=** 20**;**       /*最小量化参数(1-51)*/

ptVidEncParam**->**m_dwAvgQpI **=** 0**;**       /* 平均qp 默认0- 28*

编译生成的可执行程序 mpu2master.out

运行出现以下段错误：

![img](file:///C:/Users/李永军/AppData/Local/Temp/msohtmlclip1/01/clip_image057.png)

使用objdump反汇编可执行程序并将信息保存到objdump.txt中：

方法1：objdump –D –C

Arm-none-linux-gnueabi-objdump –D –C mpu2master.out >objdump.txt

![img](file:///C:/Users/李永军/AppData/Local/Temp/msohtmlclip1/01/clip_image059.jpg)

通过地址查看反汇编文件。一般情况下，可利用函数名、立即数定位定位错误位置，并查看发生段错误的变量是否初始化。

![img](file:///C:/Users/李永军/AppData/Local/Temp/msohtmlclip1/01/clip_image060.png)

从上面可以看出是在ptVidEncParam的成员变量在赋值的时候出现错误，查看发现指针变量ptVidEncParam并未new初始化。

方法2：objdump –D –S

Arm-none-linux-gnueabi-objdump –D –S mpu2master.out >objdump.txt

![img](file:///C:/Users/李永军/AppData/Local/Temp/msohtmlclip1/01/clip_image062.jpg)

查看反汇编文件：

![img](file:///C:/Users/李永军/AppData/Local/Temp/msohtmlclip1/01/clip_image064.jpg)

很容易发现-S参数比-C参数更直接明了，易于定位。但需要注意的是：只有当可执行文件在编译时，加-g添加调试信息，objdump –S反汇编出来的系想你才会如此详细。如果没有-g调试信息，-S的效果与-C相同。

# 3     Strace跟踪系统调用

在linux中，我们可以通过跟踪程序执行过程中产生的系统调用及接收到的信号，分析程序或命令执行过程中出现的异常情况。

## 3.1    Strace输出介绍

例程：main.c

\#include <sys/types.h>

\#include <sys/stat.h>

\#include <fcntl.h>

 

int main**()**

**{**

  int fd**;**

  int i **=** 0**;**

  fd **=** open**(**"/tmp/foo"**,**O_RDONLY**);**

  **if****(**fd**<**0**)**

  i **=** 5**;**

  **else**

  i **=** 2**;**

  **return** i**;**

**}**

Gcc main.c –o main

利用strace对main进行跟踪，将结果重定向到strace.txt中：

Strace –o strace.txt ./main

查看strace.txt内容如下：

 ![img](file:///C:/Users/李永军/AppData/Local/Temp/msohtmlclip1/01/clip_image066.jpg)

红框中的行号不是strace.txt中内容，是为了方便下面说明添加的

strace跟踪程序与系统交互时产生的系统调用，以上每一行就对应一个系统调用，格式为：

**系统调用的名称(** **参数... ) =** **返回值** **错误标志和描述**

**Line 1**: 对于命令行下执行的程序，execve(或exec系列调用中的某一个)均为strace输出系统调用中的第一个。strace首先调用fork或clone函数新建一个子进程，然后在子进程中调用exec载入需要执行的程序(这里为./main)

**Line 2**: 以0作为参数调用brk，返回值为内存管理的起始地址(若在子进程中调用malloc，则从0x9ac4000地址开始分配空间)

**Line 3**: 调用access函数检验/etc/ld.so.nohwcap是否存在

**Line 4**: 使用mmap2函数进行匿名内存映射，以此来获取8192bytes内存空间，该空间起始地址为0xb7739000 

**Line 6**: 调用open函数尝试打开/etc/ld.so.cache文件，返回文件描述符为3

**Line 7**: fstat64函数获取/etc/ld.so.cache文件信息

**Line 8**: 调用mmap2函数将/etc/ld.so.cache文件映射至内存

**Line 9**: close关闭文件描述符为3指向的/etc/ld.so.cache文件

**Line12**: 调用read，从/lib/i386-linux-gnu/libc.so.6该libc库文件中读取512bytes，即读取[ELF](http://blogimg.chinaunix.net/blog/upfile2/110307091731.pdf)头信息

**Line15**: 使用mprotect函数对0x6c7000起始的4096bytes空间进行保护(PROT_NONE表示不能访问，PROT_READ表示可以读取)

**Line24**: 调用munmap函数，将/etc/ld.so.cache文件从内存中去映射，与Line 8的mmap2对应

**Line25**: 对应源码中使用到的唯一的系统调用——open函数，使用其打开/tmp/foo文件

**Line26**: 子进程结束，退出码为5。

## 3.2    命令格式及参数介绍

Strace –o 输出文件名 可执行文件名 [参数]

参数说明：

**-p** **主进程号**

**-o filename,****则所有进程的跟踪结果输出到相应的filename**

**-c** **统计每一系统调用的所执行的时间,****次数和出错的次数等.****
 -t** **在输出中的每一行前加上时间信息.****
 -tt** **在输出中的每一行前加上时间信息,****微秒级.****
 -ttt** **微秒级输出,****以秒了表示时间.****
 -T** **显示每一调用所耗的时间.**

**-f** **跟踪由fork****调用所产生的子进程.****
 -F** **尝试跟踪vfork****调用.****在-f****时,vfork****不被跟踪.**

-d 输出strace关于标准错误的调试信息.
 -h 输出简要的帮助信息.
 -i 输出系统调用的入口指针.
 -q 禁止输出关于脱离的消息.
 -r 打印出相对时间关于,,每一个系统调用.
 -v 输出所有的系统调用.一些调用关于环境变量,状态,输入输出等调用由于使用频繁,默认不输出.
 -V 输出strace的版本信息.
 -x 以十六进制形式输出非标准字符串
 -xx 所有字符串以十六进制形式输出.
 -a column
 设置返回值的输出位置.默认为40.
 -e execve 只记录 execve 这类系统调用

## 3.3    例程

Mainmaster.cpp文件加如下死循环

![img](file:///C:/Users/李永军/AppData/Local/Temp/msohtmlclip1/01/clip_image068.jpg)

编译生成mpu2master.out

运行该程序发现程序阻塞：

![img](file:///C:/Users/李永军/AppData/Local/Temp/msohtmlclip1/01/clip_image070.jpg)

在A8上使用strace跟踪该程序

方法一：

strace_davinci -o strace.txt -Ttt ./mpu2master.out 172.16.80.81 6&

![img](file:///C:/Users/李永军/AppData/Local/Temp/msohtmlclip1/01/clip_image072.jpg)

查看strace.txt很容易发现问题所在：

![img](file:///C:/Users/李永军/AppData/Local/Temp/msohtmlclip1/01/clip_image074.jpg)

方法二：不需要重新运行程序，而是利用-p参数

Strace –p 进程号

![img](file:///C:/Users/李永军/AppData/Local/Temp/msohtmlclip1/01/clip_image075.png)

当程序阻塞时，ps出该执行程序的进程号，然后通过进程号跟踪程序。如果有多个进行，可通过多次-p 进程号 来跟踪多个经常。

查看strace.txt发现：程序阻塞是由于sleep造成。

![img](file:///C:/Users/李永军/AppData/Local/Temp/msohtmlclip1/01/clip_image077.jpg)

# 4     pstack/gstack

pstack和gstack都可以用来跟踪函数调用堆栈信息。pstack其实是gstack的软连接，gstack是基于GDB封装的shell脚本。

pstack/gstack的作用如下：

1、 查看线程数（包含详细的堆栈信息）

2、 查看函数调用顺序

3、 发现程序阻塞位置及性能消耗点

4、 反映死锁现象（多个线程同时在wait lock，具体需要进一步验证）

## 4.1    命令格式

gstack/pstack process-id

 

# 5     Valgrind内存排查

Valgrind是一套linux下仿真调试工具的集合。主要包括以下工具：

1、 MemCheck。最常用的检查程序中的内存问题，如泄漏、越界、非法指针等。

2、 Callgrind。检测程序代码的运行时间和调用过程，以及分析程序性能。

3、 Cachegrind。分析CPU缓存使用出现的问题。

4、 Helgrind。检测多线程中出现的竞争问题。

5、 Massif。堆栈分析器。检测程序中堆栈信息。

**以上工具通过命令：valgrind --tool=name**来调用（name为工具名称）。若不指定tool参数，默认是--tool=memcheck。

Valgrind不检查静态分配数组的使用情况。
 Valgrind占用了更多的内存--可达两倍于你程序的正常使用量。如果你用Valgrind来检测使用大量内存的程序就会遇到问题，它可能会用很长的时间来运行测试

这里重点介绍memcheck工具，在介绍之前，先了解下linux的内存分布。

## 5.1    Linux内存空间

![img](file:///C:/Users/李永军/AppData/Local/Temp/msohtmlclip1/01/clip_image078.png)

一个典型的Linux C程序内存空间由如下几部分组成：

1、代码段（.text）。这里存放的是CPU要执行的指令。代码段是可共享的，相同的代码在内存中只会有一个拷贝，同时这个段是只读的，防止程序由于错误而修改自身的指令。

2、初始化数据段（.data）。这里存放的是程序中需要明确赋初始值的变量，例如位于所有函数之外的全局变量：int val="100"。需要强调的是，以上两段都是位于程序的可执行文件中，内核在调用exec函数启动该程序时从源程序文件中读入。

3、未初始化数据段（.bss）。位于这一段中的数据，内核在执行该程序前，将其初始化为0或者null。例如出现在任何函数之外的全局变量：int sum;

4、堆（Heap）。这个段用于在程序中进行动态内存申请，例如经常用到的malloc，new系列函数就是从这个段中申请内存。

5、栈（Stack）。函数中的局部变量以及在函数调用过程中产生的临时变量都保存在此段中。

## 5.2    Memcheck

主要用来检测程序中出现的内存问题，检测所有对内存的读写，捕获一切对malloc、free、new、delete的调用。故可检测以下问题：

1、使用未初始化的内存 (Use of uninitialised memory)
 2、使用已经释放了的内存 (Reading/writing memory after it has been free)
 3、使用超过 malloc分配的内存空间(Reading/writing off the end of malloc blocks)
 4、对堆栈的非法访问 (Reading/writing inappropriate areas on the stack)
 5、申请的空间是否有释放 (Memory leaks – where pointers to malloc blocks are lost forever)
 6、malloc/free/new/delete申请和释放内存的匹配(Mismatched use of malloc/new/new [] vs free/delete/delete [])
 7、内存拷贝或字符串拷贝src和dst的重叠(Overlapping src and dst pointers in memcpy() and related functions)

### 5.2.1     使用Memcheck检查内存问题

Valgrind –tool=memcheck –leak-check=full 程序名 2>输出文件名

程序编译时加-g调试信息，这样memcheck的错误信息可以精确到行。

memcheck工具的常用的几个参数选项：

1、-leak-check=no|summary|full 要求对leak给出信息的详细程度，默认为summary。Full标识完全检测内存泄漏

2、-show-reachable=no|yes 是否显示内存泄漏地点，默认为no

3、-track-origins=no|yes 是否追踪原始位置。当出现为初始化变量时Conditional jump or move depends on uninitialised value(s)，使用该命令可查到未初始化值的根源，但memcheck的运行会变得很慢。

### 5.2.2     内存检查选项

--leak-check=<no|summary|yes|full> [default: summary]

当这个选项打开时，程序结束时查找内存泄漏。内存泄漏意味着有用malloc分配内存块，但是没有用free释放，而且没有指针指向这块内存。这样的内存块永远不能被程序释放，因为没有指针指向它们。如果设置为summary，Valgrind会报告有多少内存泄漏发生了。如果设置为full或yes，Valgrind给出每一个独立的泄漏的详细信息。

--show-reachable=<yes|no> [default: no]

当这个选项关闭时，内存泄漏检测器只显示没有指针指向的内存块，或者只能找到指向块中间的指针。当这个选项打开时，内存泄漏检测器还报告有指针指向的内存块。这些块是最有可能出现内存泄漏的地方。你的程序可能，至少在原则上，应该在退出前释放这些内存块。这些有指针指向的内存块和没有指针指向的内存块，或者只有内部指针指向的块，都可能产生内存泄漏，因为实际上没有一个指向块起始的指针可以拿来释放，即使你想去释放它。

--leak-resolution=<low|med|high> [default: low]

在做内存泄漏检查时，确定memcheck将怎么样考虑不同的栈是相同的情况。当设置为low时，只需要前两层栈匹配就认为是相同的情况；当设置为med，必须要四层栈匹配，当设置为high时，所有层次的栈都必须匹配。对于hardcore内存泄漏检查，你很可能需要使用--leak-resolution=high和--num-callers=40或者更大的数字。注意这将产生巨量的信息，这就是为什么默认选项是四个调用者匹配和低分辨率的匹配。注意--leak-resolution= 设置并不影响memcheck查找内存泄漏的能力。它只是改变了结果如何输出。

--freelist-vol=<number> [default: 5000000]

当客户程序使用free(C中)或者delete(C++)释放内存时，这些内存并不是马上就可以用来再分配的。这些内存将被标记为不可访问的，并被放到一个已释放内存的队列中。这样做的目的是，使释放的内存再次被利用的点尽可能的晚。这有利于memcheck在内存块释放后这段重要的时间检查对块不合法的访问。这个选项指定了队列所能容纳的内存总容量，以字节为单位。默认的值是5000000字节。增大这个数目会增加memcheck使用的内存，但同时也增加了对已释放内存的非法使用的检测概率。

--workaround-gcc296-bugs=<yes|no> [default: no]

当这个选项打开时，假定读写栈指针以下的一小段距离是gcc 2.96的bug，并且不报告为错误。距离默认为256字节。注意gcc 2.96是一些比较老的Linux发行版(RedHat 7.X)的默认编译器，所以你可能需要使用这个选项。如果不是必要请不要使用这个选项，它可能会使一些真正的错误溜掉。一个更好的解决办法是使用较新的，修正了这个bug的gcc/g++版本。

--partial-loads-ok=<yes|no> [default: no]

控制memcheck如何处理从地址读取时字长度，字对齐，因此哪些字节是可以寻址的，哪些是不可以寻址的。当设置为yes是，这样的读取并不抛出一个寻址错误。而是从非法地址读取的V字节显示为未定义，访问合法地址仍然是像平常一样映射到内存。设置为no时，从部分错误的地址读取与从完全错误的地址读取同样处理：抛出一个非法地址错误，结果的V字节显示为合法数据。注意这种代码行为是违背ISO C/C++标准，应该被认为是有问题的。如果可能，这种代码应该修正。这个选项应该只是做为一个最后考虑的方法。

--undef-value-errors=<yes|no> [default: yes]

控制memcheck是否检查未定义值的危险使用。当设为yes时，Memcheck的行为像Addrcheck, 一个轻量级的内存检查工具，是Valgrind的一个部分，它并不检查未定义值的错误。使用这个选项，如果你不希望看到未定义值错误。

### 5.2.3     内存泄漏问题总结

例程：ValgrindTest.cpp



\#include <stdio.h>

\#include <stdlib.h>

\#include <string.h>

 

int main**()**

**{**

  /****未初始化*****/

  int i**;** 

  **if****(**i **==** 0**)**

  **{**

​    printf**(**"i equals zero\n"**);**

  **}**

  

  /****内存读写越界*****/

  int j **=**0**;**

  int len **=** 5**;**

  int***** pt **=** **(**int***)**malloc**(**len*******sizeof****(**int**));**

  int***** p **=**pt**;**

  **for****(;** j**<**len**;** j**++)**

  **{**

​    p**++;**

  **}**

  *****p **=** 5**;** //写越界

  printf**(**"value = %d\n"**,** *****p**);**//读越界

  

  /*****malloc/free/new/delete不匹配****/

  **delete** pt**;**

  pt**[**1**]** **=** 1**;**

 

  /****重复释放内存****/

  free**(**p**);**

  

  /****未释放内存导致内存泄漏****/

  int***** q **=** **(**int***)**malloc**(**8**);**

  

  /****内存拷贝重叠****/

  char ch**[**50**];**

  int k **=**0**;**

  **for****(;** k**<**50**;** k**++)**

  **{**

​    ch**[**k**]** **=** k**;**

  **}**

  memcpy**(**ch**+**20**,** ch**,** 20**);**//ok

  memcpy**(**ch**+**20**,** ch**,** 30**);**//overlap

  

  **return** 1**;**



编译：

![img](file:///C:/Users/李永军/AppData/Local/Temp/msohtmlclip1/01/clip_image079.png)

内存检测并将结果保存到valgrindTestOutput.txt中：

Valgrind –tool=memcheck –leak-check=full ./valgrindTest 2>valgrindTestOutput.txt

![img](file:///C:/Users/李永军/AppData/Local/Temp/msohtmlclip1/01/clip_image081.jpg)

查看该文件如下：762为进程号。**
 ==**762**==** Memcheck**,** a memory error detector**.**

**==**762**==** Copyright **(**C**)** 2002**-**2005**,** and GNU GPL'd, by Julian Seward et al.

**==**762**==** Using LibVEX rev 1575**,** a library **for** dynamic binary translation**.**

**==**762**==** Copyright **(**C**)** 2004**-**2005**,** and GNU GPL'd, by OpenWorks LLP.

**==**762**==** Using valgrind**-**3.1.1**,** a dynamic binary instrumentation framework**.**

**==**762**==** Copyright **(**C**)** 2000**-**2005**,** and GNU GPL'd, by Julian Seward et al.

**==**762**==** For more details**,** rerun with**:** **-**v

**==**762**==** 

**==**762**==** Conditional jump or move depends on uninitialised value**(**s**)**

**==**762**==**  at 0x804852C**:** main **(**ValgrindTest**.**cpp**:**9**)**

**==**762**==** 

**==**762**==** Invalid write of size 4

**==**762**==**  at 0x804857F**:** main **(**ValgrindTest**.**cpp**:**23**)**

**==**762**==** Address 0x402003C is 0 bytes after a block of size 20 alloc'd

**==**762**==**  at 0x4004405**:** malloc **(**vg_replace_malloc**.**c**:**149**)**

**==**762**==**  by 0x804855A**:** main **(**ValgrindTest**.**cpp**:**17**)**

**==**762**==** 

**==**762**==** Invalid read of size 4

**==**762**==**  at 0x804858B**:** main **(**ValgrindTest**.**cpp**:**24**)**

**==**762**==** Address 0x402003C is 0 bytes after a block of size 20 alloc'd

**==**762**==**  at 0x4004405**:** malloc **(**vg_replace_malloc**.**c**:**149**)**

**==**762**==**  by 0x804855A**:** main **(**ValgrindTest**.**cpp**:**17**)**

**==**762**==** 

**==**762**==** Mismatched free**()** **/** delete **/** delete **[]**

**==**762**==**  at 0x400518E**:** operator delete**(**void***)** **(**vg_replace_malloc**.**c**:**246**)**

**==**762**==**  by 0x80485A4**:** main **(**ValgrindTest**.**cpp**:**27**)**

**==**762**==** Address 0x4020028 is 0 bytes inside a block of size 20 alloc'd

**==**762**==**  at 0x4004405**:** malloc **(**vg_replace_malloc**.**c**:**149**)**

**==**762**==**  by 0x804855A**:** main **(**ValgrindTest**.**cpp**:**17**)**

**==**762**==** 

**==**762**==** Invalid write of size 4

**==**762**==**  at 0x80485AE**:** main **(**ValgrindTest**.**cpp**:**28**)**

**==**762**==** Address 0x402002C is 4 bytes inside a block of size 20 free'd

**==**762**==**  at 0x400518E**:** operator delete**(**void***)** **(**vg_replace_malloc**.**c**:**246**)**

**==**762**==**  by 0x80485A4**:** main **(**ValgrindTest**.**cpp**:**27**)**

**==**762**==** 

**==**762**==** Invalid free**()** **/** delete **/** delete**[]**

**==**762**==**  at 0x4004EFA**:** free **(**vg_replace_malloc**.**c**:**235**)**

**==**762**==**  by 0x80485BE**:** main **(**ValgrindTest**.**cpp**:**31**)**

**==**762**==** Address 0x402003C is 0 bytes after a block of size 20 free'd

**==**762**==**  at 0x400518E**:** operator delete**(**void***)** **(**vg_replace_malloc**.**c**:**246**)**

**==**762**==**  by 0x80485A4**:** main **(**ValgrindTest**.**cpp**:**27**)**

**==**762**==** 

**==**762**==** Source and destination overlap in memcpy**(**0xBEE78884**,** 0xBEE78870**,** 30**)**

**==**762**==**  at 0x4006236**:** memcpy **(**mac_replace_strmem**.**c**:**394**)**

**==**762**==**  by 0x804861F**:** main **(**ValgrindTest**.**cpp**:**44**)**

**==**762**==** 

**==**762**==** ERROR SUMMARY**:** 7 errors from 7 contexts **(**suppressed**:** 15 from 1**)**

**==**762**==** malloc**/**free**:** in use at exit**:** 8 bytes in 1 blocks**.**

**==**762**==** malloc**/**free**:** 2 allocs**,** 2 frees**,** 28 bytes allocated**.**

**==**762**==** For counts of detected errors**,** rerun with**:** **-**v

**==**762**==** searching **for** pointers to 1 not**-**freed blocks**.**

**==**762**==** checked 104**,**260 bytes**.**

**==**762**==** 

**==**762**==** 

**==**762**==** 8 bytes in 1 blocks are definitely lost in loss record 1 of 1

**==**762**==**  at 0x4004405**:** malloc **(**vg_replace_malloc**.**c**:**149**)**

**==**762**==**  by 0x80485CB**:** main **(**ValgrindTest**.**cpp**:**34**)**

**==**762**==** 

**==**762**==** LEAK SUMMARY**:**

**==**762**==**  definitely lost**:** 8 bytes in 1 blocks**.**

**==**762**==**   possibly lost**:** 0 bytes in 0 blocks**.**

**==**762**==**  still reachable**:** 0 bytes in 0 blocks**.**

**==**762**==**     suppressed**:** 0 bytes in 0 blocks**.**

**==**762**==** Reachable blocks **(**those to which a pointer was found**)** are not shown**.**

**==**762**==** To see them**,** rerun with**:** **--**show**-**reachable**=**yes

 

#### 5.2.3.1   未初始化内存

对于位于程序中不同段的变量，其初始值是不同的，全局变量和静态变量初始值为0，而局部变量和动态申请的变量，其初始值为随机值。如果程序使用了为随机值的变量，那么程序的行为就变得不可预期。

如例程中代码：

![img](file:///C:/Users/李永军/AppData/Local/Temp/msohtmlclip1/01/clip_image083.jpg)

对应的检测结果如下：结果显示第9行的条件跳转依赖于未初始化的值。

![img](file:///C:/Users/李永军/AppData/Local/Temp/msohtmlclip1/01/clip_image085.jpg)

#### 5.2.3.2   内存越界读写

该情况是值访问了你不应该/没有权限访问的内存地址空间，比如访问数组时越界；对动态内存访问时超出了申请的内存大小范围。

如例程中的代码：pt是一个局部数组变量，其大小为4，p初始指向pt数组的起始地址，但在对p循环叠加后，p超出了pt数组的范围，如果此时再对p进行写操作，那么后果将不可预期。

![img](file:///C:/Users/李永军/AppData/Local/Temp/msohtmlclip1/01/clip_image087.jpg)

检测结果对应如下：23、24行存在读写越界的问题。

![img](file:///C:/Users/李永军/AppData/Local/Temp/msohtmlclip1/01/clip_image089.jpg)

#### 5.2.3.3   malloc/free/new/delete申请和释放内存不匹配

由于 C++ 兼容 C，而 C 与 C++ 的内存申请和释放函数是不同的，因此在 C++ 程序中，就有两套动态内存管理函数。一条不变的规则就是采用 C 方式申请的内存就用 C 方式释放；用 C++ 方式申请的内存，用 C++ 方式释放。也就是用 malloc/alloc/realloc 方式申请的内存，用 free 释放；用 new 方式申请的内存用 delete 释放。在上述程序中，用 malloc 方式申请了内存却用 delete 来释放，虽然这在很多情况下不会有问题，但这绝对是潜在的问题。

例程中用17行用malloc分配内存，在27行却用delete释放

![img](file:///C:/Users/李永军/AppData/Local/Temp/msohtmlclip1/01/clip_image091.jpg)

![img](file:///C:/Users/李永军/AppData/Local/Temp/msohtmlclip1/01/clip_image093.jpg)

检测结果如下：指明了17行和27行的对应

![img](file:///C:/Users/李永军/AppData/Local/Temp/msohtmlclip1/01/clip_image095.jpg)

#### 5.2.3.4   内存覆盖

C 语言的强大和可怕之处在于其可以直接操作内存，C 标准库中提供了大量这样的函数，比如 strcpy, strncpy, memcpy, strcat 等，这些函数有一个共同的特点就是需要设置源地址 (src)，和目标地址(dst)，src 和 dst 指向的地址不能发生重叠，否则结果将不可预期。

例程中，src与dst相差20字节，但却拷贝30字节长度，造成内存覆盖。

![img](file:///C:/Users/李永军/AppData/Local/Temp/msohtmlclip1/01/clip_image097.jpg)

检测结果如下：
 ![img](file:///C:/Users/李永军/AppData/Local/Temp/msohtmlclip1/01/clip_image099.jpg)

#### 5.2.3.5   重复释放、释放后继续读写

如例程中pt已经被释放，却依然被使用。p与pt指向同意内存，在pt释放后，重复释放。

![img](file:///C:/Users/李永军/AppData/Local/Temp/msohtmlclip1/01/clip_image101.jpg)

检测结果：

重复释放：

![img](file:///C:/Users/李永军/AppData/Local/Temp/msohtmlclip1/01/clip_image103.jpg)

释放后继续使用：

![img](file:///C:/Users/李永军/AppData/Local/Temp/msohtmlclip1/01/clip_image104.png)

#### 5.2.3.6   内存泄漏

内存泄露（Memory leak）指的是，在程序中动态申请的内存，在使用完后既没有释放，又无法被程序的其他部分访问。防止内存泄露要从良好的编程习惯做起，另外重要的一点就是要加强单元测试（Unit Test）。

内存泄漏分为以下几种：

![img](file:///C:/Users/李永军/AppData/Local/Temp/msohtmlclip1/01/clip_image106.jpg)

Definitely lost：明确地已经泄漏了，因为在程序运行完的时候，没有指针指向它, 指向它的指针在程序中丢失了。一般这种泄漏常见，而且比较难发现问题所在。

Possibly lost:：发现了一个指向某块内存中部的指针，而不是指向内存块头部。这种指针一般是原先指向内存块头部，后来移动到了内存块的中部，还有可能该指针和该内存根本就没有关系，检测工具只是怀疑有内存泄漏。

Still reachable：表示泄漏的内存在程序运行完的时候，仍旧有指针指向它，因而，这种内存在程序运行结束之前可以释放，所以这种并不是真正的泄漏。一般来说，static指针变量和全局指针变量进行内存分配后，如果没有手动释放，memcheck虽然也会显示not-freed blocks，但他是reachable，os会得到这些指针并释放它。**一般情况下****valgrind****不会报这种泄漏的位置，除非使用了参数** **--show-reachable=yes****。**

Suppressed：该泄漏错误可忽略

例程1代码：这是局部指针变量的内存泄漏。

![img](file:///C:/Users/李永军/AppData/Local/Temp/msohtmlclip1/01/clip_image108.jpg)

检测结果：
 ![img](file:///C:/Users/李永军/AppData/Local/Temp/msohtmlclip1/01/clip_image109.png)

例程2：静态指针

int main**()**

**{**

  static int***** pi**;** //静态指针，并没有真正的内存泄漏

  pi **=** **new** int**;**

  **return** 0**;**

**}**

不带参数—show-reachable=yes检测结果：



![img](file:///C:/Users/李永军/AppData/Local/Temp/msohtmlclip1/01/clip_image111.jpg)

带参数—show-reachable=yes检测结果：显然，带参数会指出这种泄漏的位置。

![img](file:///C:/Users/李永军/AppData/Local/Temp/msohtmlclip1/01/clip_image113.jpg)



# Ⅱ Linux 常用配置

## 1、服务器参数调优

### 1.1、ulimit

```shell
root@msp-Default-string:~# ulimit -a
core file size          (blocks, -c) 0
data seg size           (kbytes, -d) unlimited
scheduling priority             (-e) 0
file size               (blocks, -f) unlimited
pending signals                 (-i) 63694
max locked memory       (kbytes, -l) 64
max memory size         (kbytes, -m) unlimited
open files                      (-n) 1024
pipe size            (512 bytes, -p) 8
POSIX message queues     (bytes, -q) 819200
real-time priority              (-r) 0
stack size              (kbytes, -s) unlimited
cpu time               (seconds, -t) unlimited
max user processes              (-u) 63694
virtual memory          (kbytes, -v) unlimited
file locks                      (-x) unlimited
root@msp-Default-string:~# 

```

[TCP send 返回报错(11: Resource temporarily unavailable)](https://www.cnblogs.com/Primzahl/p/16053830.html)
[IP Sysctl — The Linux Kernel documentation](https://www.kernel.org/doc/html/latest/networking/ip-sysctl.html)

```shell
11 Resource temporarily unavailable

# sysctl 查看参数信息
root@msp-Default-string:~# sysctl -a

# 


# 查看 Linux 系统 net.core.somaxconn 默认值 128
root@msp-Default-string:~# sysctl net.core.somaxconn 
net.core.somaxconn = 128
root@msp-Default-string:~# 
# 修改默认值(系统重启恢复默认值)
root@msp-Default-string:~# sysctl -w net.core.somaxconn=65535
net.core.somaxconn = 65535
root@msp-Default-string:~# 
root@msp-Default-string:~# 

# 配置文件中修改该参数
echo "net.core.somaxconn=65536" >> /etc/sysctl.conf
sysctl -p



# ipcs -a 查看是否有消息队
root@msp-Default-string:~# ipcs -a

------ Message Queues --------
key        msqid      owner      perms      used-bytes   messages    

------ Shared Memory Segments --------
key        shmid      owner      perms      bytes      nattch     status      
0x00000000 65536      lightdm    600        524288     2          dest         
0x00000000 262145     lightdm    600        524288     2          dest         
0x00000000 294914     lightdm    600        33554432   2          dest         

------ Semaphore Arrays --------
key        semid      owner      perms      nsems     
0x4c757430 0          root       666        1         
0xffffffff 32769      root       666        1

root@msp-Default-string:~# ipcs -l

------ Messages Limits --------
max queues system wide = 32000
max size of message (bytes) = 8192
default max size of queue (bytes) = 16384

------ Shared Memory Limits --------
max number of segments = 4096
max seg size (kbytes) = 18014398509465599
max total shared memory (kbytes) = 18014398442373116
min seg size (bytes) = 1

------ Semaphore Limits --------
max number of arrays = 32000
max semaphores per array = 32000
max semaphores system wide = 1024000000
max ops per semop call = 500
semaphore max value = 32767
```











## 2、网络

### 2.1、网络配置

#### Debian系

#### CentOS系

# Ⅲ Linux常用工具记录