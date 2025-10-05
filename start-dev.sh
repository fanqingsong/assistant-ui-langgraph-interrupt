#!/bin/bash

# Assistant UI LangGraph 开发模式启动脚本
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

# 检查 Docker 环境
check_docker() {
    print_message "🔍 检查 Docker 环境..." $BLUE
    
    if ! command -v docker &> /dev/null; then
        print_message "❌ Docker 未安装，请先安装 Docker" $RED
        exit 1
    fi
    
    if ! command -v docker compose &> /dev/null; then
        print_message "❌ Docker Compose 未安装，请先安装 Docker Compose" $RED
        exit 1
    fi
    
    print_message "✅ Docker 环境检查完成" $GREEN
}

# 构建开发环境镜像
build_dev_images() {
    print_message "🔨 构建开发环境镜像..." $BLUE
    
    # 构建前端开发镜像
    print_message "🔄 构建前端开发镜像..." $YELLOW
    docker compose -f docker-compose.dev.yml build frontend-dev
    
    # 构建后端开发镜像
    print_message "🔄 构建后端开发镜像..." $YELLOW
    docker compose -f docker-compose.dev.yml build backend-dev
    
    print_message "✅ 开发环境镜像构建完成" $GREEN
}

# 配置环境变量
setup_env() {
    print_message "⚙️  配置环境变量..." $BLUE
    
    # 根目录环境变量
    if [ ! -f ".env" ]; then
        if [ -f "env.example" ]; then
            cp env.example .env
            print_message "📝 创建根目录环境变量文件" $YELLOW
        fi
    fi
    
    print_message "⚠️  请确保已配置必要的环境变量（如 Azure OpenAI API Key）" $YELLOW
}

# 启动开发服务
start_dev_services() {
    print_message "🚀 启动开发服务..." $BLUE
    
    # 停止可能存在的服务
    print_message "🛑 停止现有开发服务..." $YELLOW
    docker compose -f docker-compose.dev.yml down 2>/dev/null || true
    
    # 启动开发服务
    print_message "🔄 启动开发环境容器..." $YELLOW
    docker compose -f docker-compose.dev.yml up -d
    
    # 等待服务启动
    print_message "⏳ 等待服务启动..." $YELLOW
    sleep 10
    
    # 检查服务状态
    print_message "📊 检查服务状态..." $BLUE
    docker compose -f docker-compose.dev.yml ps
    
    print_message "✅ 开发服务已启动" $GREEN
}

# 显示开发信息
show_dev_info() {
    print_message "
🎉 开发模式启动完成！

📱 访问地址：
   • 前端应用: http://localhost:3000
   • 后端 API: http://localhost:8000

📋 开发命令：
   • 查看服务日志: docker compose -f docker-compose.dev.yml logs -f
   • 查看前端日志: docker compose -f docker-compose.dev.yml logs -f frontend-dev
   • 查看后端日志: docker compose -f docker-compose.dev.yml logs -f backend-dev
   • 停止开发服务: ./stop-dev.sh
   • 重启服务: ./start-dev.sh restart

🔧 热重载：
   • 前端支持热重载，修改代码后自动刷新
   • 后端支持热重载，修改代码后自动重启
   • 文件修改会自动同步到容器中

📁 容器管理：
   • 进入前端容器: docker compose -f docker-compose.dev.yml exec frontend-dev sh
   • 进入后端容器: docker compose -f docker-compose.dev.yml exec backend-dev bash
   • 查看容器状态: docker compose -f docker-compose.dev.yml ps
" $GREEN
}

# 停止开发服务
stop_dev_services() {
    print_message "🛑 停止开发服务..." $BLUE
    
    # 检查是否有运行中的开发服务
    if docker compose -f docker-compose.dev.yml ps --services --filter "status=running" | grep -q .; then
        print_message "📊 当前运行的开发服务：" $YELLOW
        docker compose -f docker-compose.dev.yml ps
        
        print_message "⏹️  正在停止开发服务..." $YELLOW
        docker compose -f docker-compose.dev.yml down
        
        print_message "✅ 开发服务已停止" $GREEN
    else
        print_message "ℹ️  没有运行中的开发服务" $BLUE
    fi
}

# 重启服务
restart_services() {
    print_message "🔄 重启开发服务..." $BLUE
    stop_dev_services
    sleep 2
    start_dev_services
    show_dev_info
}

# 显示帮助信息
show_help() {
    print_message "
╔══════════════════════════════════════════════════════════════╗
║              Assistant UI LangGraph 开发模式启动器            ║
║                                                              ║
║  🚀 启动开发环境，支持热重载和实时调试                        ║
╚══════════════════════════════════════════════════════════════╝

用法: $0 [选项]

选项:
  -h, --help     显示帮助信息
  -r, --restart  重启开发服务
  -s, --stop     停止开发服务
  -i, --install  只安装依赖，不启动服务

示例:
  $0              # 启动开发服务
  $0 --restart    # 重启开发服务
  $0 --stop       # 停止开发服务
  $0 --install    # 只安装依赖
" $BLUE
}

# 主函数
main() {
    # 解析命令行参数
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -r|--restart)
                restart_services
                exit 0
                ;;
            -s|--stop)
                stop_dev_services
                exit 0
                ;;
            -i|--install)
                check_dependencies
                install_frontend_deps
                install_backend_deps
                setup_env
                print_message "✅ 依赖安装完成" $GREEN
                exit 0
                ;;
            *)
                print_message "❌ 未知选项: $1" $RED
                show_help
                exit 1
                ;;
        esac
    done
    
    print_message "
╔══════════════════════════════════════════════════════════════╗
║              Assistant UI LangGraph 开发模式启动器            ║
║                                                              ║
║  🚀 启动开发环境，支持热重载和实时调试                        ║
╚══════════════════════════════════════════════════════════════╝
" $BLUE
    
    check_docker
    setup_env
    build_dev_images
    start_dev_services
    show_dev_info
}

# 运行主函数
main "$@"
