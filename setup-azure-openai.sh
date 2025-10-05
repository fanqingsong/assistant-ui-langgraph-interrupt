#!/bin/bash

# Azure OpenAI 配置助手
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

# 配置 Azure OpenAI
configure_azure_openai() {
    print_message "
╔══════════════════════════════════════════════════════════════╗
║                Azure OpenAI 配置助手                        ║
║                                                              ║
║  🔧 帮助您快速配置 Azure OpenAI 环境变量                      ║
╚══════════════════════════════════════════════════════════════╝
" $BLUE
    
    # 检查是否存在 .env 文件
    if [ ! -f ".env" ]; then
        if [ -f "env.example" ]; then
            print_message "📝 创建环境变量文件..." $YELLOW
            cp env.example .env
        else
            print_message "❌ 环境变量示例文件不存在" $RED
            exit 1
        fi
    fi
    
    print_message "🔧 请提供您的 Azure OpenAI 配置信息：" $YELLOW
    
    # 获取 API Key
    read -p "请输入 Azure OpenAI API Key: " api_key
    if [ -z "$api_key" ]; then
        print_message "❌ API Key 不能为空" $RED
        exit 1
    fi
    
    # 获取 Endpoint
    read -p "请输入 Azure OpenAI Endpoint (例如: https://your-resource.openai.azure.com/): " endpoint
    if [ -z "$endpoint" ]; then
        print_message "❌ Endpoint 不能为空" $RED
        exit 1
    fi
    
    # 确保 endpoint 以 / 结尾
    if [[ ! "$endpoint" =~ /$ ]]; then
        endpoint="${endpoint}/"
    fi
    
    # 获取 Deployment Name
    read -p "请输入 Deployment Name (默认: gpt-4o): " deployment_name
    deployment_name=${deployment_name:-gpt-4o}
    
    # 获取 API Version
    read -p "请输入 API Version (默认: 2024-02-15-preview): " api_version
    api_version=${api_version:-2024-02-15-preview}
    
    # 更新 .env 文件
    print_message "📝 更新环境变量文件..." $BLUE
    
    # 备份原文件
    cp .env .env.backup
    
    # 更新配置
    sed -i "s/AZURE_OPENAI_API_KEY=.*/AZURE_OPENAI_API_KEY=${api_key}/" .env
    sed -i "s|AZURE_OPENAI_ENDPOINT=.*|AZURE_OPENAI_ENDPOINT=${endpoint}|" .env
    sed -i "s/AZURE_OPENAI_DEPLOYMENT_NAME=.*/AZURE_OPENAI_DEPLOYMENT_NAME=${deployment_name}/" .env
    sed -i "s/AZURE_OPENAI_API_VERSION=.*/AZURE_OPENAI_API_VERSION=${api_version}/" .env
    
    print_message "✅ Azure OpenAI 配置完成！" $GREEN
    
    # 显示配置信息
    print_message "
📋 配置信息：
   • API Key: ${api_key:0:8}...
   • Endpoint: ${endpoint}
   • Deployment: ${deployment_name}
   • API Version: ${api_version}
" $BLUE
    
    # 询问是否测试配置
    print_message "🧪 是否要测试配置？(y/N)" $YELLOW
    read -r test_response
    
    if [[ "$test_response" =~ ^[Yy]$ ]]; then
        test_azure_openai
    fi
}

# 测试 Azure OpenAI 配置
test_azure_openai() {
    print_message "🧪 测试 Azure OpenAI 配置..." $BLUE
    
    # 检查 Python 环境
    if ! command -v python3 &> /dev/null; then
        print_message "❌ Python3 未安装，无法进行测试" $RED
        return 1
    fi
    
    # 创建测试脚本
    cat > test_azure_openai.py << 'EOF'
import os
import sys
from dotenv import load_dotenv

    # 加载环境变量
    load_dotenv('.env')

try:
    from langchain_openai import AzureChatOpenAI
    
    # 创建模型实例
    model = AzureChatOpenAI(
        azure_deployment=os.getenv("AZURE_OPENAI_DEPLOYMENT_NAME", "gpt-4o"),
        azure_endpoint=os.getenv("AZURE_OPENAI_ENDPOINT"),
        api_key=os.getenv("AZURE_OPENAI_API_KEY"),
        api_version=os.getenv("AZURE_OPENAI_API_VERSION", "2024-02-15-preview"),
        temperature=0.7,
    )
    
    # 发送测试消息
    print("发送测试消息...")
    response = model.invoke("Hello, world!")
    print(f"✅ 测试成功！响应: {response.content}")
    
except Exception as e:
    print(f"❌ 测试失败: {e}")
    sys.exit(1)
EOF
    
    # 运行测试
    if python3 test_azure_openai.py; then
        print_message "✅ Azure OpenAI 配置测试通过！" $GREEN
    else
        print_message "❌ Azure OpenAI 配置测试失败" $RED
        print_message "请检查配置信息是否正确" $YELLOW
    fi
    
    # 清理测试文件
    rm -f test_azure_openai.py
}

# 显示帮助信息
show_help() {
    print_message "
╔══════════════════════════════════════════════════════════════╗
║                Azure OpenAI 配置助手                        ║
║                                                              ║
║  🔧 帮助您快速配置 Azure OpenAI 环境变量                      ║
╚══════════════════════════════════════════════════════════════╝

用法: $0 [选项]

选项:
  -h, --help     显示帮助信息
  -t, --test     只测试现有配置
  -r, --reset    重置配置

示例:
  $0              # 交互式配置
  $0 --test       # 测试现有配置
  $0 --reset      # 重置配置
" $BLUE
}

# 重置配置
reset_config() {
    print_message "🔄 重置 Azure OpenAI 配置..." $YELLOW
    
    if [ -f ".env" ]; then
        # 恢复示例配置
        if [ -f "env.example" ]; then
            cp env.example .env
            print_message "✅ 配置已重置为示例配置" $GREEN
        else
            print_message "❌ 示例配置文件不存在" $RED
        fi
    else
        print_message "ℹ️  配置文件不存在，无需重置" $BLUE
    fi
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
            -t|--test)
                test_azure_openai
                exit 0
                ;;
            -r|--reset)
                reset_config
                exit 0
                ;;
            *)
                print_message "❌ 未知选项: $1" $RED
                show_help
                exit 1
                ;;
        esac
    done
    
    configure_azure_openai
}

# 运行主函数
main "$@"
