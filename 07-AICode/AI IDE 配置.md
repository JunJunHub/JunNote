
## 01 基础环境配置(Win11)

**PowerShell 终端权限配置**

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

**Node.js**
智能助手本地安装使用很多 MCP 服务器工具都依赖 Node.js 环境运行，需要执行 npm、npx 命令

**Python**
智能助手常用 pip 命令安装一些依赖，且有写本地运行的 MCP 服务器是基于 Python 环境运行


## 02 IDE 配置

CMake 编译Qt工程指定Qt安装路径（CMake配置参数非编译参数）
```
-DCMAKE_INSTALL_PREFIX:PATH=F:/project/QtProject/KVMGUI/bin/Debug \
-DQT_DIR="D:/SDKTools/Qt/Qt5.15/5.15.2/mingw81_64" \
-DCMAKE_PREFIX_PATH="D:/SDKTools/Qt/Qt5.15/5.15.2/mingw81_64"
```

### VS Code

### Trae

### Golang & CLion


