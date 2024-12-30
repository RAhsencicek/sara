//
//  Group.swift
//  sa-ra-(saferange)
//
//  Created by Ahsen on 29.12.2024.
//

import Foundation

struct Group: Identifiable, Codable {
    let id: String
    let name: String
    let description: String?
    let guideId: String
    let startDate: Date?
    let endDate: Date?
    let isActive: Bool
    
    // API'den gelen tarihler için özel CodingKeys
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case description
        case guideId = "guide"
        case startDate
        case endDate
        case isActive
    }
}

// Grup detay görünümü için model
struct GroupDetail: Codable {
    let group: Group
    let members: [GroupMember]
    let invitations: [GroupInvitation]
}

// Grup üyesi modeli
struct GroupMember: Codable, Identifiable {
    var id: String { user.id }
    let user: User
    let status: String
    let joinedAt: Date
}

// Grup daveti modeli
struct GroupInvitation: Codable, Identifiable {
    var id: String { user.id }
    let user: User
    let status: String
    let invitedAt: Date
    let expiresAt: Date
}
