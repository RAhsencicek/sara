//
//  SettingsView.swift
//  sa-ra-(saferange)
//
//  Created by Ahsen on 29.12.2024.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    
    var body: some View {
        NavigationView {
            List {
                // Profil Bölümü
                Section("Profil") {
                    if let user = appViewModel.currentUser {
                        Text(user.fullName)
                        Text(user.phoneNumber)
                            .foregroundStyle(.gray)
                        Text("Rol: \(user.role.rawValue.capitalized)")
                            .foregroundStyle(.gray)
                    }
                }
                
                // Uygulama Ayarları
                Section("Uygulama") {
                    Toggle("Bildirimleri Aç", isOn: .constant(true))
                    Toggle("Konum Paylaşımı", isOn: .constant(true))
                }
                
                // Çıkış Yap Butonu
                Section {
                    Button(action: {
                        appViewModel.logout()
                    }) {
                        Text("Çıkış Yap")
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle("Ayarlar")
        }
    }
}

// Önizleme
#Preview {
    SettingsView()
        .environmentObject(AppViewModel())
}
