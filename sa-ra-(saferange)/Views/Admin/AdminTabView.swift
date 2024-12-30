//
//  AdminTabView.swift
//  sa-ra-(saferange)
//
//  Created by Ahsen on 31.12.2024.
//

import SwiftUI

struct AdminTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Ana sohbet ekranı
            AdminChatView()
                .tabItem {
                    Label("Mesajlar", systemImage: "message.fill")
                }
                .tag(0)
            
            // Rehber paneli
            AdminView()
                .tabItem {
                    Label("Rehber", systemImage: "person.2.fill")
                }
                .tag(1)
            
            // Harita
            LocationView()
                .tabItem {
                    Label("Harita", systemImage: "map.fill")
                }
                .tag(2)
            
            // Acil çağrılar
            EmergencyCallsView()
                .tabItem {
                    Label("Acil", systemImage: "exclamationmark.triangle.fill")
                }
                .tag(3)
        }
    }
}

struct EmergencyCallsView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Acil Çağrılar")
                    .font(.title)
                    .foregroundStyle(.red)
            }
            .navigationTitle("Acil Çağrılar")
        }
    }
}

#Preview {
    AdminTabView()
        .environmentObject(AppViewModel())
}
