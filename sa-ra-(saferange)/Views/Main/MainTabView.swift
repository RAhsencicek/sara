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
        TabView(selection: $selectedTab) {
            // Gruplar Tab'ı
            GroupsView()
                .tabItem {
                    Label("Gruplar", systemImage: "person.3")
                }
                .tag(0)
            
            // Konum Tab'ı
            LocationView()
                .tabItem {
                    Label("Konum", systemImage: "location")
                }
                .tag(1)
            
            // Ayarlar Tab'ı
            SettingsView()
                .tabItem {
                    Label("Ayarlar", systemImage: "gear")
                }
                .tag(2)
        }
    }
}

// Önizleme
#Preview {
    MainTabView()
        .environmentObject(AppViewModel())
}
