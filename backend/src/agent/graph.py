from langgraph.graph import StateGraph, START, END
from langgraph.types import interrupt
from langchain_openai import AzureChatOpenAI
from langgraph.graph import MessagesState
import os

# 配置 Azure OpenAI
model = AzureChatOpenAI(
    azure_deployment=os.getenv("AZURE_OPENAI_DEPLOYMENT_NAME", "gpt-4o"),
    azure_endpoint=os.getenv("AZURE_OPENAI_ENDPOINT"),
    api_key=os.getenv("AZURE_OPENAI_API_KEY"),
    api_version=os.getenv("AZURE_OPENAI_API_VERSION", "2024-02-15-preview"),
    temperature=0.7,
)
model = model.bind_tools(
    [
        {
            "type": "function",
            "function": {
                "name": "send_tweet",
                "description": "Call this function to generate a tweet on user request. The user will have the chance to review the tweet before it is sent.",
                "parameters": {
                    "type": "object",
                    "properties": {
                        "tweet": {
                            "type": "string",
                            "description": "The tweet contents",
                        },
                    },
                    "required": ["tweet"],
                },
            },
        }
    ]
)


async def agent(state):
    messages = state["messages"]
    response = await model.ainvoke(messages)
    return {"messages": response}


async def send_tweet(state):
    tool_call = state["messages"][-1].tool_calls[0]
    result = interrupt("Do you want to send this tweet?")
    if result != "yes":
        return {
            "messages": {
                "role": "tool",
                "tool_call_id": tool_call["id"],
                "content": "User rejected request",
            }
        }

    return {
        "messages": {
            "role": "tool",
            "tool_call_id": tool_call["id"],
            "content": "sent",
        }
    }


def should_continue(state):
    last_message = state["messages"][-1]
    if not last_message.tool_calls:
        return END

    last_tool_call = last_message.tool_calls[-1]
    if last_tool_call["name"] == "send_tweet":
        return "tools"

    return END


builder = StateGraph(MessagesState)

builder.add_node("llm", agent)
builder.add_node("tools", send_tweet)

builder.add_edge(START, "llm")
builder.add_edge("tools", "llm")
builder.add_edge("llm", END)

builder.add_conditional_edges(
    "llm",
    should_continue,
    ["tools", END],
)


graph = builder.compile()
