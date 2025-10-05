# 使用华为云镜像加速
FROM swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/python:3.11-slim AS base

# 设置工作目录
WORKDIR /app

# 设置 pip 镜像源
RUN pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
RUN pip config set global.trusted-host pypi.tuna.tsinghua.edu.cn

# 设置 apt 镜像源
RUN sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list.d/debian.sources || \
    sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list || \
    echo "deb https://mirrors.ustc.edu.cn/debian/ bookworm main" > /etc/apt/sources.list

# 安装系统依赖
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/*

# 复制项目配置文件
COPY pyproject.toml ./

# 复制源代码
COPY src/ ./src/

# 安装依赖
RUN pip install -e .

# 创建非 root 用户
RUN useradd --create-home --shell /bin/bash app && chown -R app:app /app
USER app

# 暴露端口
EXPOSE 8000

# 启动应用
CMD ["python", "-m", "langgraph", "up", "--host", "0.0.0.0", "--port", "8000"]

