// 
//  User.swift
//  sa-ra-(saferange)
//
//  Created by Ahsen on 29.12.2024.
//

import Foundation

// Kullanıcı rolleri için enum
enum UserRole: String, Codable {
    case user = "user"
    case guide = "guide"
    case admin = "admin"
}

// Kullanıcı durumu için enum
enum UserStatus: String, Codable {
    case active = "active"
    case blocked = "blocked"
    case deleted = "deleted"
}

// Kullanıcı modeli
struct User: Codable, Identifiable {
    // API'den gelen ID
    let id: String
    
    // Temel bilgiler
    let phoneNumber: String
    var firstName: String?
    var lastName: String?
    var email: String?
    
    // Sistem bilgileri
    let role: UserRole
    let isVerified: Bool
    let status: UserStatus
    
    // Özel CodingKeys tanımlaması
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case phoneNumber
        case firstName
        case lastName
        case email
        case role
        case isVerified
        case status
    }
    
    // Tam adı döndüren hesaplanmış özellik
    var fullName: String {
        if let firstName = firstName, let lastName = lastName {
            return "\(firstName) \(lastName)"
        } else if let firstName = firstName {
            return firstName
        } else if let lastName = lastName {
            return lastName
        }
        return phoneNumber
    }
}
