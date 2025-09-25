# OneAnime Flatpak 打包指南

## 📋 概述

本目录包含将 OneAnime 打包成 Flatpak 的所有必要文件。

## 🗂️ 文件说明

- `com.zqigolden.oneanime.yaml` - Flatpak manifest 配置文件
- `com.zqigolden.oneanime.appdata.xml` - AppStream 元数据文件
- `build-flatpak.sh` - 自动化构建脚本
- `README.md` - 本说明文件

## 🔧 环境要求

### 安装 Flatpak 和构建工具
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install flatpak flatpak-builder

# Fedora
sudo dnf install flatpak flatpak-builder

# Arch Linux
sudo pacman -S flatpak flatpak-builder
```

### 添加 Flathub 仓库
```bash
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
```

### 安装运行时
```bash
flatpak install flathub org.freedesktop.Platform//23.08
flatpak install flathub org.freedesktop.Sdk//23.08
```

## 🚀 构建步骤

### 方法一: 使用自动化脚本 (推荐)

1. **准备 AppImage 结构**
   ```bash
   # 下载 GitHub Actions 构建产物
   # 解压 linux_appimage_structure 到项目根目录的 AppDir/ 文件夹
   cd /path/to/oneAnime
   ```

2. **运行构建脚本**
   ```bash
   cd flatpak
   ./build-flatpak.sh
   ```

### 方法二: 手动构建

1. **构建 Flatpak**
   ```bash
   cd flatpak
   flatpak-builder --force-clean --sandbox --user --install-deps-from=flathub \
       --ccache --require-changes --repo=repo build com.zqigolden.oneanime.yaml
   ```

2. **安装到本地测试**
   ```bash
   flatpak install --user repo com.zqigolden.oneanime
   ```

3. **创建分发包**
   ```bash
   flatpak build-bundle repo com.zqigolden.oneanime.flatpak com.zqigolden.oneanime
   ```

## 🧪 测试

### 运行应用
```bash
# 正常运行
flatpak run com.zqigolden.oneanime

# 调试模式
flatpak run --devel com.zqigolden.oneanime

# 查看沙盒信息
flatpak run --command=sh com.zqigolden.oneanime
```

### 权限检查
```bash
# 查看应用权限
flatpak info --show-permissions com.zqigolden.oneanime

# 修改权限 (仅用于测试)
flatpak override --user --filesystem=home com.zqigolden.oneanime
```

## 📦 发布

### 本地分发
- 生成的 `com.zqigolden.oneanime.flatpak` 文件可以直接分享
- 用户安装: `flatpak install com.zqigolden.oneanime.flatpak`

### 提交到 Flathub

1. **Fork Flathub 仓库**
   - 访问: https://github.com/flathub/flathub
   - Fork 到你的账户

2. **创建应用仓库**
   - 创建新仓库: `com.zqigolden.oneanime`
   - 复制 manifest 和相关文件

3. **提交 PR**
   - 按照 [Flathub 提交指南](https://github.com/flathub/flathub/wiki/App-Submission)
   - 等待社区审核

## 🔍 故障排除

### 常见问题

1. **构建失败 - 找不到源文件**
   ```bash
   # 确保 AppDir/ 目录存在且包含正确的文件结构
   ls -la AppDir/usr/bin/oneanime
   ```

2. **运行时错误 - 缺少库文件**
   ```bash
   # 检查依赖库是否正确复制
   flatpak run --command=ldd com.zqigolden.oneanime /app/bin/oneanime
   ```

3. **权限问题 - 无法访问网络/文件**
   ```bash
   # 检查 manifest 中的 finish-args 配置
   # 临时添加权限进行测试
   flatpak override --user --share=network com.zqigolden.oneanime
   ```

### 调试技巧

```bash
# 进入沙盒环境
flatpak run --command=bash com.zqigolden.oneanime

# 查看应用日志
journalctl --user -f | grep oneanime

# 检查文件权限
flatpak run --command=ls com.zqigolden.oneanime -la /app/
```

## 📝 注意事项

1. **SHA256 校验**: 记得更新 manifest 中的 SHA256 值
2. **图标文件**: 确保提供多种尺寸的图标
3. **AppStream 数据**: 完善应用描述和截图
4. **测试充分**: 在不同 Linux 发行版上测试

## 🤝 贡献

欢迎提交 Issue 和 Pull Request 来改善 Flatpak 打包配置！