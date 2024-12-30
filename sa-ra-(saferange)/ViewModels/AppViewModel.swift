// 
//  AppViewModel.swift
//  sa-ra-(saferange)
//
//  Created by Ahsen on 29.12.2024.
//

import Foundation
import SwiftUI

class AppViewModel: ObservableObject {
    // Kullanıcının giriş durumunu tutan değişken
    @Published var isAuthenticated: Bool = false
    
    // Kullanıcı bilgilerini tutan değişken
    @Published var currentUser: User?
    
    // JWT token'ları tutan değişkenler
    @Published private(set) var accessToken: String?
    @Published private(set) var refreshToken: String?
    
    // UserDefaults anahtarları
    private let tokenKey = "accessToken"
    private let refreshTokenKey = "refreshToken"
    
    init() {
        // UserDefaults'tan token'ları yükle
        self.loadTokens()
        
        // Token varsa kullanıcıyı giriş yapmış olarak işaretle
        self.isAuthenticated = accessToken != nil
    }
    
    // Token'ları kaydet
    func saveTokens(accessToken: String, refreshToken: String) {
        UserDefaults.standard.set(accessToken, forKey: tokenKey)
        UserDefaults.standard.set(refreshToken, forKey: refreshTokenKey)
        
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.isAuthenticated = true
    }
    
    // Token'ları yükle
    private func loadTokens() {
        self.accessToken = UserDefaults.standard.string(forKey: tokenKey)
        self.refreshToken = UserDefaults.standard.string(forKey: refreshTokenKey)
    }
    
    // Çıkış yap
    func logout() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
        UserDefaults.standard.removeObject(forKey: refreshTokenKey)
        
        self.accessToken = nil
        self.refreshToken = nil
        self.currentUser = nil
        self.isAuthenticated = false
    }
}
