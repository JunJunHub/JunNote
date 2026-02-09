
**PowerShell 终端配置**

Win 平台 PowerShell 终端执行一些命令总是报错，一般有两个原因：
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

# VS Code

# Trae

# Golang & CLion

