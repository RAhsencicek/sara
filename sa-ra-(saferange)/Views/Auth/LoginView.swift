// 
//  LoginView.swift
//  sa-ra-(saferange)
//
//  Created by Ahsen on 29.12.2024.
//

import SwiftUI

struct LoginView: View {
    // ViewModel'e erişim
    @EnvironmentObject var appViewModel: AppViewModel
    
    // State değişkenleri
    @State private var phoneNumber: String = ""
    @State private var verificationCode: String = ""
    @State private var isShowingVerification: Bool = false
    @State private var isLoading: Bool = false
    @State private var errorMessage: String = ""
    @State private var isShowingRegistration: Bool = false
    @State private var name: String = ""
    @State private var email: String = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Logo veya başlık
                Text("Sa-RA")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 50)
                
                // Alt başlık
                Text("Safe-Range")
                    .font(.title3)
                    .foregroundStyle(.gray)
                    .padding(.bottom, 50)
                
                if !isShowingVerification && !isShowingRegistration {
                    // Giriş ekranı
                    loginView
                } else if isShowingRegistration {
                    // Kayıt ekranı
                    registrationView
                } else {
                    // Doğrulama kodu ekranı
                    verificationView
                }
                
                // Hata mesajı
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                        .font(.caption)
                }
                
                Spacer()
                
                if !isShowingVerification && !isShowingRegistration {
                    // Hesap oluştur butonu
                    Button(action: {
                        isShowingRegistration = true
                    }) {
                        Text("Hesabınız yok mu? Hesap Oluşturun")
                            .foregroundStyle(.blue)
                    }
                    .padding(.bottom)
                }
            }
            .padding()
            .disabled(isLoading)
            .overlay {
                if isLoading {
                    ProgressView()
                }
            }
        }
    }
    
    // Giriş ekranı
    private var loginView: some View {
        VStack(spacing: 20) {
            TextField("Telefon Numarası", text: $phoneNumber)
                .keyboardType(.phonePad)
                .textContentType(.telephoneNumber)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            
            Button(action: sendVerificationCode) {
                Text("Giriş Yap")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundStyle(.white)
                    .cornerRadius(10)
            }
        }
    }
    
    // Kayıt ekranı
    private var registrationView: some View {
        VStack(spacing: 20) {
            TextField("Ad Soyad", text: $name)
                .textContentType(.name)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            
            TextField("Telefon Numarası", text: $phoneNumber)
                .keyboardType(.phonePad)
                .textContentType(.telephoneNumber)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            
            TextField("E-posta", text: $email)
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            
            Button(action: register) {
                Text("Hesap Oluştur")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundStyle(.white)
                    .cornerRadius(10)
            }
            
            Button(action: {
                isShowingRegistration = false
                phoneNumber = ""
                name = ""
                email = ""
                errorMessage = ""
            }) {
                Text("Geri Dön")
                    .foregroundStyle(.blue)
            }
        }
    }
    
    // Doğrulama kodu giriş ekranı
    private var verificationView: some View {
        VStack(spacing: 20) {
            TextField("Doğrulama Kodu", text: $verificationCode)
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            
            Button(action: verifyCode) {
                Text("Giriş Yap")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundStyle(.white)
                    .cornerRadius(10)
            }
            
            Button(action: resetView) {
                Text("Telefon Numarasını Değiştir")
                    .foregroundStyle(.blue)
            }
        }
    }
    
    // Doğrulama kodu gönderme
    private func sendVerificationCode() {
        guard !phoneNumber.isEmpty else {
            errorMessage = "Lütfen telefon numaranızı girin"
            return
        }
        
        // Telefon numarası formatını düzenle
        let formattedPhone = formatPhoneNumber(phoneNumber)
        
        isLoading = true
        errorMessage = ""
        
        Task {
            do {
                _ = try await APIService.shared.sendVerificationCode(phoneNumber: formattedPhone)
                
                DispatchQueue.main.async {
                    isLoading = false
                    isShowingVerification = true
                }
            } catch {
                DispatchQueue.main.async {
                    isLoading = false
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    // Doğrulama kodunu kontrol etme
    private func verifyCode() {
        guard !verificationCode.isEmpty else {
            errorMessage = "Lütfen doğrulama kodunu girin"
            return
        }
        
        let formattedPhone = formatPhoneNumber(phoneNumber)
        
        isLoading = true
        errorMessage = ""
        
        Task {
            do {
                let (user, accessToken, refreshToken) = try await APIService.shared.verifyCode(
                    phoneNumber: formattedPhone,
                    code: verificationCode
                )
                
                DispatchQueue.main.async {
                    isLoading = false
                    appViewModel.currentUser = user
                    appViewModel.saveTokens(accessToken: accessToken, refreshToken: refreshToken)
                }
            } catch {
                DispatchQueue.main.async {
                    isLoading = false
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    // Görünümü sıfırlama
    private func resetView() {
        isShowingVerification = false
        verificationCode = ""
        errorMessage = ""
    }
    
    // Kayıt işlemi
    private func register() {
        // TODO: Implement registration
        isShowingVerification = true
    }
    
    // Telefon numarası formatı
    private func formatPhoneNumber(_ number: String) -> String {
        let digits = number.filter { $0.isNumber }
        if !digits.hasPrefix("90") {
            return "+90\(digits)"
        }
        return "+\(digits)"
    }
}
