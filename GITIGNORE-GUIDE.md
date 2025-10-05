# .gitignore 配置指南

本项目已配置了完整的 `.gitignore` 文件，确保敏感文件和临时文件不会被提交到版本控制系统。

## 🛡️ 保护的文件类型

### 1. **环境变量和配置文件**
- `.env` - 包含敏感信息的环境变量文件
- `.env.local`, `.env.development.local` 等 - 本地环境变量文件
- `*.env.backup` - 环境变量备份文件

### 2. **日志文件**
- `logs/` - 日志目录
- `*.log` - 所有日志文件
- `npm-debug.log*`, `yarn-debug.log*` 等 - 包管理器日志

### 3. **依赖目录**
- `node_modules/` - Node.js 依赖
- `__pycache__/` - Python 缓存
- `.venv/`, `venv/` - Python 虚拟环境
- `*.egg-info/` - Python 包信息

### 4. **构建和编译文件**
- `.next/`, `out/` - Next.js 构建文件
- `dist/`, `build/` - 前端构建文件
- `*.com`, `*.class`, `*.dll` 等 - 编译文件

### 5. **缓存文件**
- `.cache/`, `.parcel-cache/` - 缓存目录
- `*.tmp`, `*.temp` - 临时文件

### 6. **IDE 和编辑器文件**
- `.vscode/` - VSCode 配置（保留部分有用配置）
- `.idea/` - IntelliJ IDEA 配置
- `*.sublime-*` - Sublime Text 配置

### 7. **操作系统文件**
- `.DS_Store` - macOS 系统文件
- `Thumbs.db` - Windows 缩略图文件
- `*~` - Linux 临时文件

### 8. **Docker 相关**
- `docker-compose.override.yml` - Docker Compose 覆盖文件
- `docker-data/` - Docker 数据卷

### 9. **测试和覆盖率**
- `coverage/` - 测试覆盖率报告
- `test-results/` - 测试结果

### 10. **数据库文件**
- `*.db`, `*.sqlite` - 数据库文件
- `*.dump`, `*.sql` - 数据库备份

### 11. **证书和密钥文件**
- `ssl/` - SSL 证书目录
- `*.pem`, `*.key`, `*.crt` - 证书和密钥文件

### 12. **项目特定文件**
- `.dev/`, `dev-*` - 开发环境文件
- `.prod/`, `prod-*` - 生产环境文件
- `secrets/`, `private/` - 敏感文件目录

## 🔍 检查被忽略的文件

### 查看被忽略的文件
```bash
# 查看所有被忽略的文件
git status --ignored

# 查看特定目录的被忽略文件
git check-ignore -v logs/
git check-ignore -v .env
```

### 强制添加被忽略的文件
```bash
# 强制添加被忽略的文件（不推荐）
git add -f .env

# 强制添加被忽略的目录
git add -f logs/
```

## ⚠️ 重要注意事项

### 1. **环境变量文件**
- **永远不要**将 `.env` 文件提交到版本控制
- 使用 `env.example` 作为模板
- 在部署时手动创建 `.env` 文件

### 2. **敏感信息**
- API 密钥、密码、令牌等敏感信息
- 数据库连接字符串
- SSL 证书和私钥
- 配置文件中的敏感数据

### 3. **大型文件**
- 依赖目录（`node_modules/`, `__pycache__/`）
- 构建产物（`dist/`, `build/`, `.next/`）
- 日志文件和缓存文件

### 4. **临时文件**
- 编辑器临时文件
- 系统临时文件
- 进程文件（`*.pid`）

## 🛠️ 自定义 .gitignore

### 添加新的忽略规则
```bash
# 编辑 .gitignore 文件
nano .gitignore

# 添加新的忽略规则
echo "my-custom-file.txt" >> .gitignore
echo "custom-directory/" >> .gitignore
```

### 忽略特定文件类型
```bash
# 忽略所有 .bak 文件
*.bak

# 忽略特定目录
my-temp-directory/

# 忽略特定文件
config.local.json
```

### 取消忽略特定文件
```bash
# 在 .gitignore 中使用 ! 前缀
!important.log
!config.example.json
```

## 🧪 测试 .gitignore

### 测试忽略规则
```bash
# 测试特定文件是否被忽略
git check-ignore -v .env
git check-ignore -v logs/app.log
git check-ignore -v node_modules/

# 测试目录是否被忽略
git check-ignore -v logs/
git check-ignore -v .cache/
```

### 验证忽略效果
```bash
# 创建测试文件
touch .env
mkdir logs
touch logs/test.log

# 检查 git 状态
git status

# 应该看不到这些文件
```

## 📋 最佳实践

### 1. **定期检查**
```bash
# 定期检查是否有敏感文件被意外添加
git status
git log --name-only --oneline -10
```

### 2. **团队协作**
- 确保所有团队成员都使用相同的 `.gitignore`
- 在 README 中说明需要手动创建的文件
- 使用 `env.example` 作为配置模板

### 3. **部署注意事项**
- 在部署脚本中自动创建 `.env` 文件
- 确保生产环境有正确的环境变量
- 使用配置管理工具管理敏感信息

### 4. **清理已跟踪的文件**
```bash
# 如果文件已经被跟踪，需要先从 git 中移除
git rm --cached .env
git rm --cached -r logs/
git commit -m "Remove sensitive files from tracking"
```

## 🔧 故障排除

### 1. 文件仍然被跟踪
```bash
# 检查文件是否已经被跟踪
git ls-files | grep .env

# 从跟踪中移除文件
git rm --cached .env
```

### 2. .gitignore 不生效
```bash
# 检查 .gitignore 语法
git check-ignore -v .env

# 清除 git 缓存
git rm -r --cached .
git add .
git commit -m "Update .gitignore"
```

### 3. 恢复被忽略的文件
```bash
# 查看被忽略的文件
git status --ignored

# 恢复特定文件
git checkout HEAD -- .env
```

## 📚 相关文档

- [Git 官方文档 - gitignore](https://git-scm.com/docs/gitignore)
- [GitHub gitignore 模板](https://github.com/github/gitignore)
- [环境变量配置说明](ENV-CONFIG.md)
- [Docker 部署指南](README-Docker.md)

## 🆘 获取帮助

如果遇到 `.gitignore` 相关问题：

1. 检查 `.gitignore` 文件语法
2. 使用 `git check-ignore` 测试规则
3. 查看 `git status` 确认文件状态
4. 参考 Git 官方文档

```bash
# 查看 git 帮助
git help gitignore
git help check-ignore
```
