#!/bin/bash

# Assistant UI LangGraph 清理脚本
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

# 清理 Docker 资源
cleanup_docker() {
    print_message "🐳 清理 Docker 资源..." $BLUE
    
    # 停止并删除容器
    if docker compose ps --services --filter "status=running" | grep -q .; then
        print_message "🛑 停止运行中的服务..." $YELLOW
        docker compose down
    fi
    
    # 删除容器、网络和卷
    print_message "🗑️  删除容器、网络和卷..." $YELLOW
    docker compose down -v --rmi all --remove-orphans 2>/dev/null || true
    
    # 清理悬空镜像
    print_message "🧹 清理悬空镜像..." $YELLOW
    docker image prune -f 2>/dev/null || true
    
    # 清理未使用的卷
    print_message "🧹 清理未使用的卷..." $YELLOW
    docker volume prune -f 2>/dev/null || true
    
    # 清理未使用的网络
    print_message "🧹 清理未使用的网络..." $YELLOW
    docker network prune -f 2>/dev/null || true
    
    print_message "✅ Docker 资源清理完成" $GREEN
}

# 清理开发环境
cleanup_dev() {
    print_message "💻 清理开发环境..." $BLUE
    
    # 停止开发服务
    if [ -f ".backend.pid" ]; then
        BACKEND_PID=$(cat .backend.pid)
        if kill -0 $BACKEND_PID 2>/dev/null; then
            kill $BACKEND_PID 2>/dev/null || true
            print_message "✅ 后端开发服务已停止" $GREEN
        fi
        rm -f .backend.pid
    fi
    
    if [ -f ".frontend.pid" ]; then
        FRONTEND_PID=$(cat .frontend.pid)
        if kill -0 $FRONTEND_PID 2>/dev/null; then
            kill $FRONTEND_PID 2>/dev/null || true
            print_message "✅ 前端开发服务已停止" $GREEN
        fi
        rm -f .frontend.pid
    fi
    
    # 清理日志文件
    if [ -d "logs" ]; then
        print_message "🗑️  清理日志文件..." $YELLOW
        rm -rf logs
    fi
    
    # 清理前端依赖
    if [ -d "frontend/node_modules" ]; then
        print_message "🗑️  清理前端依赖..." $YELLOW
        rm -rf frontend/node_modules
    fi
    
    # 清理后端虚拟环境
    if [ -d "backend/.venv" ]; then
        print_message "🗑️  清理后端虚拟环境..." $YELLOW
        rm -rf backend/.venv
    fi
    
    print_message "✅ 开发环境清理完成" $GREEN
}

# 清理系统资源
cleanup_system() {
    print_message "🖥️  清理系统资源..." $BLUE
    
    # 清理 Docker 系统
    print_message "🧹 清理 Docker 系统..." $YELLOW
    docker system prune -af 2>/dev/null || true
    
    # 清理构建缓存
    print_message "🧹 清理构建缓存..." $YELLOW
    docker builder prune -af 2>/dev/null || true
    
    print_message "✅ 系统资源清理完成" $GREEN
}

# 显示清理统计
show_cleanup_stats() {
    print_message "📊 清理统计信息..." $BLUE
    
    # 显示 Docker 磁盘使用情况
    if command -v docker &> /dev/null; then
        print_message "🐳 Docker 磁盘使用情况：" $YELLOW
        docker system df 2>/dev/null || true
    fi
    
    # 显示项目目录大小
    print_message "📁 项目目录大小：" $YELLOW
    du -sh . 2>/dev/null || true
}

# 确认清理操作
confirm_cleanup() {
    local cleanup_type=$1
    
    case $cleanup_type in
        "docker")
            print_message "⚠️  这将清理所有 Docker 资源（容器、镜像、卷、网络）" $YELLOW
            ;;
        "dev")
            print_message "⚠️  这将清理开发环境（进程、日志、依赖）" $YELLOW
            ;;
        "system")
            print_message "⚠️  这将清理系统资源（Docker 系统、构建缓存）" $YELLOW
            ;;
        "all")
            print_message "⚠️  这将清理所有资源（Docker、开发环境、系统资源）" $YELLOW
            ;;
    esac
    
    print_message "❓ 确定要继续吗？(y/N)" $YELLOW
    read -r response
    
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        print_message "❌ 操作已取消" $RED
        exit 0
    fi
}

# 显示帮助信息
show_help() {
    print_message "
╔══════════════════════════════════════════════════════════════╗
║                Assistant UI LangGraph 清理脚本               ║
║                                                              ║
║  🧹 清理 Docker 资源、开发环境和系统资源                      ║
╚══════════════════════════════════════════════════════════════╝

用法: $0 [选项]

选项:
  -h, --help     显示帮助信息
  -d, --docker   只清理 Docker 资源
  -v, --dev      只清理开发环境
  -s, --system   只清理系统资源
  -a, --all      清理所有资源
  -f, --force    强制清理（不询问确认）

示例:
  $0 --docker    # 清理 Docker 资源
  $0 --dev       # 清理开发环境
  $0 --all       # 清理所有资源
  $0 --force     # 强制清理所有资源
" $BLUE
}

# 主函数
main() {
    local cleanup_type=""
    local force=false
    
    # 解析命令行参数
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -d|--docker)
                cleanup_type="docker"
                shift
                ;;
            -v|--dev)
                cleanup_type="dev"
                shift
                ;;
            -s|--system)
                cleanup_type="system"
                shift
                ;;
            -a|--all)
                cleanup_type="all"
                shift
                ;;
            -f|--force)
                force=true
                shift
                ;;
            *)
                print_message "❌ 未知选项: $1" $RED
                show_help
                exit 1
                ;;
        esac
    done
    
    # 如果没有指定类型，默认清理所有
    if [ -z "$cleanup_type" ]; then
        cleanup_type="all"
    fi
    
    print_message "
╔══════════════════════════════════════════════════════════════╗
║                Assistant UI LangGraph 清理脚本               ║
║                                                              ║
║  🧹 清理 Docker 资源、开发环境和系统资源                      ║
╚══════════════════════════════════════════════════════════════╝
" $BLUE
    
    # 确认清理操作
    if [ "$force" != "true" ]; then
        confirm_cleanup "$cleanup_type"
    fi
    
    # 执行清理操作
    case $cleanup_type in
        "docker")
            cleanup_docker
            ;;
        "dev")
            cleanup_dev
            ;;
        "system")
            cleanup_system
            ;;
        "all")
            cleanup_docker
            cleanup_dev
            cleanup_system
            ;;
    esac
    
    # 显示清理统计
    show_cleanup_stats
    
    print_message "
🎉 清理完成！

📋 其他命令：
   • 启动服务: ./start.sh
   • 开发模式: ./start-dev.sh
   • 停止服务: ./stop.sh
" $GREEN
}

# 运行主函数
main "$@"
