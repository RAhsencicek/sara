// 
//  APIService.swift
//  sa-ra-(saferange)
//
//  Created by Ahsen on 29.12.2024.
//

import Foundation

// API Hataları için enum
enum APIError: Error {
    case invalidURL
    case invalidResponse
    case noData
    case decodingError
    case serverError(String)
    case networkError(Error)
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Geçersiz URL"
        case .invalidResponse:
            return "Geçersiz sunucu yanıtı"
        case .noData:
            return "Veri alınamadı"
        case .decodingError:
            return "Veri işlenirken hata oluştu"
        case .serverError(let message):
            return message
        case .networkError(let error):
            return error.localizedDescription
        }
    }
}

// API Yanıtları için genel yapı
struct APIResponse<T: Codable>: Codable {
    let success: Bool
    let data: T?
    let message: String?
    let errors: [String: String]?
}

class APIService {
    // Singleton instance
    static let shared = APIService()
    
    // Base URL
    private let baseURL = "http://backend-sara.vercel.app/api"
    
    // Private init for singleton
    private init() {}
    
    // HTTP Headers
    private func headers(withToken: Bool = true) -> [String: String] {
        var headers = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        if withToken, let token = UserDefaults.standard.string(forKey: "accessToken") {
            headers["Authorization"] = "Bearer \(token)"
        }
        
        return headers
    }
    
    // Generic request function
    private func request<T: Codable>(
        endpoint: String,
        method: String = "GET",
        parameters: [String: Any]? = nil,
        withToken: Bool = true
    ) async throws -> T {
        guard let url = URL(string: baseURL + endpoint) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.allHTTPHeaderFields = headers(withToken: withToken)
        
        if let parameters = parameters {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            if let errorResponse = try? JSONDecoder().decode(APIResponse<String>.self, from: data) {
                throw APIError.serverError(errorResponse.message ?? "Sunucu hatası")
            }
            throw APIError.serverError("HTTP \(httpResponse.statusCode)")
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw APIError.decodingError
        }
    }
    
    // SMS doğrulama kodu gönderme
    func sendVerificationCode(phoneNumber: String) async throws -> String {
        // TODO: Backend hazır olduğunda gerçek API çağrısı yapılacak
        // Şimdilik test için mock yanıt
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 saniye bekle
        return "Doğrulama kodu gönderildi"
    }
    
    // SMS kodunu doğrulama
    func verifyCode(phoneNumber: String, code: String) async throws -> (User, String, String) {
        // TODO: Backend hazır olduğunda gerçek API çağrısı yapılacak
        // Şimdilik test için mock yanıt
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 saniye bekle
        
        // Test kodlarına göre farklı roller atama
        let role: UserRole
        switch code {
        case "1111":
            role = .user
        case "2222":
            role = .admin
        default:
            throw APIError.serverError("Geçersiz doğrulama kodu")
        }
        
        // Test için örnek kullanıcı
        let user = User(
            id: "test123",
            phoneNumber: phoneNumber,
            firstName: role == .admin ? "Admin" : "Test",
            lastName: "User",
            email: "test@example.com",
            role: role,
            isVerified: true,
            status: .active
        )
        
        return (user, "mock_access_token", "mock_refresh_token")
    }
}

// Doğrulama yanıtı için yapı
struct VerifyResponse: Codable {
    let user: User
    let accessToken: String
    let refreshToken: String
    let isRegistered: Bool
}
