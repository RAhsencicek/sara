//
//  AdminChatView.swift
//  sa-ra-(saferange)
//
//  Created by Ahsen on 31.12.2024.
//

import SwiftUI

// Mock veri yapıları
struct MockChat: Identifiable {
    let id: String
    let groupName: String
    let lastMessage: String
    let lastMessageTime: String
    let unreadCount: Int
    let messages: [MockMessage]
}

struct MockMessage: Identifiable {
    let id: String
    let content: String
    let timestamp: Date
    let isFromAdmin: Bool
}

struct AdminChatView: View {
    @State private var selectedChat: MockChat?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(getChats()) { chat in
                    Button(action: {
                        selectedChat = chat
                    }) {
                        ChatRowView(chat: chat)
                    }
                }
            }
            .navigationTitle("Grup Mesajları")
            .sheet(item: $selectedChat) { chat in
                ChatDetailView(chat: chat)
            }
        }
    }
    
    func getChats() -> [MockChat] {
        return [
            MockChat(
                id: "1",
                groupName: "Roma Turu",
                lastMessage: "Yarın saat 9'da buluşuyoruz",
                lastMessageTime: "14:30",
                unreadCount: 3,
                messages: [
                    MockMessage(id: "1", content: "Merhaba grup!", timestamp: Date(), isFromAdmin: true),
                    MockMessage(id: "2", content: "Yarın saat 9'da buluşuyoruz", timestamp: Date(), isFromAdmin: true),
                    MockMessage(id: "3", content: "Tamam, teşekkürler", timestamp: Date(), isFromAdmin: false)
                ]
            ),
            MockChat(
                id: "2",
                groupName: "Paris Turu",
                lastMessage: "Hava durumu nasıl?",
                lastMessageTime: "13:15",
                unreadCount: 0,
                messages: [
                    MockMessage(id: "4", content: "Herkese iyi günler", timestamp: Date(), isFromAdmin: true),
                    MockMessage(id: "5", content: "Hava durumu nasıl?", timestamp: Date(), isFromAdmin: false)
                ]
            )
        ]
    }
}

struct ChatRowView: View {
    let chat: MockChat
    
    var body: some View {
        HStack {
            // Grup ikonu
            Circle()
                .fill(.blue.opacity(0.2))
                .frame(width: 50, height: 50)
                .overlay {
                    Text(chat.groupName.prefix(1))
                        .font(.title2)
                        .foregroundStyle(.blue)
                }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(chat.groupName)
                    .font(.headline)
                Text(chat.lastMessage)
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    .lineLimit(1)
            }
            
            Spacer()
            
            // Zaman ve okunmamış mesaj sayısı
            VStack(alignment: .trailing, spacing: 4) {
                Text(chat.lastMessageTime)
                    .font(.caption)
                    .foregroundStyle(.gray)
                
                if chat.unreadCount > 0 {
                    Text("\(chat.unreadCount)")
                        .font(.caption)
                        .foregroundStyle(.white)
                        .padding(6)
                        .background(.blue)
                        .clipShape(Circle())
                }
            }
        }
        .padding(.vertical, 4)
    }
}

struct ChatDetailView: View {
    let chat: MockChat
    @Environment(\.dismiss) var dismiss
    @State private var newMessage = ""
    
    var body: some View {
        NavigationView {
            VStack {
                List(chat.messages) { message in
                    MessageBubbleView(message: message)
                }
                
                // Mesaj gönderme alanı
                HStack {
                    TextField("Mesajınız...", text: $newMessage)
                        .textFieldStyle(.roundedBorder)
                    
                    Button(action: sendMessage) {
                        Image(systemName: "paperplane.fill")
                            .foregroundStyle(.blue)
                    }
                }
                .padding()
            }
            .navigationTitle(chat.groupName)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Kapat") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func sendMessage() {
        // TODO: Implement message sending
        newMessage = ""
    }
}

struct MessageBubbleView: View {
    let message: MockMessage
    
    var body: some View {
        HStack {
            if message.isFromAdmin {
                Spacer()
            }
            
            Text(message.content)
                .padding(10)
                .background(message.isFromAdmin ? .blue : .gray.opacity(0.2))
                .foregroundStyle(message.isFromAdmin ? .white : .primary)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            if !message.isFromAdmin {
                Spacer()
            }
        }
    }
}

#Preview {
    AdminChatView()
}
