# 环境变量配置说明

本项目使用统一的环境变量管理，所有配置都在根目录的 `.env` 文件中进行。

## 📁 文件结构

```
├── .env.example          # 环境变量示例文件（模板）
├── .env                  # 实际环境变量文件（需要创建）
├── docker-compose.yml    # Docker Compose 配置
└── ...
```

## 🔧 配置步骤

### 1. 创建环境变量文件

```bash
# 复制示例文件
cp env.example .env

# 编辑配置文件
nano .env
```

### 2. 配置 Azure OpenAI

在 `.env` 文件中配置以下参数：

```bash
# Azure OpenAI 配置
AZURE_OPENAI_API_KEY=your_actual_api_key_here
AZURE_OPENAI_ENDPOINT=https://your-resource.openai.azure.com/
AZURE_OPENAI_DEPLOYMENT_NAME=gpt-4o
AZURE_OPENAI_API_VERSION=2024-02-15-preview
```

### 3. 配置其他参数

根据需要调整其他配置参数：

```bash
# 端口配置
FRONTEND_PORT=3000
BACKEND_PORT=8000
NGINX_PORT=80

# 环境配置
NODE_ENV=production
LANGGRAPH_ENV=production
DEBUG=false
```

## 📋 环境变量说明

### 后端配置

| 变量名 | 描述 | 默认值 | 必需 |
|--------|------|--------|------|
| `LANGGRAPH_ENV` | LangGraph 环境 | `development` | ❌ |
| `LANGGRAPH_HOST` | 服务主机 | `0.0.0.0` | ❌ |
| `LANGGRAPH_PORT` | 服务端口 | `8000` | ❌ |
| `AZURE_OPENAI_API_KEY` | Azure OpenAI API 密钥 | - | ✅ |
| `AZURE_OPENAI_ENDPOINT` | Azure OpenAI 终结点 | - | ✅ |
| `AZURE_OPENAI_DEPLOYMENT_NAME` | 部署名称 | `gpt-4o` | ❌ |
| `AZURE_OPENAI_API_VERSION` | API 版本 | `2024-02-15-preview` | ❌ |
| `DEBUG` | 调试模式 | `true` | ❌ |
| `LOG_LEVEL` | 日志级别 | `info` | ❌ |

### 前端配置

| 变量名 | 描述 | 默认值 | 必需 |
|--------|------|--------|------|
| `NODE_ENV` | Node.js 环境 | `production` | ❌ |
| `NEXT_PUBLIC_LANGGRAPH_URL` | 后端 API URL | `http://localhost:8000` | ❌ |
| `NEXT_PUBLIC_APP_NAME` | 应用名称 | `Assistant UI LangGraph` | ❌ |

### Docker Compose 配置

| 变量名 | 描述 | 默认值 | 必需 |
|--------|------|--------|------|
| `FRONTEND_PORT` | 前端端口 | `3000` | ❌ |
| `BACKEND_PORT` | 后端端口 | `8000` | ❌ |
| `NGINX_PORT` | Nginx 端口 | `80` | ❌ |
| `NGINX_SSL_PORT` | Nginx SSL 端口 | `443` | ❌ |
| `NETWORK_NAME` | 网络名称 | `app-network` | ❌ |

### 健康检查配置

| 变量名 | 描述 | 默认值 | 必需 |
|--------|------|--------|------|
| `HEALTH_CHECK_INTERVAL` | 检查间隔 | `30s` | ❌ |
| `HEALTH_CHECK_TIMEOUT` | 超时时间 | `10s` | ❌ |
| `HEALTH_CHECK_RETRIES` | 重试次数 | `3` | ❌ |

## 🚀 使用配置助手

推荐使用配置助手来设置 Azure OpenAI：

```bash
# 使用配置助手
./setup-azure-openai.sh

# 测试配置
./setup-azure-openai.sh --test

# 重置配置
./setup-azure-openai.sh --reset
```

## 🔒 安全注意事项

1. **保护 .env 文件**：
   - 永远不要将 `.env` 文件提交到版本控制系统
   - 确保 `.env` 文件权限设置为 `600` 或 `644`

2. **API 密钥安全**：
   - 定期轮换 API 密钥
   - 使用最小权限原则
   - 监控 API 使用情况

3. **环境隔离**：
   - 开发、测试、生产环境使用不同的配置
   - 使用不同的 API 密钥和终结点

## 🧪 验证配置

### 1. 检查环境变量

```bash
# 检查 .env 文件是否存在
ls -la .env

# 检查环境变量是否正确加载
docker compose config
```

### 2. 测试服务启动

```bash
# 启动服务
./start.sh

# 检查服务状态
docker compose ps

# 查看日志
docker compose logs
```

### 3. 测试 API 连接

```bash
# 测试后端 API
curl http://localhost:8000/health

# 测试前端
curl http://localhost:3000
```

## 🔧 故障排除

### 1. 环境变量未生效

```bash
# 检查 .env 文件格式
cat .env

# 重新加载环境变量
docker compose down
docker compose up --build
```

### 2. 端口冲突

```bash
# 检查端口占用
lsof -i :3000
lsof -i :8000
lsof -i :80

# 修改端口配置
# 在 .env 文件中设置不同的端口
FRONTEND_PORT=3001
BACKEND_PORT=8001
```

### 3. Azure OpenAI 连接问题

```bash
# 测试 Azure OpenAI 配置
./setup-azure-openai.sh --test

# 检查网络连接
curl -I https://your-resource.openai.azure.com/
```

## 📚 相关文档

- [Docker 部署指南](README-Docker.md)
- [Azure OpenAI 配置指南](AZURE-OPENAI-SETUP.md)
- [脚本使用指南](README-Scripts.md)
- [快速开始指南](QUICK-START.md)

## 🆘 获取帮助

如果遇到配置问题，请：

1. 检查 `.env` 文件格式是否正确
2. 确认所有必需的环境变量都已设置
3. 查看服务日志获取详细错误信息
4. 使用配置助手重新配置

```bash
# 查看详细日志
docker compose logs -f

# 重新配置
./setup-azure-openai.sh --reset
```
