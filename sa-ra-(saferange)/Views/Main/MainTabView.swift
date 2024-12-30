//
//  MainTabView.swift
//  sa-ra-(saferange)
//
//  Created by Ahsen on 29.12.2024.
//

import SwiftUI

struct MainTabView: View {
    // Seçili tab'ı takip etmek için
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            TabView(selection: $selectedTab) {
                // Mesajlar Tab'ı
                MessagesView()
                    .tabItem {
                        Label("Mesajlar", systemImage: "message.fill")
                    }
                    .tag(0)
                
                // Gruplar Tab'ı
                GroupsView()
                    .tabItem {
                        Label("Gruplar", systemImage: "person.3.fill")
                    }
                    .tag(1)
                
                // Konum Tab'ı
                LocationView()
                    .tabItem {
                        Label("Harita", systemImage: "map.fill")
                    }
                    .tag(2)
                
                // Profil Tab'ı
                ProfileView()
                    .tabItem {
                        Label("Profil", systemImage: "person.fill")
                    }
                    .tag(3)
            }
            
            // Acil durum butonu
            EmergencyButtonView()
                .padding(.trailing, 16)
                .padding(.bottom, 90) // TabBar'ın üzerinde konumlandırma
        }
    }
}

// Önizleme
#Preview {
    MainTabView()
        .environmentObject(AppViewModel())
}
