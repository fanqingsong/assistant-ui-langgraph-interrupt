#!/bin/bash

# Assistant UI LangGraph 停止开发服务脚本
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

# 清理临时文件
cleanup_temp_files() {
    print_message "🧹 清理临时文件..." $BLUE
    
    # 清理 Docker 开发环境
    print_message "🗑️  清理开发环境容器和镜像..." $YELLOW
    docker compose -f docker-compose.dev.yml down -v --rmi all --remove-orphans 2>/dev/null || true
    
    # 清理日志文件（可选）
    if [ -d "logs" ]; then
        print_message "🗑️  清理日志文件..." $YELLOW
        rm -rf logs
    fi
    
    print_message "✅ 临时文件清理完成" $GREEN
}

# 显示帮助信息
show_help() {
    print_message "
╔══════════════════════════════════════════════════════════════╗
║            Assistant UI LangGraph 停止开发服务脚本            ║
║                                                              ║
║  🛑 停止开发环境中的前端和后端服务                            ║
╚══════════════════════════════════════════════════════════════╝

用法: $0 [选项]

选项:
  -h, --help     显示帮助信息
  -c, --clean    停止服务并清理临时文件
  -f, --force    强制停止服务（不询问确认）

示例:
  $0              # 停止开发服务
  $0 --clean      # 停止服务并清理临时文件
  $0 --force      # 强制停止服务
" $BLUE
}

# 主函数
main() {
    local clean=false
    local force=false
    
    # 解析命令行参数
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -c|--clean)
                clean=true
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
    
    print_message "
╔══════════════════════════════════════════════════════════════╗
║            Assistant UI LangGraph 停止开发服务脚本            ║
║                                                              ║
║  🛑 停止开发环境中的前端和后端服务                            ║
╚══════════════════════════════════════════════════════════════╝
" $BLUE
    
    # 确认停止操作
    if [ "$force" != "true" ]; then
        print_message "❓ 确定要停止开发服务吗？(y/N)" $YELLOW
        read -r response
        
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            print_message "❌ 操作已取消" $RED
            exit 0
        fi
    fi
    
    stop_dev_services
    
    # 如果指定了清理选项，清理临时文件
    if [ "$clean" = true ]; then
        cleanup_temp_files
    fi
    
    print_message "
🎉 开发服务已停止！

📋 其他命令：
   • 启动开发服务: ./start-dev.sh
   • 启动生产服务: ./start.sh
   • 清理所有资源: ./cleanup.sh
" $GREEN
}

# 运行主函数
main "$@"
