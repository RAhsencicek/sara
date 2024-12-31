// 
//  AppViewModel.swift
//  sa-ra-(saferange)
//
//  Created by Ahsen on 29.12.2024.
//

import Foundation
import SwiftUI
import FirebaseAuth

class AppViewModel: ObservableObject {
    // Kullanıcının giriş durumunu tutan değişken
    @Published var isAuthenticated: Bool = false
    
    // Kullanıcı bilgilerini tutan değişken
    @Published var currentUser: User?
    
    // Doğrulama ID'sini tutan değişken
    @Published var verificationID: String?
    
    // Hata mesajını tutan değişken
    @Published var errorMessage: String?
    
    // Loading durumunu tutan değişken
    @Published var isLoading: Bool = false
    
    private let authManager = AuthManager.shared
    
    init() {
        // Firebase Auth durumunu dinle
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.isAuthenticated = user != nil
            self?.currentUser = user
        }
    }
    
    // Telefon numarasına doğrulama kodu gönder
    func sendVerificationCode(to phoneNumber: String) {
        isLoading = true
        errorMessage = nil
        
        authManager.sendVerificationCode(to: phoneNumber) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let verificationID):
                    self?.verificationID = verificationID
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    // Doğrulama kodunu kontrol et
    func verifyCode(_ code: String) {
        guard let verificationID = verificationID else {
            errorMessage = "Doğrulama ID'si bulunamadı"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        authManager.verifyCode(code, verificationID: verificationID) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let user):
                    self?.currentUser = user
                    self?.isAuthenticated = true
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    // Çıkış yap
    func logout() {
        do {
            try authManager.signOut()
            isAuthenticated = false
            currentUser = nil
            verificationID = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
