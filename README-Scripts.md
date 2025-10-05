# 一键启动脚本使用指南

本项目提供了一套完整的脚本工具，让您可以轻松管理微服务的启动、停止和清理。

## 📁 脚本文件

| 脚本文件 | 功能描述 | 使用场景 |
|---------|---------|---------|
| `start.sh` | 一键启动生产环境 | 部署到生产环境 |
| `start-dev.sh` | 启动开发环境 | 本地开发和调试 |
| `stop.sh` | 停止生产服务 | 停止 Docker 容器服务 |
| `stop-dev.sh` | 停止开发服务 | 停止本地开发服务 |
| `cleanup.sh` | 清理所有资源 | 清理 Docker 和开发环境 |

## 🚀 快速开始

### 1. 生产环境部署

```bash
# 一键启动生产环境（Docker 容器）
./start.sh

# 停止生产服务
./stop.sh

# 清理所有资源
./cleanup.sh
```

### 2. 开发环境

```bash
# 启动开发环境（本地运行）
./start-dev.sh

# 停止开发服务
./stop-dev.sh

# 重启开发服务
./start-dev.sh --restart
```

## 📋 详细使用说明

### start.sh - 生产环境启动脚本

**功能**：一键启动 Docker 容器化的微服务

**特性**：
- ✅ 自动检查 Docker 和 Docker Compose
- ✅ 自动创建环境变量文件
- ✅ 检查端口占用情况
- ✅ 构建并启动所有服务
- ✅ 显示服务状态和访问地址

**使用方法**：
```bash
./start.sh
```

**访问地址**：
- 前端：http://localhost:3000
- 后端：http://localhost:8000
- Nginx：http://localhost:80

### start-dev.sh - 开发环境启动脚本

**功能**：启动本地开发环境，支持热重载

**特性**：
- ✅ 自动检查 Node.js、pnpm、Python、Poetry
- ✅ 自动安装依赖
- ✅ 支持热重载
- ✅ 实时日志输出
- ✅ 进程管理

**使用方法**：
```bash
# 启动开发环境
./start-dev.sh

# 只安装依赖
./start-dev.sh --install

# 重启服务
./start-dev.sh --restart

# 停止服务
./start-dev.sh --stop
```

**访问地址**：
- 前端：http://localhost:3000
- 后端：http://localhost:8000

### stop.sh - 停止生产服务脚本

**功能**：停止 Docker 容器服务

**特性**：
- ✅ 停止所有运行中的容器
- ✅ 可选清理资源
- ✅ 显示服务状态

**使用方法**：
```bash
# 停止服务
./stop.sh

# 停止并清理资源
./stop.sh --clean

# 强制停止
./stop.sh --force
```

### stop-dev.sh - 停止开发服务脚本

**功能**：停止本地开发服务

**特性**：
- ✅ 停止前端和后端进程
- ✅ 清理临时文件
- ✅ 端口占用检查

**使用方法**：
```bash
# 停止开发服务
./stop-dev.sh

# 停止并清理临时文件
./stop-dev.sh --clean

# 强制停止
./stop-dev.sh --force
```

### cleanup.sh - 清理资源脚本

**功能**：清理 Docker 和开发环境资源

**特性**：
- ✅ 清理 Docker 容器、镜像、卷、网络
- ✅ 清理开发环境进程和文件
- ✅ 清理系统资源
- ✅ 显示清理统计

**使用方法**：
```bash
# 清理所有资源
./cleanup.sh

# 只清理 Docker 资源
./cleanup.sh --docker

# 只清理开发环境
./cleanup.sh --dev

# 只清理系统资源
./cleanup.sh --system

# 强制清理（不询问确认）
./cleanup.sh --force
```

## 🔧 环境配置

### 1. 后端环境变量

编辑 `backend/.env` 文件：

```bash
# LangGraph 配置
LANGGRAPH_ENV=production
LANGGRAPH_HOST=0.0.0.0
LANGGRAPH_PORT=8000

# OpenAI API 配置
OPENAI_API_KEY=your_openai_api_key_here

# 其他环境变量
DEBUG=false
LOG_LEVEL=info
```

### 2. 前端环境变量

编辑 `frontend/.env` 文件：

```bash
# Next.js 配置
NODE_ENV=production
NEXT_PUBLIC_LANGGRAPH_URL=http://localhost:8000

# 其他环境变量
NEXT_PUBLIC_APP_NAME=Assistant UI LangGraph
```

## 🐛 故障排除

### 1. 权限问题

```bash
# 给脚本添加执行权限
chmod +x *.sh
```

### 2. 端口冲突

```bash
# 检查端口占用
lsof -i :3000
lsof -i :8000
lsof -i :80

# 停止占用端口的进程
kill -9 <PID>
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
./dev.sh --install

# 重新启动
./dev.sh
```

## 📊 监控和日志

### 生产环境

```bash
# 查看服务状态
docker compose ps

# 查看日志
docker compose logs -f

# 查看特定服务日志
docker compose logs -f frontend
docker compose logs -f backend
```

### 开发环境

```bash
# 查看后端日志
tail -f logs/backend.log

# 查看前端日志
tail -f logs/frontend.log

# 查看进程状态
ps aux | grep -E "(node|python)"
```

## 🔄 常用工作流

### 开发流程

```bash
# 1. 启动开发环境
./start-dev.sh

# 2. 进行开发工作
# 修改代码...

# 3. 重启服务（如果需要）
./start-dev.sh --restart

# 4. 停止开发环境
./stop-dev.sh
```

### 部署流程

```bash
# 1. 停止开发环境
./stop-dev.sh

# 2. 启动生产环境
./start.sh

# 3. 测试生产环境
curl http://localhost:3000
curl http://localhost:8000

# 4. 停止生产环境
./stop.sh
```

### 清理流程

```bash
# 1. 停止所有服务
./stop.sh
./stop-dev.sh

# 2. 清理所有资源
./cleanup.sh

# 3. 重新开始
./start.sh
```

## ⚠️ 注意事项

1. **环境变量**：确保已正确配置必要的环境变量（如 OpenAI API Key）
2. **端口占用**：确保端口 3000、8000、80 未被其他服务占用
3. **依赖安装**：开发环境需要安装 Node.js、pnpm、Python、Poetry
4. **Docker 权限**：确保当前用户有 Docker 操作权限
5. **资源清理**：定期运行 `cleanup.sh` 清理未使用的资源

## 🆘 获取帮助

```bash
# 查看脚本帮助
./start.sh --help
./start-dev.sh --help
./stop.sh --help
./stop-dev.sh --help
./cleanup.sh --help
```

## 📝 更新日志

- **v1.0** - 初始版本，包含所有基础功能
- 支持生产环境和开发环境
- 支持一键启动、停止、清理
- 支持热重载和实时调试
- 支持资源监控和日志查看
