#!/usr/bin/env python3
"""
LangGraph 开发服务器启动脚本
"""

import os
import uvicorn
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

# 创建 FastAPI 应用
app = FastAPI(title="LangGraph Agent API", version="1.0.0")

# 添加 CORS 中间件
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
async def root():
    return {"message": "LangGraph Agent API is running"}

@app.get("/health")
async def health():
    return {"status": "healthy"}

# 添加 LangGraph 相关的路由
@app.post("/threads")
async def create_thread():
    return {"thread_id": "test-thread-123"}

@app.get("/threads/{thread_id}")
async def get_thread(thread_id: str):
    return {"thread_id": thread_id, "status": "active"}

@app.post("/threads/{thread_id}/runs")
async def create_run(thread_id: str):
    return {"run_id": "test-run-123", "thread_id": thread_id}

def main():
    """启动 LangGraph 开发服务器"""
    # 设置环境变量
    os.environ.setdefault("LANGGRAPH_ENV", "development")
    
    # 启动服务器
    uvicorn.run(
        "server:app",
        host="0.0.0.0",
        port=8000,
        reload=True,
        log_level="info"
    )

if __name__ == "__main__":
    main()
