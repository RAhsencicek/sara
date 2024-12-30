//
//  GroupsView.swift
//  sa-ra-(saferange)
//
//  Created by Ahsen on 29.12.2024.
//

import SwiftUI

struct GroupsView: View {
    // Örnek grup verileri (daha sonra API'den alınacak)
    @State private var groups = [
        Group(id: "1", name: "Roma Turu", description: "7 günlük Roma turu", guideId: "guide1", startDate: Date(), endDate: Date().addingTimeInterval(7*24*60*60), isActive: true),
        Group(id: "2", name: "Paris Turu", description: "5 günlük Paris turu", guideId: "guide2", startDate: Date(), endDate: Date().addingTimeInterval(5*24*60*60), isActive: true),
        Group(id: "3", name: "İstanbul Turu", description: "3 günlük İstanbul turu", guideId: "guide3", startDate: Date(), endDate: Date().addingTimeInterval(3*24*60*60), isActive: true)
    ]
    
    var body: some View {
        NavigationView {
            List(groups) { group in
                GroupRowView(group: group)
            }
            .navigationTitle("Gruplar")
            .toolbar {
                // Rehber veya admin ise grup oluşturma butonu göster
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: createNewGroup) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
    
    private func createNewGroup() {
        // Grup oluşturma işlemi
        print("Yeni grup oluştur")
    }
}

struct GroupRowView: View {
    let group: Group
    
    var body: some View {
        NavigationLink(destination: GroupDetailView(group: group)) {
            VStack(alignment: .leading, spacing: 8) {
                Text(group.name)
                    .font(.headline)
                
                HStack {
                    Image(systemName: "person.2")
                    Text("Rehber: \(group.guideId)")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                }
            }
            .padding(.vertical, 4)
        }
    }
}

// Önizleme
#Preview {
    GroupsView()
        .environmentObject(AppViewModel())
}
