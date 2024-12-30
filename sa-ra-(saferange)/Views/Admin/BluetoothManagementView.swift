//
//  BluetoothManagementView.swift
//  sa-ra-(saferange)
//
//  Created by Ahsen on 29.12.2024.
//

import SwiftUI

struct BluetoothDevice: Identifiable {
    let id: String
    let name: String
    let signalStrength: Double // 0.0 to 1.0
}

struct BluetoothManagementView: View {
    @State private var isBluetoothEnabled = true
    @State private var selectedRange = 10.0 // metre cinsinden
    @State private var autoConnect = true
    
    var body: some View {
        List {
            Section("Genel Ayarlar") {
                Toggle("Bluetooth Aktif", isOn: $isBluetoothEnabled)
                
                if isBluetoothEnabled {
                    Toggle("Otomatik Bağlan", isOn: $autoConnect)
                    
                    VStack(alignment: .leading) {
                        Text("Bağlantı Menzili: \(Int(selectedRange))m")
                        Slider(value: $selectedRange, in: 5...50, step: 1) {
                            Text("Menzil")
                        }
                    }
                }
            }
            
            if isBluetoothEnabled {
                Section("Bağlı Cihazlar") {
                    ForEach(getConnectedDevices()) { device in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(device.name)
                                Text(device.id)
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                            }
                            
                            Spacer()
                            
                            // Sinyal gücü göstergesi
                            Image(systemName: "wave.3.right")
                                .foregroundStyle(device.signalStrength > 0.7 ? .green : 
                                               device.signalStrength > 0.4 ? .yellow : .red)
                        }
                    }
                }
                
                Section("Yakındaki Cihazlar") {
                    ForEach(getNearbyDevices()) { device in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(device.name)
                                Text(device.id)
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                            }
                            
                            Spacer()
                            
                            Button("Bağlan") {
                                // TODO: Implement connection logic
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                }
            }
        }
        .navigationTitle("Bluetooth Yönetimi")
    }
    
    private func getConnectedDevices() -> [BluetoothDevice] {
        return [
            BluetoothDevice(id: "Device-001", name: "iPhone 12", signalStrength: 0.9),
            BluetoothDevice(id: "Device-002", name: "iPhone 13", signalStrength: 0.6),
            BluetoothDevice(id: "Device-003", name: "iPhone 14", signalStrength: 0.3)
        ]
    }
    
    private func getNearbyDevices() -> [BluetoothDevice] {
        return [
            BluetoothDevice(id: "Device-004", name: "iPhone 11", signalStrength: 0.4),
            BluetoothDevice(id: "Device-005", name: "iPhone SE", signalStrength: 0.7)
        ]
    }
}

#Preview {
    NavigationView {
        BluetoothManagementView()
    }
}
