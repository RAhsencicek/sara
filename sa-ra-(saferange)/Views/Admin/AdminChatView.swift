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
