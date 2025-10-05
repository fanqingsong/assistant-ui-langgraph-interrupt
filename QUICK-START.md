# 快速开始指南

欢迎使用 Assistant UI LangGraph 微服务项目！本指南将帮助您快速启动和运行项目。

## 🚀 一键启动

### 生产环境（Docker 容器）

```bash
# 1. 配置 Azure OpenAI
./setup-azure-openai.sh

# 2. 一键启动生产环境
./start.sh
```

### 开发环境（Docker Compose）

```bash
# 1. 配置 Azure OpenAI
./setup-azure-openai.sh

# 2. 一键启动开发环境（Docker 容器）
./start-dev.sh

# 3. 监控开发环境
./dev-monitor.sh
```

## 📋 脚本说明

| 脚本 | 功能 | 使用场景 |
|------|------|----------|
| `./start.sh` | 启动生产环境 | 部署到生产环境 |
| `./start-dev.sh` | 启动开发环境 | Docker 容器化开发 |
| `./stop.sh` | 停止生产服务 | 停止 Docker 容器 |
| `./stop-dev.sh` | 停止开发服务 | 停止开发容器服务 |
| `./dev-monitor.sh` | 监控开发环境 | 实时监控开发服务 |
| `./cleanup.sh` | 清理所有资源 | 清理 Docker 和开发环境 |
| `./setup-azure-openai.sh` | 配置 Azure OpenAI | 设置 AI 模型 |

## 🔧 配置 Azure OpenAI

### 方法一：使用配置助手（推荐）

```bash
./setup-azure-openai.sh
```

按照提示输入您的 Azure OpenAI 配置信息：
- API Key
- Endpoint URL
- Deployment Name
- API Version

### 方法二：手动配置

```bash
# 复制环境变量文件
cp env.example .env

# 编辑配置文件
nano .env
```

在 `.env` 文件中填入您的配置：

```bash
AZURE_OPENAI_API_KEY=your_api_key_here
AZURE_OPENAI_ENDPOINT=https://your-resource.openai.azure.com/
AZURE_OPENAI_DEPLOYMENT_NAME=gpt-4o
AZURE_OPENAI_API_VERSION=2024-02-15-preview
```

## 🌐 访问应用

启动成功后，您可以通过以下地址访问：

- **前端应用**: http://localhost:3000
- **后端 API**: http://localhost:8000
- **Nginx 代理**: http://localhost:80

## 🛠️ 常用命令

### 启动服务

```bash
# 生产环境
./start.sh

# 开发环境
./start-dev.sh
```

### 停止服务

```bash
# 停止生产服务
./stop.sh

# 停止开发服务
./stop-dev.sh
```

### 查看日志

```bash
# 生产环境日志
docker compose logs -f

# 开发环境日志
tail -f logs/backend.log
tail -f logs/frontend.log
```

### 清理资源

```bash
# 清理所有资源
./cleanup.sh

# 只清理 Docker 资源
./cleanup.sh --docker
```

## 🔍 故障排除

### 1. 端口被占用

```bash
# 检查端口占用
lsof -i :3000
lsof -i :8000
lsof -i :80

# 停止占用端口的进程
kill -9 <PID>
```

### 2. Azure OpenAI 配置错误

```bash
# 测试配置
./setup-azure-openai.sh --test

# 重置配置
./setup-azure-openai.sh --reset
```

### 3. Docker 问题

```bash
# 清理 Docker 资源
./cleanup.sh --docker

# 重新启动
./start.sh
```

### 4. 开发环境问题

```bash
# 清理开发环境
./cleanup.sh --dev

# 重新安装依赖
./start-dev.sh --install

# 重新启动
./start-dev.sh
```

## 📚 详细文档

- [Docker 部署指南](README-Docker.md) - 详细的 Docker 部署说明
- [脚本使用指南](README-Scripts.md) - 所有脚本的详细使用方法
- [Azure OpenAI 配置指南](AZURE-OPENAI-SETUP.md) - Azure OpenAI 配置详解
- [环境变量配置说明](ENV-CONFIG.md) - 环境变量配置详解
- [.gitignore 配置指南](GITIGNORE-GUIDE.md) - Git 忽略文件配置说明

## 🆘 获取帮助

```bash
# 查看脚本帮助
./start.sh --help
./start-dev.sh --help
./stop.sh --help
./stop-dev.sh --help
./cleanup.sh --help
./setup-azure-openai.sh --help
```

## 🎉 开始使用

1. **配置 Azure OpenAI**: `./setup-azure-openai.sh`
2. **启动开发环境**: `./start-dev.sh`
3. **访问应用**: http://localhost:3000
4. **开始开发**: 修改代码，支持热重载
5. **部署生产**: `./start.sh`

祝您使用愉快！🎉
