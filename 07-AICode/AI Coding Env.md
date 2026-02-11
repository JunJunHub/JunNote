
AI Vibe Coding 环境搭建记录。

## 00 基础环境配置(Win11)

### **PowerShell 终端权限配置**

智能助手 Win 平台 PowerShell 终端执行一些命令总是报错，一般有两个原因：
1、终端权限问题
2、中文编码问题

**配置 profile 启动终端时自动设置权限**
`E:\Users\Tiger\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1`
```
# PowerShell 启动配置
Write-Host "🚀 PowerShell 已就绪 | ExecutionPolicy: $(Get-ExecutionPolicy)" -ForegroundColor Cyan

# 自动修复（以防被重置）
if ((Get-ExecutionPolicy) -eq "Restricted") {
    Write-Host "⚠️  检测到执行策略受限，正在修复..." -ForegroundColor Yellow
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    Write-Host "✅ 已重置为 RemoteSigned。请重启终端。" -ForegroundColor Green
}
```

### Git Bash

安装 Git for windows 会安装 Git 版本管理工具和 Git Bash 终端

### **Node.js**
智能助手本地安装使用很多 MCP 服务器工具都依赖 Node.js 环境运行，需要执行 npm、npx 命令
版本应选择较新的版本，一些 MCP 工具都依赖新版本

**安装 nvm-windows:**
1. 访问 [https://github.com/coreybutler/nvm-windows/releases](https://github.com/coreybutler/nvm-windows/releases)
2. 下载 `nvm-setup.exe` 并安装
使用 nvm 安装管理 Node.js 版本
```shell
# 查看可安装的版本
nvm list available

# 安装指定版本
nvm install 20.11.0
nvm install 18.19.0

# 查看已安装版本
nvm list

# 切换版本
nvm use 20.11.0

# 设置默认版本
nvm alias default 20.11.0

# 卸载版本
nvm uninstall 18.19.0
```

### **Python**
智能助手常用 pip 命令安装一些依赖，且有写本地运行的 MCP 服务器是基于 Python 环境运行
使用 pyenv-win (推荐) 安装管理 Python 版本

**安装 pyenv-win:**
```shell
# 使用 PowerShell (管理员模式)
Invoke-WebRequest -UseBasicParsing -Uri "https://raw.githubusercontent.com/pyenv-win/pyenv-win/master/pyenv-win/install-pyenv-win.ps1" -OutFile "./install-pyenv-win.ps1"; &"./install-pyenv-win.ps1"
```
pyenv 常用命令
```shell
# 查看可安装版本
pyenv install --list

# 安装指定版本
pyenv install 3.12.1
pyenv install 3.11.7

# 查看已安装版本
pyenv versions

# 设置全局版本
pyenv global 3.12.1

# 设置当前目录版本
pyenv local 3.11.7

# 卸载版本
pyenv uninstall 3.11.7
```

### **Scoop**
统一的SDK版本管理方案，使用 Scoop 统一管理所有工具(Node.js、Python、JDK)
```shell
# 安装 Scoop
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
irm get.scoop.sh | iex

# 添加必要的 buckets
scoop bucket add extras
scoop bucket add java
scoop bucket add versions

# 安装版本管理器
scoop install nvm
scoop install pyenv
scoop install openjdk17

# nvm 管理器安装特定版本
nvm install 20.11.0

# pyenv 管理器安装特定版本python
pyenv install 3.14.2
```


## 01 AI Model

### 国内大模型

#### Kimi

#### Qewn

### 国外大模型

#### Claude

##### Claude Code



## 02 AI Mcp
## 02 AI Skill

## 02 AI Spec



## 03 IDE 配置

CMake 编译Qt工程指定Qt安装路径（CMake配置参数非编译参数）
```
-DCMAKE_INSTALL_PREFIX:PATH=F:/project/QtProject/KVMGUI/bin/Debug \
-DQT_DIR="D:/SDKTools/Qt/Qt5.15/5.15.2/mingw81_64" \
-DCMAKE_PREFIX_PATH="D:/SDKTools/Qt/Qt5.15/5.15.2/mingw81_64"
```
### AI Agent 插件

这些插件一般都支持 VS Code 和 IDEA
#### cline

#### 通义灵码

#### claude plugin
、
### AI IDEA
有很多，功能都相似，记录两个学习阶段用的
#### Trae

#### Cursor



### AI Shell
命令行工具
#### Claude Code
#### Gemini CLI


