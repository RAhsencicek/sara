// 
//  LoginView.swift
//  sa-ra-(saferange)
//
//  Created by Ahsen on 29.12.2024.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    
    @State private var phoneNumber: String = ""
    @State private var verificationCode: String = ""
    @State private var isShowingVerification: Bool = false
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
                
                if !isShowingVerification {
                    // Giriş ekranı
                    loginView
                } else {
                    // Doğrulama kodu ekranı
                    verificationView
                }
                
                // Hata mesajı
                if let error = appViewModel.errorMessage {
                    Text(error)
                        .foregroundStyle(.red)
                        .font(.caption)
                }
                
                Spacer()
            }
            .padding()
            .disabled(appViewModel.isLoading)
            .overlay {
                if appViewModel.isLoading {
                    ProgressView()
                }
            }
        }
    }
    
    // Giriş ekranı
    private var loginView: some View {
        VStack(spacing: 20) {
            HStack {
                Text("+90")
                    .foregroundStyle(.gray)
                
                TextField("5XX XXX XX XX", text: $phoneNumber)
                    .keyboardType(.phonePad)
                    .textContentType(.telephoneNumber)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            
            Button(action: sendVerificationCode) {
                Text("Doğrulama Kodu Gönder")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundStyle(.white)
                    .cornerRadius(10)
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
            appViewModel.errorMessage = "Lütfen telefon numaranızı girin"
            return
        }
        
        // Telefon numarası formatını düzenle
        let formattedPhone = formatPhoneNumber(phoneNumber)
        appViewModel.sendVerificationCode(to: formattedPhone)
        isShowingVerification = true
    }
    
    // Doğrulama kodunu kontrol etme
    private func verifyCode() {
        guard !verificationCode.isEmpty else {
            appViewModel.errorMessage = "Lütfen doğrulama kodunu girin"
            return
        }
        
        appViewModel.verifyCode(verificationCode)
    }
    
    // Görünümü sıfırlama
    private func resetView() {
        isShowingVerification = false
        verificationCode = ""
        appViewModel.errorMessage = nil
    }
    
    // Telefon numarası formatı
    private func formatPhoneNumber(_ number: String) -> String {
        let digits = number.filter { $0.isNumber }
        return "+90\(digits)"
    }
}
