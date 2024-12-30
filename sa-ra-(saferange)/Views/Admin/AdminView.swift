//
//  AdminView.swift
//  sa-ra-(saferange)
//
//  Created by Ahsen on 29.12.2024.
//

import SwiftUI

struct AdminView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @StateObject private var groupViewModel = GroupViewModel()
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
                    ForEach(groupViewModel.groups) { group in
                        NavigationLink(destination: AdminGroupDetailView(group: group)) {
                            VStack(alignment: .leading) {
                                Text(group.name)
                                    .font(.headline)
                                Text("\(group.description ?? "")")
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                            }
                        }
                    }
                    .onDelete(perform: groupViewModel.deleteGroup)
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
                    .environmentObject(groupViewModel)
            }
        }
    }
}

// Preview
struct AdminView_Previews: PreviewProvider {
    static var previews: some View {
        AdminView()
            .environmentObject(AppViewModel())
    }
}
