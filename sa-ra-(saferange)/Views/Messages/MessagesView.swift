//
//  MessagesView.swift
//  sa-ra-(saferange)
//
//  Created by Ahsen on 31.12.2024.
//

import SwiftUI

struct MessagesView: View {
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            List {
                ForEach(getMessages().filter {
                    searchText.isEmpty ? true : $0.senderName.localizedCaseInsensitiveContains(searchText)
                }) { message in
                    MessageRowView(message: message)
                }
            }
            .navigationTitle("Mesajlar")
            .searchable(text: $searchText, prompt: "Mesaj Ara")
        }
    }
    
    private func getMessages() -> [Message] {
        return [
            Message(content: "Merhaba, nasılsınız?", senderName: "Ahmet Yılmaz"),
            Message(content: "Konum bilgisi paylaşabilir misiniz?", senderName: "Mehmet Demir", isRead: true),
            Message(content: "Grup fotoğrafını aldım, teşekkürler!", senderName: "Ayşe Kaya", isRead: true)
        ]
    }
}

struct MessageRowView: View {
    let message: Message
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text(message.senderName)
                        .font(.headline)
                    if !message.isRead {
                        Circle()
                            .fill(.blue)
                            .frame(width: 8, height: 8)
                    }
                }
                
                Text(message.content)
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    .lineLimit(2)
            }
            
            Spacer()
            
            Text(message.timestamp, style: .time)
                .font(.caption)
                .foregroundStyle(.gray)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    MessagesView()
}
