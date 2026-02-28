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
