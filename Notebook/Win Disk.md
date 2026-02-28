**Win11 C 盘存储空间优化策略**
1、修改部分软件安装目录（有些软件支持直接修改，有些需要先卸载重新安装）
2、配置 `桌面` `下载` `文档` `音乐` `图片` `视频` 数据存储路径
3、CMD 控制台迁移用户数据

可先查看哪个路径数据量大，例如：`AppData`  `.trae`  `.trae-cn`，按以下方式迁移数据至其他分区
```
:: 1. 复制原数据到 F 盘（如果还没做） 
robocopy "C:\Users\李永军\.lingma" "F:\Users\LiYongJun\.lingma" /E /COPYALL

:: 2. 删除 C 盘原文件夹 
rmdir /s /q "C:\Users\李永军\.lingma" 

:: 3. 创建目录联接（Junction） 
mklink /J "C:\Users\李永军\.lingma" "F:\Users\LiYongJun\.lingma"
```

注：以上方式，在装机时即可预先配置