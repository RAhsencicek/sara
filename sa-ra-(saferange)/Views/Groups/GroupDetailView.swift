//
//  GroupDetailView.swift
//  sa-ra-(saferange)
//
//  Created by Ahsen on 29.12.2024.
//

import SwiftUI

struct GroupDetailView: View {
    let group: Group
    
    var body: some View {
        List {
            Section("Grup Bilgileri") {
                // Grup adı
                HStack {
                    Text("Grup Adı")
                        .foregroundStyle(.gray)
                    Spacer()
                    Text(group.name)
                }
                
                // Rehber bilgisi
                HStack {
                    Text("Rehber")
                        .foregroundStyle(.gray)
                    Spacer()
                    Text(group.guideId)
                }
                
                // Tarih bilgileri
                if let startDate = group.startDate {
                    HStack {
                        Text("Başlangıç")
                            .foregroundStyle(.gray)
                        Spacer()
                        Text(startDate.formatted(date: .numeric, time: .omitted))
                    }
                }
                
                if let endDate = group.endDate {
                    HStack {
                        Text("Bitiş")
                            .foregroundStyle(.gray)
                        Spacer()
                        Text(endDate.formatted(date: .numeric, time: .omitted))
                    }
                }
            }
            
            // Mesajlaşma bölümü (şimdilik boş)
            Section("Mesajlar") {
                Text("Mesajlaşma yakında eklenecek")
                    .foregroundStyle(.gray)
            }
        }
        .navigationTitle(group.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Önizleme için örnek veri
#Preview {
    NavigationView {
        GroupDetailView(
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
