// 
//  User.swift
//  sa-ra-(saferange)
//
//  Created by Ahsen on 29.12.2024.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

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
    // Firebase ID
    @DocumentID var id: String?
    
    // Temel bilgiler
    let phoneNumber: String
    var firstName: String?
    var lastName: String?
    var email: String?
    
    // Sistem bilgileri
    var role: UserRole = .user
    var isVerified: Bool = false
    var status: UserStatus = .active
    
    // Zaman damgaları
    let createdAt: Date
    var updatedAt: Date
    
    // Firebase'den veri oluşturma
    static func fromFirebaseUser(_ firebaseUser: FirebaseAuth.User) -> User {
        return User(
            phoneNumber: firebaseUser.phoneNumber ?? "",
            createdAt: firebaseUser.metadata.creationDate ?? Date(),
            updatedAt: firebaseUser.metadata.lastSignInDate ?? Date()
        )
    }
    
    // Firestore'a kaydetmek için
    func toFirestore() -> [String: Any] {
        return [
            "phoneNumber": phoneNumber,
            "firstName": firstName as Any,
            "lastName": lastName as Any,
            "email": email as Any,
            "role": role.rawValue,
            "isVerified": isVerified,
            "status": status.rawValue,
            "createdAt": createdAt,
            "updatedAt": updatedAt
        ]
    }
}
