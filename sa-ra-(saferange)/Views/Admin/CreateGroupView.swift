//
//  CreateGroupView.swift
//  sa-ra-(saferange)
//
//  Created by Ahsen on 29.12.2024.
//

import SwiftUI

struct CreateGroupView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var groupViewModel: GroupViewModel
    
    @State private var groupName = ""
    @State private var groupDescription = ""
    @State private var startDate = Date()
    @State private var endDate = Date().addingTimeInterval(24*60*60)
    @State private var showingError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section("Grup Bilgileri") {
                    TextField("Grup Adı", text: $groupName)
                    TextField("Açıklama", text: $groupDescription)
                }
                
                Section("Tarih Bilgileri") {
                    DatePicker("Başlangıç Tarihi", selection: $startDate, displayedComponents: [.date])
                    DatePicker("Bitiş Tarihi", selection: $endDate, displayedComponents: [.date])
                }
            }
            .navigationTitle("Yeni Grup")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("İptal") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Oluştur") {
                        createGroup()
                    }
                }
            }
            .alert("Hata", isPresented: $showingError) {
                Button("Tamam", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private func createGroup() {
        // Validasyonlar
        guard !groupName.isEmpty else {
            showError("Grup adı boş olamaz")
            return
        }
        
        guard endDate > startDate else {
            showError("Bitiş tarihi başlangıç tarihinden sonra olmalıdır")
            return
        }
        
        // Grup oluştur
        groupViewModel.createGroup(
            name: groupName,
            description: groupDescription,
            startDate: startDate,
            endDate: endDate
        )
        
        // Sayfayı kapat
        dismiss()
    }
    
    private func showError(_ message: String) {
        errorMessage = message
        showingError = true
    }
}

#Preview {
    CreateGroupView()
}
