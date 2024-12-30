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
    let messages: [Message]
}

struct AdminChatView: View {
    @State private var selectedChat: MockChat?
    @State private var showingBulkMessageSheet = false
    @State private var bulkMessage = ""
    @State private var selectedGroups: Set<String> = []
    @FocusState private var isMessageFieldFocused: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section {
                        Button(action: {
                            showingBulkMessageSheet = true
                            // Varsayılan olarak tüm grupları seç
                            selectedGroups = Set(getChats().map { $0.id })
                        }) {
                            Label("Toplu Mesaj Gönder", systemImage: "message.badge.circle.fill")
                                .foregroundStyle(.blue)
                        }
                    }
                    
                    Section {
                        ForEach(getChats()) { chat in
                            Button(action: {
                                selectedChat = chat
                            }) {
                                ChatRowView(chat: chat)
                            }
                        }
                    }
                }
                .navigationTitle("Grup Mesajları")
                .sheet(item: $selectedChat) { chat in
                    ChatDetailView(chat: chat)
                }
                .sheet(isPresented: $showingBulkMessageSheet) {
                    NavigationView {
                        VStack(spacing: 0) {
                            List {
                                Section {
                                    HStack {
                                        Text("Tüm Grupları Seç")
                                        Spacer()
                                        Toggle("", isOn: Binding(
                                            get: {
                                                selectedGroups.count == getChats().count
                                            },
                                            set: { newValue in
                                                if newValue {
                                                    selectedGroups = Set(getChats().map { $0.id })
                                                } else {
                                                    selectedGroups.removeAll()
                                                }
                                            }
                                        ))
                                    }
                                }
                                
                                Section("Alıcı Gruplar") {
                                    ForEach(getChats()) { chat in
                                        HStack {
                                            Text(chat.groupName)
                                            Spacer()
                                            Image(systemName: selectedGroups.contains(chat.id) ? "checkmark.circle.fill" : "circle")
                                                .foregroundStyle(selectedGroups.contains(chat.id) ? .blue : .gray)
                                        }
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                            if selectedGroups.contains(chat.id) {
                                                selectedGroups.remove(chat.id)
                                            } else {
                                                selectedGroups.insert(chat.id)
                                            }
                                        }
                                    }
                                }
                                
                                if !selectedGroups.isEmpty {
                                    Section("Mesajınız") {
                                        TextEditor(text: $bulkMessage)
                                            .frame(height: 100)
                                            .focused($isMessageFieldFocused)
                                    }
                                }
                            }
                            
                            // Seçili grup sayısı ve gönder butonu
                            VStack(spacing: 8) {
                                if !selectedGroups.isEmpty {
                                    Text("\(selectedGroups.count) grup seçildi")
                                        .font(.caption)
                                        .foregroundStyle(.gray)
                                }
                                
                                Button(action: sendBulkMessage) {
                                    Text("Gönder")
                                        .font(.headline)
                                        .foregroundStyle(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background((!selectedGroups.isEmpty && !bulkMessage.isEmpty) ? .blue : .gray)
                                        .cornerRadius(10)
                                }
                                .disabled(selectedGroups.isEmpty || bulkMessage.isEmpty)
                            }
                            .padding()
                        }
                        .navigationTitle("Toplu Mesaj")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("İptal") {
                                    showingBulkMessageSheet = false
                                    selectedGroups.removeAll()
                                    bulkMessage = ""
                                }
                            }
                        }
                        .onAppear {
                            isMessageFieldFocused = true
                        }
                    }
                }
            }
        }
    }
    
    private func sendBulkMessage() {
        // TODO: Implement bulk message sending
        print("Mesaj gönderilecek gruplar: \(selectedGroups)")
        print("Mesaj içeriği: \(bulkMessage)")
        
        showingBulkMessageSheet = false
        selectedGroups.removeAll()
        bulkMessage = ""
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
                    Message(content: "Merhaba grup!", senderName: "Admin", isFromAdmin: true),
                    Message(content: "Yarın saat 9'da buluşuyoruz", senderName: "Admin", isFromAdmin: true),
                    Message(content: "Tamam, teşekkürler", senderName: "Ahmet Yılmaz")
                ]
            ),
            MockChat(
                id: "2",
                groupName: "Paris Turu",
                lastMessage: "Hava durumu nasıl?",
                lastMessageTime: "13:15",
                unreadCount: 0,
                messages: [
                    Message(content: "Herkese iyi günler", senderName: "Admin", isFromAdmin: true),
                    Message(content: "Hava durumu nasıl?", senderName: "Mehmet Demir")
                ]
            )
        ]
    }
}

struct ChatRowView: View {
    let chat: MockChat
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(chat.groupName)
                    .font(.headline)
                Text(chat.lastMessage)
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text(chat.lastMessageTime)
                    .font(.caption)
                    .foregroundStyle(.gray)
                
                if chat.unreadCount > 0 {
                    Text("\(chat.unreadCount)")
                        .font(.caption2)
                        .padding(6)
                        .background(.blue)
                        .foregroundStyle(.white)
                        .clipShape(Circle())
                }
            }
        }
    }
}

struct ChatDetailView: View {
    let chat: MockChat
    @State private var newMessage = ""
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            List(chat.messages) { message in
                MessageBubbleView(message: message)
            }
            
            HStack {
                TextField("Mesajınız...", text: $newMessage)
                    .textFieldStyle(.roundedBorder)
                
                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .foregroundStyle(.blue)
                }
                .disabled(newMessage.isEmpty)
            }
            .padding()
        }
        .navigationTitle(chat.groupName)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func sendMessage() {
        // TODO: Implement sending message
        newMessage = ""
    }
}

struct MessageBubbleView: View {
    let message: Message
    
    var body: some View {
        HStack {
            if message.isFromAdmin {
                Spacer()
            }
            
            VStack(alignment: message.isFromAdmin ? .trailing : .leading) {
                if !message.isFromAdmin {
                    Text(message.senderName)
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
                
                Text(message.content)
                    .padding(10)
                    .background(message.isFromAdmin ? .blue : .gray.opacity(0.2))
                    .foregroundStyle(message.isFromAdmin ? .white : .primary)
                    .cornerRadius(16)
            }
            
            if !message.isFromAdmin {
                Spacer()
            }
        }
    }
}

#Preview {
    AdminChatView()
}
