# 开发环境使用指南

本项目现在支持使用 Docker Compose 进行容器化开发，提供完整的热重载和实时调试功能。

## 🚀 快速开始

### 1. 启动开发环境

```bash
# 配置环境变量
./setup-azure-openai.sh

# 启动开发环境
./start-dev.sh
```

### 2. 监控开发环境

```bash
# 启动监控面板
./dev-monitor.sh

# 查看实时日志
./dev-monitor.sh --logs

# 进入容器
./dev-monitor.sh --enter frontend-dev
./dev-monitor.sh --enter backend-dev
```

### 3. 停止开发环境

```bash
# 停止开发服务
./stop-dev.sh
```

## 📁 开发环境结构

```
项目根目录/
├── docker-compose.dev.yml      # 开发环境 Docker Compose 配置
├── frontend/
│   ├── Dockerfile.dev          # 前端开发 Dockerfile
│   └── ...
├── backend/
│   ├── Dockerfile.dev          # 后端开发 Dockerfile
│   └── ...
└── ...
```

## 🔧 开发环境特性

### 1. **热重载支持**
- **前端热重载**：修改 React 组件后自动刷新
- **后端热重载**：修改 Python 代码后自动重启
- **文件同步**：本地文件修改自动同步到容器

### 2. **实时调试**
- **日志监控**：实时查看服务日志
- **资源监控**：监控 CPU、内存使用情况
- **容器管理**：进入容器进行调试

### 3. **开发工具**
- **代码编辑**：支持 VS Code 远程开发
- **终端访问**：进入容器执行命令
- **网络调试**：服务间网络通信调试

## 📋 开发命令

### 基本操作

```bash
# 启动开发环境
./start-dev.sh

# 停止开发环境
./stop-dev.sh

# 重启开发环境
./start-dev.sh --restart

# 查看服务状态
docker compose -f docker-compose.dev.yml ps
```

### 日志查看

```bash
# 查看所有服务日志
docker compose -f docker-compose.dev.yml logs -f

# 查看前端日志
docker compose -f docker-compose.dev.yml logs -f frontend-dev

# 查看后端日志
docker compose -f docker-compose.dev.yml logs -f backend-dev
```

### 容器管理

```bash
# 进入前端容器
docker compose -f docker-compose.dev.yml exec frontend-dev sh

# 进入后端容器
docker compose -f docker-compose.dev.yml exec backend-dev bash

# 在容器中执行命令
docker compose -f docker-compose.dev.yml exec frontend-dev pnpm install
docker compose -f docker-compose.dev.yml exec backend-dev poetry install
```

### 监控和调试

```bash
# 启动监控面板
./dev-monitor.sh

# 查看实时日志
./dev-monitor.sh --logs

# 重启特定服务
./dev-monitor.sh --restart frontend-dev
```

## 🔄 热重载配置

### 前端热重载

前端使用 Next.js 的热重载功能，配置在 `frontend/next.config.ts` 中：

```typescript
// 开发环境配置
...(process.env.NODE_ENV === 'development' && {
  webpack: (config, { dev, isServer }) => {
    if (dev && !isServer) {
      config.watchOptions = {
        poll: 1000,        // 轮询间隔
        aggregateTimeout: 300,  // 聚合延迟
      };
    }
    return config;
  },
}),
```

### 后端热重载

后端使用 LangGraph 的 `--reload` 参数：

```bash
# 在 Dockerfile.dev 中
CMD ["poetry", "run", "langgraph", "up", "--host", "0.0.0.0", "--port", "8000", "--reload"]
```

### 文件同步

Docker Compose 配置了卷挂载，实现文件同步：

```yaml
volumes:
  - ./frontend:/app          # 前端代码同步
  - ./backend:/app           # 后端代码同步
  - /app/node_modules        # 排除 node_modules
  - /app/.venv              # 排除 Python 虚拟环境
```

## 🛠️ 开发工作流

### 1. 日常开发

```bash
# 1. 启动开发环境
./start-dev.sh

# 2. 监控开发环境
./dev-monitor.sh

# 3. 修改代码（支持热重载）
# 前端：修改 React 组件
# 后端：修改 Python 代码

# 4. 查看日志
./dev-monitor.sh --logs

# 5. 停止开发环境
./stop-dev.sh
```

### 2. 调试问题

```bash
# 1. 查看服务状态
docker compose -f docker-compose.dev.yml ps

# 2. 查看详细日志
docker compose -f docker-compose.dev.yml logs -f

# 3. 进入容器调试
./dev-monitor.sh --enter frontend-dev
./dev-monitor.sh --enter backend-dev

# 4. 重启服务
./dev-monitor.sh --restart
```

### 3. 安装新依赖

```bash
# 前端依赖
docker compose -f docker-compose.dev.yml exec frontend-dev pnpm add package-name

# 后端依赖
docker compose -f docker-compose.dev.yml exec backend-dev poetry add package-name
```

## 🔍 故障排除

### 1. 服务启动失败

```bash
# 查看详细错误信息
docker compose -f docker-compose.dev.yml logs

# 检查服务状态
docker compose -f docker-compose.dev.yml ps

# 重新构建镜像
docker compose -f docker-compose.dev.yml build --no-cache
```

### 2. 热重载不工作

```bash
# 检查文件权限
ls -la frontend/ backend/

# 检查卷挂载
docker compose -f docker-compose.dev.yml exec frontend-dev ls -la /app

# 重启服务
./dev-monitor.sh --restart
```

### 3. 端口冲突

```bash
# 检查端口占用
lsof -i :3000
lsof -i :8000

# 修改端口配置
# 在 .env 文件中设置不同的端口
FRONTEND_PORT=3001
BACKEND_PORT=8001
```

### 4. 容器无法访问

```bash
# 检查网络连接
docker network ls
docker compose -f docker-compose.dev.yml exec frontend-dev ping backend-dev

# 检查服务健康状态
docker compose -f docker-compose.dev.yml ps
```

## 📊 性能优化

### 1. 构建优化

```bash
# 使用构建缓存
docker compose -f docker-compose.dev.yml build --parallel

# 清理构建缓存
docker builder prune -f
```

### 2. 资源限制

在 `docker-compose.dev.yml` 中添加资源限制：

```yaml
services:
  frontend-dev:
    deploy:
      resources:
        limits:
          memory: 1G
        reservations:
          memory: 512M
```

### 3. 开发工具优化

```bash
# 使用多阶段构建
# 在 Dockerfile.dev 中优化层缓存

# 使用 .dockerignore 排除不必要的文件
```

## 🔒 安全注意事项

### 1. 环境变量

```bash
# 确保敏感信息在 .env 文件中
# 不要将 .env 文件提交到版本控制
```

### 2. 容器安全

```bash
# 使用非 root 用户运行容器
# 定期更新基础镜像
# 限制容器权限
```

### 3. 网络安全

```bash
# 使用内部网络通信
# 限制外部访问端口
# 使用 HTTPS 进行生产部署
```

## 📚 相关文档

- [Docker 部署指南](README-Docker.md)
- [环境变量配置说明](ENV-CONFIG.md)
- [Azure OpenAI 配置指南](AZURE-OPENAI-SETUP.md)
- [快速开始指南](QUICK-START.md)

## 🆘 获取帮助

```bash
# 查看脚本帮助
./start-dev.sh --help
./dev-monitor.sh --help
./stop-dev.sh --help

# 查看 Docker Compose 帮助
docker compose -f docker-compose.dev.yml --help
```

## 🎉 开始开发

现在您可以享受完整的容器化开发体验：

1. **一键启动**：`./start-dev.sh`
2. **实时监控**：`./dev-monitor.sh`
3. **热重载开发**：修改代码，自动刷新
4. **容器调试**：进入容器进行调试
5. **一键停止**：`./stop-dev.sh`

祝您开发愉快！🚀
