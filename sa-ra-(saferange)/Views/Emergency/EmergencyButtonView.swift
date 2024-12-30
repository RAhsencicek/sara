//
//  EmergencyButtonView.swift
//  sa-ra-(saferange)
//
//  Created by Ahsen on 31.12.2024.
//

import SwiftUI

struct EmergencyButtonView: View {
    @State private var isPressed = false
    @State private var isAnimating = false
    @State private var showingEmergencyOverlay = false
    
    // Animasyon için timer
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            // Ana SOS butonu
            Button(action: {
                withAnimation {
                    showingEmergencyOverlay = true
                    isPressed = true
                }
            }) {
                ZStack {
                    // Dış halka animasyonu
                    Circle()
                        .stroke(Color.red, lineWidth: 2)
                        .scaleEffect(isAnimating ? 1.3 : 1.0)
                        .opacity(isAnimating ? 0.0 : 1.0)
                    
                    // Ana buton
                    Circle()
                        .fill(Color.red)
                        .frame(width: 60, height: 60)
                        .shadow(color: .red.opacity(0.3), radius: 10, x: 0, y: 0)
                    
                    // SOS yazısı
                    Text("SOS")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .frame(width: 60, height: 60)
            
            // Acil durum overlay'i
            if showingEmergencyOverlay {
                EmergencyOverlayView(isPresented: $showingEmergencyOverlay)
                    .transition(.opacity)
            }
        }
        .onReceive(timer) { _ in
            withAnimation(Animation.easeInOut(duration: 1.0)) {
                isAnimating.toggle()
            }
        }
    }
}

struct EmergencyOverlayView: View {
    @Binding var isPresented: Bool
    @State private var pulseAnimation = false
    
    var body: some View {
        ZStack {
            // Yarı saydam arka plan
            Color.black.opacity(0.7)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                // Yanıp sönen SOS ikonu
                ZStack {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 120, height: 120)
                        .scaleEffect(pulseAnimation ? 1.2 : 1.0)
                        .opacity(pulseAnimation ? 0.5 : 1.0)
                        .animation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: pulseAnimation)
                    
                    Text("SOS")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                }
                
                Text("ACİL DURUM ÇAĞRISI YAPILIYOR")
                    .font(.headline)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("Konum bilgileriniz rehbere iletiliyor...")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                
                // İptal butonu
                Button(action: {
                    withAnimation {
                        isPresented = false
                    }
                }) {
                    Text("İptal Et")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                }
                .padding(.top, 20)
            }
            .padding()
        }
        .onAppear {
            pulseAnimation = true
        }
    }
}

#Preview {
    EmergencyButtonView()
}
