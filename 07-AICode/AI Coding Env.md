# AI Coding 环境搭建记录

本文档记录 AI 辅助编程环境的搭建与配置，包括基础开发环境、AI 模型、MCP 工具、IDE 插件和命令行工具等。

---

## 00 基础环境配置 (Windows 11)

### 终端环境

#### PowerShell 配置

AI 智能助手在 Windows 平台执行命令时常遇到两个问题：
1. **终端权限问题** - PowerShell 默认执行策略为 Restricted，会阻止脚本执行
2. **中文编码问题** - 终端可能不支持 UTF-8 编码

**配置 PowerShell Profile**

编辑配置文件 `~\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1`（如不存在需新建）：

```powershell
# PowerShell 启动配置
Write-Host "🚀 PowerShell 已就绪 | ExecutionPolicy: $(Get-ExecutionPolicy)" -ForegroundColor Cyan

# 自动修复执行策略（以防被重置）
if ((Get-ExecutionPolicy) -eq "Restricted") {
    Write-Host "⚠️  检测到执行策略受限，正在修复..." -ForegroundColor Yellow
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    Write-Host "✅ 已重置为 RemoteSigned。请重启终端。" -ForegroundColor Green
}

# 设置控制台编码为 UTF-8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8
```

**执行策略说明**

| 策略 | 说明 |
|------|------|
| Restricted | 默认策略，不允许运行任何脚本 |
| RemoteSigned | 本地脚本可运行，远程脚本需签名 |
| Unrestricted | 允许所有脚本运行（不推荐） |

#### Git Bash

安装 [Git for Windows](https://git-scm.com/download/win) 可同时获得：
- Git 版本控制工具
- Git Bash 终端（类 Unix 环境）

### 版本管理工具

#### nvm-windows (Node.js 版本管理)

**使用场景**
- AI 助手本地运行的 MCP 服务器工具多依赖 Node.js
- 需要执行 `npm`、`npx` 命令
- 不同项目可能需要不同 Node.js 版本

**安装步骤**
1. 访问 [nvm-windows releases](https://github.com/coreybutler/nvm-windows/releases)
2. 下载 `nvm-setup.exe` 并安装

**常用命令**
```shell
# 查看可安装的版本
nvm list available

# 安装指定版本（LTS 版本推荐用于生产）
nvm install 20.11.0
nvm install 18.19.0

# 查看已安装版本
nvm list

# 切换版本
nvm use 20.11.0

# 设置默认版本（新终端自动生效）
nvm alias default 20.11.0

# 卸载版本
nvm uninstall 18.19.0
```

#### pyenv-win (Python 版本管理)

**使用场景**
- AI 助手常用 `pip` 命令安装依赖
- 本地运行的 MCP 服务器有基于 Python 的
- 不同项目需要不同 Python 版本

**安装步骤**
```powershell
# 使用 PowerShell (管理员模式)
Invoke-WebRequest -UseBasicParsing -Uri "https://raw.githubusercontent.com/pyenv-win/pyenv-win/master/pyenv-win/install-pyenv-win.ps1" -OutFile "./install-pyenv-win.ps1"
&"./install-pyenv-win.ps1"
```

**常用命令**
```shell
# 查看可安装版本
pyenv install --list

# 安装指定版本
pyenv install 3.12.1
pyenv install 3.11.7

# 查看已安装版本
pyenv versions

# 设置全局版本（系统默认）
pyenv global 3.12.1

# 设置当前目录版本（项目级别）
pyenv local 3.11.7

# 卸载版本
pyenv uninstall 3.11.7
```

#### Scoop (统一包管理器)

**使用场景**
- 统一管理开发工具和环境
- 支持安装 Node.js、Python、JDK 等多种工具
- 无需手动配置环境变量

**安装步骤**
```powershell
# 设置执行策略（仅需一次）
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

# 安装 Scoop
irm get.scoop.sh | iex

# 添加常用 buckets（软件源）
scoop bucket add extras    # 额外软件
scoop bucket add java      # Java 相关
scoop bucket add versions  # 多版本软件
```

**安装开发工具**
```shell
# 安装版本管理器
scoop install nvm
scoop install pyenv
scoop install openjdk17

# 使用 nvm 安装特定 Node.js 版本
nvm install 20.11.0

# 使用 pyenv 安装特定 Python 版本
pyenv install 3.14.2
```

---

## 01 AI 模型

### 国内大模型

#### Kimi (月之暗面)

- **官网**: https://kimi.moonshot.cn
- **特点**: 长文本处理能力强，支持 200 万字上下文
- **适用场景**: 长文档阅读、代码分析、技术方案设计

#### 通义千问 (阿里云)

- **官网**: https://qwen.aliyun.com
- **特点**: 开源模型丰富，支持本地部署
- **适用场景**: 代码补全、技术问答、API 集成

#### DeepSeek

- **官网**: https://www.deepseek.com
- **特点**: 性价比高，代码能力强
- **适用场景**: 代码编写、调试、算法实现

#### 智谱清言 (智谱 AI)

- **官网**: https://chatglm.cn
- **特点**: 开源模型丰富（ChatGLM 系列），API 兼容 Claude 协议
- **适用场景**: 代码生成、智能对话、API 集成开发

### 国外大模型

#### Claude (Anthropic)

**特点**
- 推理能力强，适合复杂任务
- 代码能力突出
- 支持大上下文窗口

**模型系列**

| 模型 | 用途 |
|------|------|
| Haiku | 快速响应，简单任务 |
| Sonnet | 平衡性能与速度，通用场景 |
| Opus | 最强能力，复杂任务 |

#### GPT-4 (OpenAI)

**特点**
- 综合能力均衡
- 生态完善，插件丰富
- 代码能力强

#### Gemini (Google)

**特点**
- 多模态能力强
- 代码生成质量高
- 免费层级可用

---

## 02 MCP 工具

MCP (Model Context Protocol) 是一个开放协议，允许 AI 模型与外部工具和系统交互。

### 常用 MCP 服务器

#### 文件系统操作
- 读取、写入、搜索文件

#### 数据库交互
- 连接 SQLite、PostgreSQL 等数据库
- 执行 SQL 查询

#### Web 操作
- 发送 HTTP 请求
- 爬取网页内容

#### Git 操作
- 查看代码变更
- 管理 Git 仓库

### 安装与配置

```shell
# 安装 MCP 服务器
npm install -g @modelcontextprotocol/server-filesystem
npm install -g @modelcontextprotocol/server-git

# 配置 MCP 客户端（根据具体工具配置）
```

---

## 03 AI Skills

Skills 是可复用的能力模块，提供专门的领域知识和功能。

### 常用 Skills

#### /commit
自动生成规范的 Git commit message

#### /review-pr
审查 Pull Request，提供改进建议

#### /test
生成测试代码并运行测试

#### /refactor
重构代码，优化结构和可读性

### 自定义 Skills

根据项目需求创建自定义 Skills，封装特定的工作流程和最佳实践。

---

## 04 AI IDE 插件

### VS Code 插件

#### Cline
- 开源 AI 助手插件
- 支持多模型切换
- 自动编辑和提交代码

#### 通义灵码
- 阿里云官方插件
- 深度集成 VS Code
- 支持代码补全和解释

#### Continue
- 开源免费
- 支持多种 AI 模型
- 上下文感知能力强

### JetBrains 插件 (IDEA / PyCharm)

#### 通义灵码
- 支持 JetBrains 全家桶
- 智能代码补全
- 单元测试生成

#### GitHub Copilot
- GitHub 官方插件
- 代码补全能力强
- 多语言支持

---

## 05 AI 专用 IDE

### Cursor

**特点**
- 基于 VS Code 构建，界面熟悉
- 深度集成 Claude 3.5
- 支持 AI 直接编辑文件
- 快捷键驱动的交互方式

**适用场景**
- 新项目开发
- 快速原型开发
- 代码重构

### Trae

**特点**
- 国内开发者友好
- 支持中文交互
- 集成多种 AI 模型
- 适合团队协作

**适用场景**
- 学习 AI 辅助编程
- 中文项目开发

### Windsurf (Codeium)

**特点**
- 完全免费
- 基于 VS Code
- AI 上下文感知强
- 支持 Cursor 风格操作

**适用场景**
- 预算有限的项目
- 个人学习使用

---

## 06 AI 命令行工具

### Claude Code CLI

[快速入门 - Claude Code Docs](https://code.claude.com/docs/zh-CN/quickstart)

**安装**
```shell
# 使用 Windows PowerShell 安装（注意先解决VPN网络问题）
irm https://claude.ai/install.ps1 | iex
```

**配置**

配置使用国内 GLM 大模型 [Claude Code - 智谱AI开放文档](https://docs.bigmodel.cn/cn/coding-plan/tool/claude)

```json
# 编辑或新增 `settings.json` 文件
# MacOS & Linux 为 `~/.claude/settings.json`
# Windows 为`用户目录/.claude/settings.json`
# 新增或修改里面的 env 字段
# 注意替换里面的 `your_zhipu_api_key` 为您上一步获取到的 API Key
{
  "env": {
    "ANTHROPIC_AUTH_TOKEN": "366c26d548094461911ff3616cca9299.fuBVSnKlqU5nJhSU",
    "ANTHROPIC_BASE_URL": "https://open.bigmodel.cn/api/anthropic",
    "API_TIMEOUT_MS": "3000000",
    "CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC": 1,
    "ANTHROPIC_DEFAULT_HAIKU_MODEL": "glm-5",
    "ANTHROPIC_DEFAULT_SONNET_MODEL": "glm-5",
    "ANTHROPIC_DEFAULT_OPUS_MODEL": "glm-5"
  }
}


# 再编辑或新增 `.claude.json` 文件
# MacOS & Linux 为 `~/.claude.json`
# Windows 为`用户目录/.claude.json`
# 新增 `hasCompletedOnboarding` 参数
{
  "hasCompletedOnboarding": true
}
```

运行 claude 检查大模型配置结果

[[image.png]]

**常用命令**
```shell
# 启动交互式会话
claude

# 查看配置状态
claude /status

# 执行单次命令
claude "帮我重构这个函数"
```

**获取 API Token**
- 智谱 AI 开放平台: https://open.bigmodel.cn/
- Claude 官网: https://console.anthropic.com/

### Aider CLI

**特点**
- 专注于代码编辑
- 支持 Git 集成
- 可本地运行开源模型

**安装**
```shell
pip install aider-chat
```

**使用**
```shell
# 启动 aider
aider

# 添加文件到上下文
aider file1.py file2.py

# 使用特定模型
aider --model gpt-4
```

### Gemini CLI

**安装**
```shell
npm install -g @google-ai/generative-ai-cli
```

**使用**
```shell
# 配置 API Key
gemini config set API_KEY your-key

# 启动交互式会话
gemini chat

# 生成代码
gemini code "写一个排序算法"
```

---

## 07 CMake / Qt 工程配置

### Qt 工程编译配置

在 CMake 配置时指定 Qt 安装路径（注意：这是 CMake 配置参数，非编译参数）：

```cmake
# 命令行配置示例
cmake -B build `
  -DCMAKE_INSTALL_PREFIX:PATH="F:/project/QtProject/KVMGUI/bin/Debug" `
  -DQT_DIR="D:/SDKTools/Qt/Qt5.15/5.15.2/mingw81_64" `
  -DCMAKE_PREFIX_PATH="D:/SDKTools/Qt/Qt5.15/5.15.2/mingw81_64"
```

**参数说明**

| 参数 | 说明 |
|------|------|
| `CMAKE_INSTALL_PREFIX` | 安装输出目录 |
| `QT_DIR` | Qt 根目录 |
| `CMAKE_PREFIX_PATH` | Qt 模块查找路径 |

---

## 08 资源链接

### 官方文档
- [Claude Code 文档](https://docs.anthropic.com/claude/docs/claude-code)
- [Claude Code - 智谱AI文档](https://docs.bigmodel.cn/cn/coding-plan/tool/claude)
- [MCP 协议规范](https://modelcontextprotocol.io/)

### 工具下载
- [nvm-windows](https://github.com/coreybutler/nvm-windows/releases)
- [pyenv-win](https://github.com/pyenv-win/pyenv-win)
- [Scoop](https://scoop.sh/)
- [Git for Windows](https://git-scm.com/download/win)

### AI 平台
- [Claude](https://claude.ai)
- [ChatGPT](https://chat.openai.com)
- [通义千问](https://qwen.aliyun.com)
- [Kimi](https://kimi.moonshot.cn)
- [DeepSeek](https://www.deepseek.com)
- [智谱清言](https://chatglm.cn)

---

*最后更新: 2026-02-12*
