//
//  ChatMessage.swift
//  iantha
//
//  Created by Taylor Meek on 4/4/23.
//

import Foundation

enum ChatMessageType {
    case user
    case iantha
}

struct ChatMessage: Identifiable {
    let id: UUID
    let type: ChatMessageType
    let content: String
    let timestamp: Date

    init(id: UUID = UUID(), type: ChatMessageType, content: String, timestamp: Date = Date()) {
        self.id = id
        self.type = type
        self.content = content
        self.timestamp = timestamp
    }
}
