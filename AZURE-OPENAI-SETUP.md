# Azure OpenAI 配置指南

本项目已配置支持 Azure OpenAI 服务。以下是详细的配置步骤。

## 🔧 配置步骤

### 1. 获取 Azure OpenAI 配置信息

在 Azure 门户中，您需要获取以下信息：

- **API Key**: Azure OpenAI 资源的 API 密钥
- **Endpoint**: Azure OpenAI 资源的终结点 URL
- **Deployment Name**: 部署的模型名称（如 gpt-4o, gpt-35-turbo 等）
- **API Version**: API 版本（推荐使用 2024-02-15-preview）

### 2. 配置环境变量

#### 方法一：使用 .env 文件（推荐）

复制环境变量示例文件：

```bash
cp backend/env.example backend/.env
```

编辑 `backend/.env` 文件，填入您的 Azure OpenAI 配置：

```bash
# Azure OpenAI 配置
AZURE_OPENAI_API_KEY=your_actual_api_key_here
AZURE_OPENAI_ENDPOINT=https://your-resource-name.openai.azure.com/
AZURE_OPENAI_DEPLOYMENT_NAME=gpt-4o
AZURE_OPENAI_API_VERSION=2024-02-15-preview
```

#### 方法二：使用系统环境变量

```bash
export AZURE_OPENAI_API_KEY="your_actual_api_key_here"
export AZURE_OPENAI_ENDPOINT="https://your-resource-name.openai.azure.com/"
export AZURE_OPENAI_DEPLOYMENT_NAME="gpt-4o"
export AZURE_OPENAI_API_VERSION="2024-02-15-preview"
```

### 3. 验证配置

#### 开发环境验证

```bash
# 启动开发环境
./start-dev.sh

# 检查后端日志
tail -f logs/backend.log
```

#### 生产环境验证

```bash
# 启动生产环境
./start.sh

# 检查服务状态
docker compose ps

# 检查后端日志
docker compose logs backend
```

## 📋 配置参数说明

| 参数 | 描述 | 示例值 | 必需 |
|------|------|--------|------|
| `AZURE_OPENAI_API_KEY` | Azure OpenAI API 密钥 | `abc123...` | ✅ |
| `AZURE_OPENAI_ENDPOINT` | Azure OpenAI 终结点 URL | `https://your-resource.openai.azure.com/` | ✅ |
| `AZURE_OPENAI_DEPLOYMENT_NAME` | 部署的模型名称 | `gpt-4o` | ✅ |
| `AZURE_OPENAI_API_VERSION` | API 版本 | `2024-02-15-preview` | ❌ |

## 🔍 故障排除

### 1. 认证错误

**错误信息**: `AuthenticationError` 或 `401 Unauthorized`

**解决方案**:
- 检查 API Key 是否正确
- 确认 API Key 是否有效且未过期
- 验证终结点 URL 格式是否正确

### 2. 模型未找到

**错误信息**: `ModelNotFoundError` 或 `404 Not Found`

**解决方案**:
- 检查部署名称是否正确
- 确认模型是否已在 Azure OpenAI 中部署
- 验证 API 版本是否支持该模型

### 3. 网络连接问题

**错误信息**: `ConnectionError` 或 `TimeoutError`

**解决方案**:
- 检查网络连接
- 确认防火墙设置
- 验证终结点 URL 是否可访问

### 4. 配额限制

**错误信息**: `RateLimitError` 或 `429 Too Many Requests`

**解决方案**:
- 检查 Azure OpenAI 配额限制
- 考虑升级服务计划
- 实现请求重试机制

## 🧪 测试配置

### 使用 curl 测试

```bash
# 测试 Azure OpenAI 连接
curl -X POST "https://your-resource.openai.azure.com/openai/deployments/gpt-4o/chat/completions?api-version=2024-02-15-preview" \
  -H "Content-Type: application/json" \
  -H "api-key: your_api_key_here" \
  -d '{
    "messages": [
      {
        "role": "user",
        "content": "Hello, world!"
      }
    ]
  }'
```

### 使用 Python 测试

```python
import os
from langchain_openai import AzureChatOpenAI

# 测试 Azure OpenAI 连接
model = AzureChatOpenAI(
    azure_deployment="gpt-4o",
    azure_endpoint=os.getenv("AZURE_OPENAI_ENDPOINT"),
    api_key=os.getenv("AZURE_OPENAI_API_KEY"),
    api_version="2024-02-15-preview"
)

# 发送测试消息
response = model.invoke("Hello, world!")
print(response.content)
```

## 🔒 安全建议

1. **保护 API Key**: 永远不要将 API Key 提交到版本控制系统
2. **使用环境变量**: 优先使用环境变量而不是硬编码
3. **定期轮换**: 定期更新 API Key
4. **最小权限**: 只授予必要的权限
5. **监控使用**: 定期检查 API 使用情况

## 📚 相关资源

- [Azure OpenAI 官方文档](https://docs.microsoft.com/en-us/azure/cognitive-services/openai/)
- [LangChain Azure OpenAI 集成](https://python.langchain.com/docs/integrations/llms/azure_openai)
- [Azure OpenAI 定价](https://azure.microsoft.com/en-us/pricing/details/cognitive-services/openai-service/)

## 🆘 获取帮助

如果遇到问题，请检查：

1. 环境变量是否正确配置
2. 网络连接是否正常
3. Azure OpenAI 服务是否可用
4. 查看详细的错误日志

```bash
# 查看详细日志
docker compose logs backend -f

# 或开发环境
tail -f logs/backend.log
```
