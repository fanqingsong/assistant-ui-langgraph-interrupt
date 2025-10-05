# Docker 微服务部署指南

本项目已使用 Docker Compose 封装为微服务架构，包含前端、后端和 Nginx 反向代理。

## 项目结构

```
├── frontend/                 # Next.js 前端应用
│   ├── Dockerfile
│   ├── .dockerignore
│   └── env.example
├── backend/                  # Python LangGraph 后端应用
│   ├── Dockerfile
│   ├── .dockerignore
│   └── env.example
├── docker-compose.yml        # Docker Compose 配置
├── nginx.conf               # Nginx 反向代理配置
└── README-Docker.md         # 本文档
```

## 快速开始

### 1. 环境准备

确保已安装 Docker 和 Docker Compose：

```bash
# 检查 Docker 版本
docker --version
docker compose version
```

### 2. 配置环境变量

#### 方法一：使用配置助手（推荐）

```bash
# 使用 Azure OpenAI 配置助手
./setup-azure-openai.sh
```

#### 方法二：手动配置

```bash
# 复制环境变量文件
cp env.example .env

# 编辑 .env 文件，添加你的 Azure OpenAI 配置
nano .env
```

### 3. 启动服务

```bash
# 构建并启动所有服务
docker compose up --build

# 后台运行
docker compose up -d --build

# 查看服务状态
docker compose ps

# 查看日志
docker compose logs -f
```

### 4. 访问应用

- 前端应用：http://localhost:3000
- 后端 API：http://localhost:8000
- 通过 Nginx 代理：http://localhost:80

## 服务说明

### 前端服务 (frontend)
- **端口**: 3000
- **技术栈**: Next.js + React
- **包管理器**: pnpm
- **环境变量**: 通过 `.env` 文件配置

### 后端服务 (backend)
- **端口**: 8000
- **技术栈**: Python + LangGraph + Poetry
- **环境变量**: 通过 `.env` 文件配置
- **健康检查**: 每 30 秒检查一次

### Nginx 服务 (nginx)
- **端口**: 80, 443
- **功能**: 反向代理和负载均衡
- **配置**: 前端请求代理到 frontend 服务，API 请求代理到 backend 服务

## 常用命令

```bash
# 启动服务
docker compose up

# 停止服务
docker compose down

# 重启服务
docker compose restart

# 查看特定服务日志
docker compose logs -f frontend
docker compose logs -f backend

# 进入容器
docker compose exec frontend sh
docker compose exec backend bash

# 重新构建并启动
docker compose up --build

# 清理所有资源
docker compose down -v --rmi all
```

## 开发模式

如果需要开发模式运行：

```bash
# 修改 docker-compose.yml 中的环境变量
# 将 NODE_ENV 改为 development
# 将 LANGGRAPH_ENV 改为 development

# 然后重新启动
docker compose up --build
```

## 生产部署

### 1. 配置 HTTPS

1. 将 SSL 证书放在 `ssl/` 目录下
2. 取消注释 `nginx.conf` 中的 HTTPS 配置
3. 重新启动服务

### 2. 环境变量配置

确保生产环境的环境变量正确配置：

- `AZURE_OPENAI_API_KEY`: Azure OpenAI API 密钥
- `AZURE_OPENAI_ENDPOINT`: Azure OpenAI 终结点 URL
- `AZURE_OPENAI_DEPLOYMENT_NAME`: 部署的模型名称
- `AZURE_OPENAI_API_VERSION`: API 版本
- `NODE_ENV`: 设置为 `production`
- `LANGGRAPH_ENV`: 设置为 `production`

所有配置都在根目录的 `.env` 文件中进行。

### 3. 资源限制

可以在 `docker-compose.yml` 中添加资源限制：

```yaml
services:
  frontend:
    deploy:
      resources:
        limits:
          memory: 512M
        reservations:
          memory: 256M
```

## 故障排除

### 1. 端口冲突

如果端口被占用，可以修改 `docker-compose.yml` 中的端口映射：

```yaml
ports:
  - "3001:3000"  # 将前端端口改为 3001
```

### 2. 构建失败

```bash
# 清理 Docker 缓存
docker system prune -a

# 重新构建
docker compose build --no-cache
```

### 3. 服务无法启动

```bash
# 查看详细日志
docker compose logs

# 检查服务状态
docker compose ps
```

## 注意事项

1. 确保 OpenAI API Key 已正确配置
2. 生产环境建议使用 HTTPS
3. 定期更新依赖和安全补丁
4. 监控服务健康状态和资源使用情况

