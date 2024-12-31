//
//  SafeRangeApp.swift
//  sa-ra-(saferange)
//
//  Created by Ahsen on 29.12.2024.
//

// Firebase ve SwiftUI framework'lerini import ediyoruz
import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

@main
struct SafeRangeApp: App {
    // Firebase'i başlatıyoruz - Uygulama başladığında çalışacak
    init() {
        FirebaseApp.configure()
    }
    
    // AppViewModel'i StateObject olarak tanımlıyoruz
    // Bu sayede uygulama genelinde kullanıcı durumunu takip edebileceğiz
    @StateObject private var appViewModel = AppViewModel()
    
    var body: some Scene {
        WindowGroup {
            // Kullanıcının giriş durumunu kontrol ediyoruz
            if appViewModel.isAuthenticated {
                // Kullanıcı admin mi değil mi kontrolü
                if appViewModel.currentUser?.role == .admin {
                    AdminTabView()
                        .environmentObject(appViewModel)
                } else {
                    MainTabView()
                        .environmentObject(appViewModel)
                }
            } else {
                LoginView()
                    .environmentObject(appViewModel)
            }
        }
    }
}
