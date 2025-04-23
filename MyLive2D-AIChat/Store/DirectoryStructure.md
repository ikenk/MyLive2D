//
//  DirectoryStructure.swift
//  MyLive2D
//
//  Created by HT Zhang  on 2025/04/23.
//

Documents/
├── Characters/
│   ├── {characterId}/  # 角色目录
│   │   ├── character.json                     # 角色基本信息
│   │   └── Conversations/                     # 角色对话目录
│   │       ├── {conversationId}.json   // 各个对话

Documents/
├── Characters/
│   ├── 123e4567-e89b-12d3-a456-426614174000/  # 角色1的目录
│   │   ├── character.json                     # 角色1的基本信息
│   │   └── Conversations/                     # 角色1的对话目录
│   │       ├── 987e6543-e89b-12d3-a456-426614174000.json  # 对话1
│   │       └── 876e5432-e89b-12d3-a456-426614174001.json  # 对话2
│   └── 234e5678-e89b-12d3-a456-426614174001/  # 角色2的目录
│       ├── character.json                     # 角色2的基本信息
│       └── Conversations/                     # 角色2的对话目录
│           └── 765e4321-e89b-12d3-a456-426614174000.json  # 对话1
