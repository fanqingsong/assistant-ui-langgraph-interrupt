#!/bin/bash

# Assistant UI LangGraph 停止脚本
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

# 停止服务
stop_services() {
    print_message "🛑 停止微服务..." $BLUE
    
    # 检查是否有运行中的服务
    if docker compose ps --services --filter "status=running" | grep -q .; then
        print_message "📊 当前运行的服务：" $YELLOW
        docker compose ps
        
        print_message "⏹️  正在停止服务..." $YELLOW
        docker compose down
        
        print_message "✅ 服务已停止" $GREEN
    else
        print_message "ℹ️  没有运行中的服务" $BLUE
    fi
}

# 清理资源（可选）
cleanup_resources() {
    print_message "🧹 是否要清理所有资源？(y/N)" $YELLOW
    read -r response
    
    if [[ "$response" =~ ^[Yy]$ ]]; then
        print_message "🗑️  清理所有资源..." $YELLOW
        docker compose down -v --rmi all --remove-orphans
        print_message "✅ 资源清理完成" $GREEN
    else
        print_message "ℹ️  跳过资源清理" $BLUE
    fi
}

# 显示帮助信息
show_help() {
    print_message "
╔══════════════════════════════════════════════════════════════╗
║                Assistant UI LangGraph 停止脚本               ║
║                                                              ║
║  🛑 停止所有微服务并清理资源                                  ║
╚══════════════════════════════════════════════════════════════╝

用法: $0 [选项]

选项:
  -h, --help     显示帮助信息
  -c, --clean    停止服务并清理所有资源
  -f, --force    强制停止服务（不询问确认）

示例:
  $0              # 停止服务
  $0 --clean      # 停止服务并清理资源
  $0 --force      # 强制停止服务
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
            -c|--clean)
                CLEANUP=true
                shift
                ;;
            -f|--force)
                FORCE=true
                shift
                ;;
            *)
                print_message "❌ 未知选项: $1" $RED
                show_help
                exit 1
                ;;
        esac
    done
    
    # 检查 Docker 是否安装
    if ! command -v docker &> /dev/null; then
        print_message "❌ Docker 未安装" $RED
        exit 1
    fi
    
    if ! command -v docker compose &> /dev/null; then
        print_message "❌ Docker Compose 未安装" $RED
        exit 1
    fi
    
    stop_services
    
    # 如果指定了清理选项，直接清理
    if [[ "$CLEANUP" == "true" ]]; then
        print_message "🗑️  清理所有资源..." $YELLOW
        docker compose down -v --rmi all --remove-orphans
        print_message "✅ 资源清理完成" $GREEN
    elif [[ "$FORCE" != "true" ]]; then
        # 如果没有指定强制选项，询问是否清理
        cleanup_resources
    fi
    
    print_message "
🎉 操作完成！

📋 其他命令：
   • 启动服务: ./start.sh
   • 开发模式: ./start-dev.sh
   • 查看日志: docker compose logs -f
   • 查看状态: docker compose ps
" $GREEN
}

# 运行主函数
main "$@"
