---
datetime: 
aliases:
  - MQTT 协议
tags:
  - Protocol/MQTT
---

# MQTT协议

## MQTT

### 项目仓库

[An Eclipse Paho C client library for MQTT for Windows, Linux and MacOS. API documentation](https://github.com/eclipse/paho.mqtt.c)

### 简介

MQTT（Message Queuing Telemetry Transport，消息队列遥测传输）是IBM开发的一个即时通讯协议，通过MQTT协议，目前已经扩展出了数十个MQTT服务器端程序，可以通过PHP，JAVA，Python，C，C#等系统语言来向MQTT发送相关消息。**随着移动互联网的发展，MQTT由于开放源代码，耗电量小等特点，将会在移动消息推送领域会有更多的贡献，在物联网领域，传感器与服务器的通信，信息的收集，MQTT都可以作为考虑的方案之一。**

**MQTT协议是为大量计算能力有限，且工作在低带宽、不可靠的网络的远程传感器和控制设备通讯而设计的协议，它具有以下主要的几项特性：**

```
1、使用发布/订阅消息模式，提供一对多的消息发布，解除应用程序耦合；
2、对负载内容屏蔽的消息传输；
3、使用 TCP/IP 提供网络连接；
4、小型传输，开销很小（固定长度的头部是 2 字节），协议交换最小化，以降低网络流量；
5、使用 Last Will 和 Testament 特性通知有关各方客户端异常中断的机制； -- 遗嘱消息
6、有三种消息发布服务质量：
	“至多一次”，消息发布完全依赖底层 TCP/IP 网络。会发生消息丢失或重复。这一级别可用于如下情况，环境传感器数据，丢失一次读记录无所谓，因为不久后还会有第二次发送。
	“至少一次”，确保消息到达，但消息重复可能会发生。
	“只有一次”，确保消息到达一次。这一级别可用于如下情况，在计费系统中，消息重复或丢失会导致不正确的结果。（在实际编程中，只需要设置QoS值即可实现以上几种不同消息发布服务质量模式）
```



### MQTT 与 Kafka

[MQTT 与 Kafka对比](https://blog.csdn.net/unforgettable2010/article/details/107455228)
#### 定义
kafka是分布式消息队列或者叫分布式消息中间件，有时候会叫做一种MQ产品（Message Queue)，同类型的有RabbitMQ，ActiveMQ等等。
MQTT是一种即时消息传输协议，Message Queuing Telemetry Transport。

#### 场景
两者虽然都是从传统的Pub/Sub消息系统演化出来的，但是进化的方向不一样，以下是几个比较突出的点：
1. Kafka是为了数据集成的场景，与以往Pub/Sub消息总线不一样，通过分布式架构提供了海量消息处理、高容错的方式存储海量数据流、保证数据流的顺序等特性。
2. MQTT是为了物联网场景而优化，不但提供多个QoS选项（exact once、at least once、at most once），而且还有层级主题、遗嘱等等特性。


Kafka 虽然也是基于发布订阅范式的消息系统，但它同时也被称为“**分布式提交日志**”或者“**分布式流平台**”，它的最主要的作用还是**实现分布式持久化保存数据的目的**。Kafka 的数据单元就是消息，可以把它当作数据库里的一行“数据”或者一条“记录”来理解，Kafka 通过主题来进行分类，kafka 的生产者发布消息到某一特定主题上，由消费者去消费特定主题的消息，其实生产者和消费者就可以理解成发布者和订阅者，主题就好比数据库中的表，每个主题包含多个分区，分区可以分布在不同的服务器上，也就是说通过这种方式来实现分布式数据的存储和读取， kafka 分布式的架构利于读写系统的扩展和维护（比如说通过备份服务器来实现冗灾备份，通过架构多个服务器节点来实现性能的提升），在很多有大数据分析需求的大型企业，都会用到Kafka 去做数据流处理的平台。

而MQTT 最开始就是为物联网设备的网络接入而设计的，物联网设备大多都是性能低下，功耗较低的计算机设备，而且网络连接的质量也是不可靠的，所以在设计协议的时候最需要考虑的几个重点是：

```
1、协议要足够轻量，方便嵌入式设备去快速地解析和响应。
2、具备足够的灵活性，使其足以为 IoT 设备和服务的多样化提供支持。
3、应该设计为异步消息协议而非同步协议，这么做是因为大多数 IoT 设备的网络延迟很可能非常不稳定，若使用同步消息协议，IoT 设备需要等待服务器的响应，对于为大量的 IoT 设备提供服务这一情景，显然是非常不现实的。
4、必须是双向通信，服务器和客户端应该可以互相发送消息。
```

MQTT 协议完美地解决了上述几点要求，并且最新版的 MQTT v5.0 协议做了很多优化，使其协议相比过去的 v3.1.1 版本具备更强大的灵活性以及对带宽的更少占用。

要说基于 MQTT 协议的消息 broker 和 Kafka 的区别的话，EMQ君认为还是在于它们的侧重点不同，**Kafka 的侧重点在于数据的存储和读取，针对实时性比较高的流式数据处理场景；而 MQTT broker 的侧重点在于客户端和服务器的通信。**

MQTT broker 与 Kafka 所采用的消息交换范式是如此相近，将其两者结合起来使用显然是一个非常不错的主意，事实上，很多 MQTT broker，诸如EMQ X已经实现了 MQTT broker 与 Kafka的桥接。MQTT broker 用来快速的对大量物联网设备发来的消息做接收处理响应，而Kafka 对这些大量的数据做采集存储，交给数据分析人员来分析处理消息，这一流程或许会成为未来物联网云平台的一大通用范式。



## MQTT broker(服务端)

### **热门的MQTT Broker**

**apache-apollo-1.7.1-windows-distro恨老了，已经不维护了，不要使用这个代理。以下是几个热门的MQTT Broker**

| 对比项目   | EMQ                                                          | HiveMQ                                                       | VerneMQ                                                      | ActiveMQ                                                     | Mosquitto                                          |
| :--------- | :----------------------------------------------------------- | :----------------------------------------------------------- | :----------------------------------------------------------- | :----------------------------------------------------------- | :------------------------------------------------- |
| License    | 开源+商业版                                                  | 开源+商业版                                                  | 开源+商业版                                                  | 开源                                                         | 开源                                               |
| 公司/社区  | EMQ                                                          | HiveMQ                                                       | VerenMQ                                                      | Apache 基金会                                                | Eclipse 基金会                                     |
| 开源协议   | Apache License 2.0                                           | Apache License 2.0                                           | Apache License 2.0                                           | Apache License 2.0                                           | EPL/EDL licensed                                   |
| 开发团队   | 杭州映云科技有限公司                                         | dc-square 股份有限公司，德国                                 | [Octavo Labs AG，瑞士](https://octavolabs.com/)              | Apache 项目维护者                                            | Eclipse 开源社区                                   |
| 开发语言   | Erlang                                                       | Java                                                         | Erlang                                                       | Java                                                         | C                                                  |
| 项目历史   | 2012年开始开源，2016年开始商业化                             | 2013 年成立，一直以闭源方式向客户提供软件，2019 年开源       | 提供基于开源的商业化定制服务                                 | 2004 由 LogicBlaze 创建；原本规划的 ActiveMQ 的下一代开源项目 Apollo 已经不活动（4年没有代码更新） |                                                    |
| 集群架构   | 支持                                                         | 仅企业版                                                     | 支持                                                         | 支持                                                         | 不支持（有伪集群实现）                             |
| 系统部署   | 物理机、虚拟机、K8S                                          | 物理机、虚拟机、K8S                                          | 物理机、虚拟机、K8S                                          | 物理机、虚拟机、容器                                         | 物理机、虚拟机、容器                               |
| 支持协议   | MQTT、CoAP、MQTT-SN、WebSocket、TCP、UDP、LwM2M              | MQTT                                                         | MQTT                                                         | JMS、Openwire、Stomp、AMQP、MQTT、WebSocket XMPP             | MQTT、WebSocket                                    |
| 系统性能   | 单机性能较高，单机支持百万级并发，集群支持千万级并发         | 集群支持千万级并发                                           | 集群支持百万级并发                                           | 支持集群                                                     | 单机10W                                            |
| MQTT       | v3.1，v3.1.1，v5.0                                           | v3.1，v3.1.1，v5.0                                           | v3.1，v3.1.1，v5.0                                           | v3.1                                                         | v3.1，v3.1.1，v5.0                                 |
| 边缘计算   | EMQ X Edge 支持树莓派，ARM 等架构，支持数据同步到云服务 Azure IoT Hub AWS | 不支持                                                       | 不支持                                                       | 不支持                                                       | 支持（自身比较轻量）                               |
| 安全与认证 | TLS/DTLS、X.509证书、JWT、OAuth2.0、应用协议（ID/用户名/密码）、数据库与接口形式的认证与 ACL 功能（LDAP、DB、HTTP） | TLS/DTLS、X.509证书、JWT、OAuth2.0、应用协议（ID/用户名/密码）、配置文件形式的认证与 ACL 功能 | TLS/DTLS、X.509证书、配置文件形式的认证与 ACL 功能、数据库形式的认证与 ACL 功能，但支持数据库较少 | LDAP (JAAS)、Apache Shiro                                    | 等待                                               |
| 运行持久化 | 支持将消息数据持久化至外部数据库如 Redis、MySQL、PostgreSQL、MongoDB、Cassa、Dynamo 等，**需企业版**，开源版宕机则丢失 | 开源企业均支持本地持久化，采用磁盘系统，支持备份，导出备份   | 支持持久化至 Google LevelDB                                  | AMQ、KahaDB、JDBC、LevelDB                                   | 等待                                               |
| 扩展方式   | Webhook、Trigger、Plugin 等，支持 Erlang 与 Lua、Java、Python 扩展开发，支持 Webhook 开发，侵入性不强 | Trigger、Plugin 等，使用 Java 技术栈开发，提供方便开发的 SDK | Trigger、Plugin 等，支持 Erlang 与 Lua 扩展开发              | Java 扩展                                                    | 等待                                               |
| 数据存储   | 仅**企业版**适配数据库：Redis、Mysql、PostgreSQL、MongoDB、Cassandra、OpenTSDB、TimescaleDB、InfluxDB 适配消息队列：Kakfa、RabbitMQ、Pulsar 桥接模式：支持桥接至标准 MQTT 协议消息服务 开源版支持 HTTP 将数据同步、存储 | 适配数据库：无，提供 Java SDK 开发进行适配 消息队列：Kafka 桥接模式：支持桥接至标准 MQTT 协议消息服务 | 适配数据库：无，提供 Erlang 和 Lua 扩展开发 适配消息队列：无 桥接模式：支持桥接至标准 MQTT 协议消息服务 | 适配数据库：JDBC、KahaDB、LevelDB 适配消息队列：无 桥接模式：支持通过 JMS 桥接 | 等待                                               |
| 管理监控   | 支持可视化的 Dashboard，实现集群与节点的统一集中管理 支持第三方监控工具 Prometheus ，提供可视化 Grafana 界面模板 | 支持可视化的 HiveMQ Control Center，实现集群与节点统一管理 支持第三方监控工具 Prometheus ，可提供可视化 Grafana 界面 支持 InfluxDB 监控 | 内置简单状态管理可视化界面 支持第三方监控工具 Prometheus ，可提供可视化 Grafana 界面 | 支持可视化的监控界面 支持第三方监控工具 Prometheus ，可提供可视化 Grafana 界面 | 通过 MQTT 订阅系统主题                             |
| 规则引擎   | 支持规则引擎，基于 SQL 的规则引擎给予 Broker 超越一般消息中间件的能力。除了在接受转发消息之外，规则引擎还可以解析消息的格式（**企业版**）。 规则引擎由消息的订阅，发布，确认的事件触发，根据消息的负载来执行相应的动作，降低应用开发的复杂度。 | 不支持                                                       | 不支持                                                       | 不支持                                                       | 不支持                                             |
| 开发集成   | 支持通过 REST API 进行常用的业务管理操作如： 调整设置、获取 Broker 状态信息、进行消息发布、代理订阅与取消订阅、断开指定客户端、查看客户端列表、规则引擎管理、插件管理，提供 Java SDK、Python SDK 直接编码处理业务逻辑 | 无，提供 Java SDK 在应用系统在编码的层面操作进程，非常灵活但耦合性高 | 提供少量 REST API，用于监控与状态管理、客户端管理等。 缺乏代理订阅、业务管理等功能和 API | 提供少量队列管理 REST API                                    | 等待                                               |
| 适用场景   | 优势在于高并发连接与高吞吐消息的服务能力，以及物联网协议栈支持的完整性；扩展能力较强，无需过多开发 | 有一定高并发连接与高吞吐消息的服务能力，物联网协议栈的完整性较弱仅支持 MQTT 协议；缺乏开箱即用的功能插件，功能必须编码使用 | 基础的并发连接与高吞吐消息的服务能力，物联网协议栈的完整性较弱仅支持 MQTT 协议；扩展能力较差，基础的业务组件支持度不够，商业成熟度不足客户量较少，缺乏开箱即用的功能插件 | 核心是消息队列系统，主要用于支持异构应用之间的消息通信，比如用于企业消息总线等；后面支持了部分物联网协议。ActiveMQ 比较适合系统既要支持传统的异构应用之间需要通信，也需要支持小型物联网接入支持的用户。 | 轻量简便的 MQTT Broker，工控、网关或小规模接入项目 |

### EMQ X项目

**开源的MQTT Broker推建 EMQ X，中文资料很丰富，还有个CS客户端MQTTX，方便测试。B站视频课程**：https://www.bilibili.com/video/BV1o5411E7V1

[emqx: An Open-Source, Cloud-Native, Distributed MQTT Message Broker for IoT. ](https://github.com/emqx/emqx)

[MQTT X - Elegant Cross-platform MQTT 5.0 Desktop Client](https://github.com/emqx/MQTTX)

如果 emqx 从源码编译，`cd _build/emqx/rel/emqx`。 如果 emqx 通过 zip 包安装，则切换到 emqx 的根目录。

```
# Start emqx
./bin/emqx start

# Check Status
./bin/emqx_ctl status

# Stop emqx
./bin/emqx stop
```

*EMQ X* 启动，可以使用浏览器访问 [http://localhost:18083](http://localhost:18083/) 来查看 Dashboard



## C/C++ 编程(客户端)

### 编程实例

MQTT使用起来也十分容易，基本上就那四五个函数：MQTTClient_create（创建客户端）、MQTTClient_connect（连接服务端）、MQTTClient_publishMessage（客户端->服务端发送消息）、MQTTClient_subscribe（客户端订阅某个主题）等等。其中，很多异步回调函数，需要自己去实现，如:
```
MQTTAsync_setCallbacks(mqtt->_client, mqtt->_client, connlost, msgarrvd, NULL);
MQTTAsync_setCallbacks中:
connlost函数指针，是当MQTT意外断开链接时会回调的函数，由自己实现；
msgarrvd函数指针，是当服务器有消息推送回来时，客户端在此处接受服务端消息内容。
```
另外，就是一些函数执行是否成功的回调函数。有兴趣的可以看《浅谈C/C++回调函数（Callback）& 函数指针》文章，再了解以下回调函数。

```
mqtt->_conn_opts.onSuccess = onConnect;
mqtt->_conn_opts.onFailure = onConnectFailure;
```

最后，不得不说的就是，MQTT有些发送或者是订阅的内容时（某些函数中），在编程最好将参数中传进来的值在内存中拷贝一份再操作，笔者当时开发时，就是因为这样的问题，折腾了较长时间，后来在wireshark中发现数据包中根本没有内容，才知道是由于函数参数是指针形式，直接在异步中使用可能会发生一些未知的错误。

#### Synchronous publication example

```c
#include "stdio.h"
#include "stdlib.h"
#include "string.h"
#include "MQTTClient.h"
#define ADDRESS     "tcp://localhost:1883"
#define CLIENTID    "ExampleClientPub"
#define TOPIC       "MQTT Examples"
#define PAYLOAD     "Hello World!"
#define QOS         1
#define TIMEOUT     10000L
int main(int argc, char* argv[])
{
    MQTTClient client;
    MQTTClient_connectOptions conn_opts = MQTTClient_connectOptions_initializer;
    MQTTClient_message pubmsg = MQTTClient_message_initializer;
    MQTTClient_deliveryToken token;
    int rc;
    MQTTClient_create(&client, ADDRESS, CLIENTID,
        MQTTCLIENT_PERSISTENCE_NONE, NULL);
    conn_opts.keepAliveInterval = 20;
    conn_opts.cleansession = 1;
    if ((rc = MQTTClient_connect(client, &conn_opts)) != MQTTCLIENT_SUCCESS)
    {
        printf("Failed to connect, return code %d\n", rc);
        exit(EXIT_FAILURE);
    }
    pubmsg.payload = PAYLOAD;
    pubmsg.payloadlen = strlen(PAYLOAD);
    pubmsg.qos = QOS;
    pubmsg.retained = 0;
    MQTTClient_publishMessage(client, TOPIC, &pubmsg, &token);
    printf("Waiting for up to %d seconds for publication of %s\n"
            "on topic %s for client with ClientID: %s\n",
            (int)(TIMEOUT/1000), PAYLOAD, TOPIC, CLIENTID);
    rc = MQTTClient_waitForCompletion(client, token, TIMEOUT);
    printf("Message with delivery token %d delivered\n", token);
    MQTTClient_disconnect(client, 10000);
    MQTTClient_destroy(&client);
    return rc;
}
```

#### Asynchronous publication example

```c
#include "stdio.h"
#include "stdlib.h"
#include "string.h"
#include "MQTTClient.h"
#define ADDRESS     "tcp://localhost:1883"
#define CLIENTID    "ExampleClientPub"
#define TOPIC       "MQTT Examples"
#define PAYLOAD     "Hello World!"
#define QOS         1
#define TIMEOUT     10000L
volatile MQTTClient_deliveryToken deliveredtoken;
void delivered(void *context, MQTTClient_deliveryToken dt)
{
    printf("Message with token value %d delivery confirmed\n", dt);
    deliveredtoken = dt;
}
int msgarrvd(void *context, char *topicName, int topicLen, MQTTClient_message *message)
{
    int i;
    char* payloadptr;
    printf("Message arrived\n");
    printf("     topic: %s\n", topicName);
    printf("   message: ");
    payloadptr = message->payload;
    for(i=0; i<message->payloadlen; i++)
    {
        putchar(*payloadptr++);
    }
    putchar('\n');
    MQTTClient_freeMessage(&message);
    MQTTClient_free(topicName);
    return 1;
}
void connlost(void *context, char *cause)
{
    printf("\nConnection lost\n");
    printf("     cause: %s\n", cause);
}
int main(int argc, char* argv[])
{
    MQTTClient client;
    MQTTClient_connectOptions conn_opts = MQTTClient_connectOptions_initializer;
    MQTTClient_message pubmsg = MQTTClient_message_initializer;
    MQTTClient_deliveryToken token;
    int rc;
    MQTTClient_create(&client, ADDRESS, CLIENTID,
        MQTTCLIENT_PERSISTENCE_NONE, NULL);
    conn_opts.keepAliveInterval = 20;
    conn_opts.cleansession = 1;
    MQTTClient_setCallbacks(client, NULL, connlost, msgarrvd, delivered);
    if ((rc = MQTTClient_connect(client, &conn_opts)) != MQTTCLIENT_SUCCESS)
    {
        printf("Failed to connect, return code %d\n", rc);
        exit(EXIT_FAILURE);
    }
    pubmsg.payload = PAYLOAD;
    pubmsg.payloadlen = strlen(PAYLOAD);
    pubmsg.qos = QOS;
    pubmsg.retained = 0;
    deliveredtoken = 0;
    MQTTClient_publishMessage(client, TOPIC, &pubmsg, &token);
    printf("Waiting for publication of %s\n"
            "on topic %s for client with ClientID: %s\n",
            PAYLOAD, TOPIC, CLIENTID);
    while(deliveredtoken != token);
    MQTTClient_disconnect(client, 10000);
    MQTTClient_destroy(&client);
    return rc;
}
```

#### Asynchronous subscription example

```c
#include "stdio.h"
#include "stdlib.h"
#include "string.h"
#include "MQTTClient.h"
#define ADDRESS     "tcp://localhost:1883"
#define CLIENTID    "ExampleClientSub"
#define TOPIC       "MQTT Examples"
#define PAYLOAD     "Hello World!"
#define QOS         1
#define TIMEOUT     10000L
volatile MQTTClient_deliveryToken deliveredtoken;
void delivered(void *context, MQTTClient_deliveryToken dt)
{
    printf("Message with token value %d delivery confirmed\n", dt);
    deliveredtoken = dt;
}
int msgarrvd(void *context, char *topicName, int topicLen, MQTTClient_message *message)
{
    int i;
    char* payloadptr;
    printf("Message arrived\n");
    printf("     topic: %s\n", topicName);
    printf("   message: ");
    payloadptr = message->payload;
    for(i=0; i<message->payloadlen; i++)
    {
        putchar(*payloadptr++);
    }
    putchar('\n');
    MQTTClient_freeMessage(&message);
    MQTTClient_free(topicName);
    return 1;
}
void connlost(void *context, char *cause)
{
    printf("\nConnection lost\n");
    printf("     cause: %s\n", cause);
}
int main(int argc, char* argv[])
{
    MQTTClient client;
    MQTTClient_connectOptions conn_opts = MQTTClient_connectOptions_initializer;
    int rc;
    int ch;
    MQTTClient_create(&client, ADDRESS, CLIENTID,
        MQTTCLIENT_PERSISTENCE_NONE, NULL);
    conn_opts.keepAliveInterval = 20;
    conn_opts.cleansession = 1;
    MQTTClient_setCallbacks(client, NULL, connlost, msgarrvd, delivered);
    if ((rc = MQTTClient_connect(client, &conn_opts)) != MQTTCLIENT_SUCCESS)
    {
        printf("Failed to connect, return code %d\n", rc);
        exit(EXIT_FAILURE);
    }
    printf("Subscribing to topic %s\nfor client %s using QoS%d\n\n"
           "Press Q<Enter> to quit\n\n", TOPIC, CLIENTID, QOS);
    MQTTClient_subscribe(client, TOPIC, QOS);
    do 
    {
        ch = getchar();
    } while(ch!='Q' && ch != 'q');
    MQTTClient_disconnect(client, 10000);
    MQTTClient_destroy(&client);
    return rc;
}
```

