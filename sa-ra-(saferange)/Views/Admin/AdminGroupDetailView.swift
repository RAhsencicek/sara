//
//  AdminGroupDetailView.swift
//  sa-ra-(saferange)
//
//  Created by Ahsen on 29.12.2024.
//

import SwiftUI

// Mock yapılar
struct MockMember: Identifiable {
    let id: String
    let name: String
    let phone: String
    let bluetoothEnabled: Bool
}

struct AdminGroupDetailView: View {
    let group: Group
    
    @State private var showingInviteSheet = false
    @State private var showingBluetoothSheet = false
    @State private var newMessage = ""
    
    var body: some View {
        List {
            // Grup Bilgileri
            Section("Grup Bilgileri") {
                LabeledContent("Grup Adı", value: group.name)
                if let description = group.description {
                    LabeledContent("Açıklama", value: description)
                }
                if let startDate = group.startDate {
                    LabeledContent("Başlangıç", value: startDate.formatted(date: .numeric, time: .omitted))
                }
                if let endDate = group.endDate {
                    LabeledContent("Bitiş", value: endDate.formatted(date: .numeric, time: .omitted))
                }
            }
            
            // Üye Yönetimi
            Section("Üyeler") {
                Button(action: {
                    showingInviteSheet = true
                }) {
                    Label("Üye Davet Et", systemImage: "person.badge.plus")
                        .foregroundStyle(.blue)
                }
                
                ForEach(getMembers()) { member in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(member.name)
                            Text(member.phone)
                                .font(.caption)
                                .foregroundStyle(.gray)
                        }
                        
                        Spacer()
                        
                        // Bluetooth durumu
                        Image(systemName: member.bluetoothEnabled ? "wave.3.right.circle.fill" : "wave.3.right.circle")
                            .foregroundStyle(member.bluetoothEnabled ? .blue : .gray)
                    }
                }
            }
            
            // Mesajlaşma
            Section("Mesaj Gönder") {
                TextField("Mesajınız...", text: $newMessage)
                Button(action: sendMessage) {
                    Text("Gönder")
                        .frame(maxWidth: .infinity)
                }
                .disabled(newMessage.isEmpty)
            }
            
            // Bluetooth Ayarları
            Section {
                Button(action: {
                    showingBluetoothSheet = true
                }) {
                    Label("Bluetooth Ayarları", systemImage: "wave.3.right.circle.fill")
                }
            }
        }
        .navigationTitle(group.name)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingInviteSheet) {
            InviteMembersView(group: group)
        }
        .sheet(isPresented: $showingBluetoothSheet) {
            BluetoothSettingsView(group: group)
        }
    }
    
    private func sendMessage() {
        // TODO: Implement message sending
        newMessage = ""
    }
    
    private func getMembers() -> [MockMember] {
        return [
            MockMember(id: "1", name: "Ahmet Yılmaz", phone: "+90 555 111 2233", bluetoothEnabled: true),
            MockMember(id: "2", name: "Ayşe Demir", phone: "+90 555 444 5566", bluetoothEnabled: false),
            MockMember(id: "3", name: "Mehmet Kaya", phone: "+90 555 777 8899", bluetoothEnabled: true)
        ]
    }
}

// Placeholder Views
struct InviteMembersView: View {
    let group: Group
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            List {
                // TODO: Implement invite UI
                Text("Üye davet etme arayüzü")
            }
            .navigationTitle("Üye Davet Et")
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
}

struct BluetoothSettingsView: View {
    let group: Group
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            List {
                // TODO: Implement Bluetooth settings UI
                Text("Bluetooth ayarları arayüzü")
            }
            .navigationTitle("Bluetooth Ayarları")
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
}

#Preview {
    NavigationView {
        AdminGroupDetailView(
            group: Group(
                id: "1",
                name: "Roma Turu",
                description: "7 günlük Roma turu",
                guideId: "guide1",
                startDate: Date(),
                endDate: Date().addingTimeInterval(7*24*60*60),
                isActive: true
            )
        )
    }
}
