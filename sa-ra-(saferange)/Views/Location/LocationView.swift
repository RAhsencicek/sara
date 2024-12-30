//
//  LocationView.swift
//  sa-ra-(saferange)
//
//  Created by Ahsen on 29.12.2024.
//

import SwiftUI
import MapKit

struct LocationView: View {
    // Elazığ'ın koordinatları
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 38.6748, longitude: 39.2225),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    var body: some View {
        NavigationView {
            Map(coordinateRegion: $region)
                .navigationTitle("Konum")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// Önizleme
#Preview {
    LocationView()
}
