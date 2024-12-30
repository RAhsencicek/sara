//
//  GroupViewModel.swift
//  sa-ra-(saferange)
//
//  Created by Ahsen on 31.12.2024.
//

import Foundation

class GroupViewModel: ObservableObject {
    @Published var groups: [Group] = []
    
    init() {
        // Başlangıçta mock verileri yükle
        loadMockGroups()
    }
    
    private func loadMockGroups() {
        groups = [
            Group(id: "1", name: "Roma Turu", description: "7 günlük Roma turu", guideId: "guide1", startDate: Date(), endDate: Date().addingTimeInterval(7*24*60*60), isActive: true),
            Group(id: "2", name: "Paris Turu", description: "5 günlük Paris turu", guideId: "guide2", startDate: Date(), endDate: Date().addingTimeInterval(5*24*60*60), isActive: true)
        ]
    }
    
    func createGroup(name: String, description: String, startDate: Date, endDate: Date) {
        let newGroup = Group(
            id: UUID().uuidString,
            name: name,
            description: description,
            guideId: "currentGuide", // Gerçek uygulamada mevcut rehberin ID'si kullanılacak
            startDate: startDate,
            endDate: endDate,
            isActive: true
        )
        
        groups.append(newGroup)
        
        // TODO: Backend'e grup oluşturma isteği gönderilecek
        // APIService.shared.createGroup(group: newGroup)
    }
    
    func deleteGroup(at indexSet: IndexSet) {
        groups.remove(atOffsets: indexSet)
        
        // TODO: Backend'e silme isteği gönderilecek
    }
}
