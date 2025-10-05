#!/bin/bash

# Assistant UI LangGraph 一键启动脚本
# 作者: AI Assistant
# 版本: 1.0

set -e  # 遇到错误立即退出

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 打印带颜色的消息
print_message() {
    echo -e "${2}${1}${NC}"
}

# 检查 Docker 是否安装
check_docker() {
    if ! command -v docker &> /dev/null; then
        print_message "❌ Docker 未安装，请先安装 Docker" $RED
        exit 1
    fi
    
    if ! command -v docker compose &> /dev/null; then
        print_message "❌ Docker Compose 未安装，请先安装 Docker Compose" $RED
        exit 1
    fi
    
    print_message "✅ Docker 和 Docker Compose 已安装" $GREEN
}

# 检查环境变量文件
check_env_files() {
    print_message "🔍 检查环境变量文件..." $BLUE
    
    # 检查根目录环境变量文件
    if [ ! -f ".env" ]; then
        if [ -f "env.example" ]; then
            print_message "📝 创建环境变量文件..." $YELLOW
            cp env.example .env
            print_message "⚠️  请编辑 .env 文件，添加必要的配置（如 Azure OpenAI API Key）" $YELLOW
        else
            print_message "❌ 环境变量示例文件不存在" $RED
            exit 1
        fi
    else
        print_message "✅ 环境变量文件已存在" $GREEN
    fi
}

# 检查端口是否被占用
check_ports() {
    print_message "🔍 检查端口占用情况..." $BLUE
    
    ports=(3000 8000 80)
    for port in "${ports[@]}"; do
        if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
            print_message "⚠️  端口 $port 已被占用，请检查是否有其他服务在运行" $YELLOW
            print_message "   可以使用 'docker compose down' 停止现有服务" $YELLOW
        else
            print_message "✅ 端口 $port 可用" $GREEN
        fi
    done
}

# 启动服务
start_services() {
    print_message "🚀 启动微服务..." $BLUE
    
    # 停止可能存在的服务
    print_message "🛑 停止现有服务..." $YELLOW
    docker compose down 2>/dev/null || true
    
    # 构建并启动服务
    print_message "🔨 构建并启动服务..." $BLUE
    docker compose up --build -d
    
    # 等待服务启动
    print_message "⏳ 等待服务启动..." $YELLOW
    sleep 10
    
    # 检查服务状态
    print_message "📊 检查服务状态..." $BLUE
    docker compose ps
}

# 显示访问信息
show_access_info() {
    print_message "
🎉 服务启动完成！

📱 访问地址：
   • 前端应用: http://localhost:3000
   • 后端 API: http://localhost:8000
   • Nginx 代理: http://localhost:80

📋 常用命令：
   • 查看日志: docker compose logs -f
   • 停止服务: docker compose down
   • 重启服务: docker compose restart
   • 查看状态: docker compose ps

🔧 开发模式：
   • 运行 ./start-dev.sh 启动开发模式

🧹 清理资源：
   • 运行 ./cleanup.sh 清理所有资源
" $GREEN
}

# 主函数
main() {
    print_message "
╔══════════════════════════════════════════════════════════════╗
║                Assistant UI LangGraph 微服务启动器            ║
║                                                              ║
║  🚀 一键启动前端、后端和 Nginx 反向代理服务                    ║
╚══════════════════════════════════════════════════════════════╝
" $BLUE
    
    check_docker
    check_env_files
    check_ports
    start_services
    show_access_info
}

# 运行主函数
main "$@"
