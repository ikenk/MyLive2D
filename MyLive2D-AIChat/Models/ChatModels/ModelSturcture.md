Character (id: UUID-1)
  ├── CharacterSettings
  └── Conversations
       ├── Conversation (id: UUID-A, characterId: UUID-1)
       │    ├── Message (id: UUID-a1, conversationId: UUID-A)
       │    └── Message (id: UUID-a2, conversationId: UUID-A)
       └── Conversation (id: UUID-B, characterId: UUID-1)
            ├── Message (id: UUID-b1, conversationId: UUID-B)
            └── Message (id: UUID-b2, conversationId: UUID-B)


OpenAI API通信格式
{
    "model": "模型名称",
    "messages": [
     {"role": "system", "content": "你是一个有用的助手。"},
     {"role": "user", "content": "你好！"},
     {"role": "assistant", "content": "你好！有什么我可以帮助你的吗？"},
     {"role": "user", "content": "请解释量子计算。"}
    ],
    "temperature": 0.7,
    "max_tokens": 800,
    "stream": false
}
