
阅读此项目代码，梳理项目框架、功能、技术栈以及使用的开源组件、目录结构、主要文件和文件夹、如何配置运行项目; 输出一份 README.md

评价此项目代码风格是否规范; 结合项目的代码风格，给出代码规范建议，并生成一份出可供 AI 辅助编程使用的统一开发规则; 编码规则放在项目跟目录下，命名为 dev_standard.md
dev_standard.md

开启新会话，沟通待做事项
TODO.md


# 1、梳理项目框架


# 2、整理项目规范

`coderule.md`

# 3、编程规则配置



## 3.1 通义灵码

将整理的开发规范，自动添加至本项目 .lingma/rules

[项目专属规则配置与使用-智能编码助手通义灵码-阿里云 (aliyun.com)](https://help.aliyun.com/zh/lingma/user-guide/rules?spm=a2c4g.11186623.0.preDoc.4683e95aT6QBQX)

## 3.2 TODO



# 生成编码规范示例

# Go语言开发规范（修订版）  
  
## 1. 命名规范  
  
### 1.1 包名  
- 使用小写字母，避免下划线  
- 包名应简洁明了，反映包的主要功能  
- 示例：`service`, `model`, `api`, `define`  
  
### 1.2 变量和函数名  
- 采用驼峰命名法（camelCase）  
- 导出的标识符首字母大写，非导出的首字母小写  
- 变量名应具有描述性，避免使用缩写  
- 示例：  
  - 好的：`userId`, `channelList`, `getUserInfo`  
  - 避免：`uid`, `chlList`, `getUInfo`  
  
### 1.3 常量  
- 使用大写字母和下划线分隔  
- 枚举常量使用有意义的前缀  
- 示例：`MsgTypeText`, `ReceiverTypeUser`, `MsgStatusUnRead`  
  
### 1.4 接口  
- 有两种命名方式：  
  - 以`er`结尾：`Reader`, `Writer`  
  - 以`I`开头：`IChatMsg`, `IDataProvider`  
  
### 1.5 结构体  
- 结构体名使用驼峰命名，首字母大写  
- 字段名使用驼峰命名，首字母大写（导出）或小写（非导出）  
- 示例：`MpuChatMsgSelectReq`, `MpuChatMsgList`  
  
## 2. 注释规范  
  
### 2.1 代码注释  
- 每个导出的函数和方法都必须有注释  
- 注释应描述函数的功能、参数和返回值  
- 使用中文注释，确保清晰易懂  
- 示例：  
```go  
// GetList 查询消息列表(按会话查询双向消息)  
// @param1 ctx context.Context "上下文信息"  
// @param2 req *define.MpuChatMsgSelectReq "查询请求参数"  
// @return1 result *define.MpuChatMsgList "查询结果"  
// @return2 err error "错误信息"  
func (s *chatMsgImpl) GetList(ctx context.Context, req *define.MpuChatMsgSelectReq) (result *define.MpuChatMsgList, err error) {  
    // ...
}
```  
  
### 2.2 API注释  
- 使用Swagger注释规范  
- 包含标签、参数说明、响应说明  
- 示例：  
```go  
// Get 查询消息列表  
// @summary 消息列表分页获取  
// @tags    消息管理  
// @Param   authorization header string true "Bearer Token"  
// @Param   conversationId query string false "会话ID"  
// @Param   senderId       query int64  false "发送者ID"  
// @Param   receiverId     query int64  false "接收者ID"  
// @Param   msgType        query int    false "消息类型"  
// @Param   beginTime      query string false "消息发送时间范围-起始"  
// @Param   endTime        query string false "消息发送时间范围-结束"  
// @Param   pageNum        query int    true  "当前页码"  
// @Param   pageSize       query int    true  "每页展示条数"  
// @Produce json  
// @Success 200 {object} response.Response{data=define.MpuChatMsgList} "消息信息列表"  
// @Failure 500 {object} response.Response "请求参数错误"  
// @Router  /chat/msg [GET]  
```  
  
### 2.3 常量注释  
- 常量定义后添加中文说明  
- 示例：  
```go  
// 消息类型枚举  
const (  
    MsgTypeText      = 1 // 文本消息  
    MsgTypeImage     = 2 // 图片消息  
    MsgTypeVoice     = 3 // 语音消息  
    MsgTypeVideo     = 4 // 视频消息  
    MsgTypeFile      = 5 // 文件消息  
    MsgTypePlot      = 6 // 标绘指令消息  
    MsgTypeSnapShare = 7 // 快照共享  
    MsgTypeKvmPush   = 8 // 坐席推送消息  
)  
```  
  
## 3. 代码格式化  
  
### 3.1 缩进  
- 使用4个空格缩进，不使用Tab  
- 使用`gofmt`进行代码格式化  
  
### 3.2 行长度  
- 每行代码不超过120个字符  
- 长的参数列表或条件判断应换行  
  
### 3.3 空行  
- 函数之间使用一个空行分隔  
- 函数内的逻辑块之间使用一个空行分隔  
- 结构体字段之间的空行可根据逻辑分组使用  
  
## 4. 错误处理  
  
### 4.1 错误返回  
- 函数通常最后一个返回值是error  
- 统一使用`gerror`进行错误包装  
- 示例：  
```go  
if err != nil {  
    return nil, gerror.WrapCode(errcode.ErrCommonOperationFailed, err)
}
```  
  
### 4.2 错误码使用  
- 定义统一的错误码管理模块  
- 不直接返回错误信息，而是返回错误码  
  
### 4.3 异常处理  
- 使用defer/panic/recover机制处理可能的异常  
- 推荐使用`g.Try()`封装业务逻辑  
  
## 5. 函数设计  
  
### 5.1 函数长度  
- 单个函数不超过50行  
- 过长的函数应拆分为多个小函数  
  
### 5.2 参数数量  
- 函数参数不超过5个  
- 参数过多时使用结构体封装  
  
### 5.3 单一职责  
- 每个函数只负责一个明确的功能  
- 复杂逻辑应拆分为多个小函数  
  
## 6. 结构体和方法  
  
### 6.1 结构体定义  
- 结构体字段使用驼峰命名  
- 每个字段都要有JSON标签和描述注释  
- ORM标签和JSON标签并存  
- 示例：  
```go  
// MpuChatMsgPushReq 发送消息请求参数  
type MpuChatMsgPushReq struct {  
    MsgType           int         `json:"msgType"`           // 消息类别: 1-文本 2-图片 3-语音 4-视频 5-文件 6-标绘指令 7-快照共享 8-坐席推送  
    MsgContent        string      `json:"msgContent"`        // 消息内容  
    MsgAttribute      interface{} `json:"msgAttribute"`      // 附加属性信息json格式参数可扩展,不同类型的消息有不同的属性  
    ReceiverType      int         `json:"receiverType"`      // 接收者类别（1-用户 2-群组 3-席位）  
    ReceiverId        string      `json:"receiverId"`        // 接收者ID  
    ReceiverCascadeId string      `json:"receiverCascadeId"` // 接收者所属级联平台ID  
}  
```  
  
### 6.2 方法接收器  
- 使用有意义的接收器名称，通常是类型的首字母  
- 示例：`func (s *chatMsgImpl) GetList(...)`  
  
### 6.3 结构体方法  
- 按照功能分组组织方法  
- 相关的方法放在一起  
- 使用空行分隔不同的逻辑块  
  
## 7. 接口设计  
  
### 7.1 接口定义  
- 接口名以大写字母I开头  
- 接口方法使用有意义的名称  
- 示例：  
```go  
type IChatMsg interface {  
    GetList(ctx context.Context, req *define.MpuChatMsgSelectReq) (result *define.MpuChatMsgList, err error)
    GetOrdersList(ctx context.Context, req *define.MpuChatMsgSelectReq) (result *define.MpuChatMsgList, err error)
    Delete(ctx context.Context, msgIds []string) (count int, err error)
    GetConversations(ctx context.Context, req *define.MpuChatConversationSelectReq) (result *define.MpuChatConversationList, err error)
    // ...
}
```  
  
### 7.2 接口实现  
- 实现接口的结构体使用impl后缀  
- 示例：`chatMsgImpl` 实现 `IChatMsg` 接口  
  
## 8. 数据库查询  
  
### 8.1 查询构建  
- 使用GoFrame的ORM进行数据库操作  
- 使用别名简化复杂查询  
- 示例：  
```go  
m := dao.MpuChatMsg.Ctx(ctx).As("t")  
m = m.Where(dao.MpuChatMsg.Columns.ConversationId, req.ConversationId)  
```  
  
### 8.2 分页查询  
- 使用统一的分页处理逻辑  
- 返回完整的分页信息  
- 示例：  
```go  
pageInfo := page.CreatePaging(req.PageNum, req.PageSize, total)  
result = &define.MpuChatMsgList{  
    Page:  pageInfo.PageNum,    Size:  pageInfo.PageSize,    Total: pageInfo.Total,}  
```  
  
## 9. 日志记录  
  
### 9.1 日志级别  
- 使用统一的日志记录器  
- 根据重要性选择合适的日志级别  
- 示例：  
```go  
Logger().Info("Query message conversation list request: ", pageInfo)  
Logger().Error(ctx, fmt.Sprintf("错误信息: %v", err))  
```  
  
### 9.2 日志内容  
- 记录关键的操作信息  
- 包含必要的上下文信息  
- 避免记录敏感信息  
  
## 10. 测试规范  
  
### 10.1 单元测试  
- 每个重要的函数都应该有对应的单元测试  
- 测试文件命名：`*_test.go`  
- 测试函数命名：`TestFunctionName`  
  
### 10.2 测试覆盖率  
- 新功能的测试覆盖率不低于80%  
- 修复bug时增加相应的测试用例  
  
## 11. Git提交规范  
  
### 11.1 提交信息格式  
- 类型(作用域): 描述  
- 类型包括：feat、fix、docs、style、refactor、test、chore  
- 示例：`feat(chat): 添加消息发送功能`  
  
### 11.2 作用域  
- 限制在项目模块范围内：api、service、model、dao等  
  
## 12. 项目结构规范  
  
### 12.1 模块划分  
- 按照业务功能进行模块划分  
- 每个模块包含api、service、model、dao、define子目录  
  
### 12.2 依赖关系  
- 上层模块可以依赖下层模块，但不能反向依赖  
- 避免循环依赖  
  
## 13. 安全规范  
  
### 13.1 输入验证  
- 所有外部输入都需要进行验证  
- 使用GoFrame的验证器或自定义验证逻辑  
  
### 13.2 SQL注入防护  
- 使用ORM的参数化查询  
- 避免字符串拼接SQL  
  
### 13.3 XSS防护  
- 输出到前端的数据需要进行转义  
- 使用GoFrame的安全函数