//
//  ProfileView.swift
//  sa-ra-(saferange)
//
//  Created by Ahsen on 31.12.2024.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @State private var isEditingProfile = false
    @State private var showingSettings = false
    
    // Kullanıcı bilgileri
    @State private var name = "Ahmet Yılmaz"
    @State private var phone = "+90 555 123 4567"
    @State private var email = "ahmet.yilmaz@email.com"
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    // Profil fotoğrafı
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundStyle(.blue)
                        
                        VStack(alignment: .leading) {
                            Text(name)
                                .font(.headline)
                            Text(phone)
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                Section("Kişisel Bilgiler") {
                    LabeledContent("Ad Soyad", value: name)
                    LabeledContent("Telefon", value: phone)
                    LabeledContent("E-posta", value: email)
                }
                
                Section("Uygulama") {
                    NavigationLink(destination: Text("Bluetooth Ayarları")) {
                        Label("Bluetooth Ayarları", systemImage: "wave.3.right.circle.fill")
                    }
                    
                    NavigationLink(destination: Text("Bildirim Ayarları")) {
                        Label("Bildirimler", systemImage: "bell.fill")
                    }
                    
                    NavigationLink(destination: Text("Gizlilik Ayarları")) {
                        Label("Gizlilik", systemImage: "lock.fill")
                    }
                }
                
                Section {
                    Button(action: {
                        appViewModel.logout()
                    }) {
                        HStack {
                            Text("Çıkış Yap")
                                .foregroundStyle(.red)
                            Spacer()
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .foregroundStyle(.red)
                        }
                    }
                }
            }
            .navigationTitle("Profil")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        isEditingProfile = true
                    }) {
                        Text("Düzenle")
                    }
                }
            }
            .sheet(isPresented: $isEditingProfile) {
                NavigationView {
                    EditProfileView(name: $name, phone: $phone, email: $email, isPresented: $isEditingProfile)
                }
            }
        }
    }
}

struct EditProfileView: View {
    @Binding var name: String
    @Binding var phone: String
    @Binding var email: String
    @Binding var isPresented: Bool
    
    // Geçici değişiklikler için
    @State private var tempName: String = ""
    @State private var tempPhone: String = ""
    @State private var tempEmail: String = ""
    
    var body: some View {
        List {
            Section("Kişisel Bilgiler") {
                TextField("Ad Soyad", text: $tempName)
                TextField("Telefon", text: $tempPhone)
                TextField("E-posta", text: $tempEmail)
            }
        }
        .navigationTitle("Profili Düzenle")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("İptal") {
                    isPresented = false
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Kaydet") {
                    name = tempName
                    phone = tempPhone
                    email = tempEmail
                    isPresented = false
                }
            }
        }
        .onAppear {
            tempName = name
            tempPhone = phone
            tempEmail = email
        }
    }
}

#Preview {
    ProfileView()
}
