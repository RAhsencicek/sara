//
//  Models.swift
//  sa-ra-(saferange)
//
//  Created by Ahsen on 31.12.2024.
//

import Foundation

struct Message: Identifiable {
    let id = UUID()
    var content: String
    var timestamp: Date = Date()
    var senderName: String
    var isFromAdmin: Bool = false
    var isRead: Bool = false
    
    init(content: String, senderName: String, isFromAdmin: Bool = false, isRead: Bool = false) {
        self.content = content
        self.senderName = senderName
        self.isFromAdmin = isFromAdmin
        self.isRead = isRead
    }
}

struct Chat: Identifiable {
    let id: String
    let groupName: String
    let lastMessage: String
    let lastMessageTime: String
    let unreadCount: Int
    let messages: [Message]
}
