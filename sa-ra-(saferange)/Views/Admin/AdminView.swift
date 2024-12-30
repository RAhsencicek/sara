//
//  AdminView.swift
//  sa-ra-(saferange)
//
//  Created by Ahsen on 29.12.2024.
//

import SwiftUI

struct AdminView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @State private var selectedGroup: Group?
    @State private var showingCreateGroupSheet = false
    
    var body: some View {
        NavigationView {
            List {
                // Gruplar Bölümü
                Section("Gruplarım") {
                    // Grup Oluştur Butonu
                    Button(action: {
                        showingCreateGroupSheet = true
                    }) {
                        Label("Yeni Grup Oluştur", systemImage: "plus.circle.fill")
                            .foregroundStyle(.blue)
                    }
                    
                    // Mevcut Gruplar
                    ForEach(MockData.groups) { group in
                        NavigationLink(destination: AdminGroupDetailView(group: group)) {
                            VStack(alignment: .leading) {
                                Text(group.name)
                                    .font(.headline)
                                Text("\(MockData.getMemberCount(for: group.id)) Üye")
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                            }
                        }
                    }
                }
                
                // Bluetooth Yönetimi
                Section("Bluetooth Yönetimi") {
                    NavigationLink(destination: BluetoothManagementView()) {
                        Label("Bluetooth Ayarları", systemImage: "wave.3.right.circle.fill")
                    }
                }
                
                // Çıkış
                Section {
                    Button(action: {
                        appViewModel.logout()
                    }) {
                        Text("Çıkış Yap")
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle("Rehber Paneli")
            .sheet(isPresented: $showingCreateGroupSheet) {
                CreateGroupView()
            }
        }
    }
}

// Geçici mock data
struct MockData {
    static let groups = [
        Group(id: "1", name: "Roma Turu", description: "7 günlük Roma turu", guideId: "guide1", startDate: Date(), endDate: Date().addingTimeInterval(7*24*60*60), isActive: true),
        Group(id: "2", name: "Paris Turu", description: "5 günlük Paris turu", guideId: "guide2", startDate: Date(), endDate: Date().addingTimeInterval(5*24*60*60), isActive: true)
    ]
    
    static func getMemberCount(for groupId: String) -> Int {
        return Int.random(in: 5...20) // Mock veri
    }
}

#Preview {
    AdminView()
        .environmentObject(AppViewModel())
}
