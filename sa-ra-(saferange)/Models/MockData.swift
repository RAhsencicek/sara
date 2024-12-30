//
//  MockData.swift
//  sa-ra-(saferange)
//
//  Created by Ahsen on 31.12.2024.
//

import Foundation

struct MockData {
    // Gruplar için mock veriler
    static let groups = [
        Group(id: "1", name: "Roma Turu", description: "7 günlük Roma turu", guideId: "guide1", startDate: Date(), endDate: Date().addingTimeInterval(7*24*60*60), isActive: true),
        Group(id: "2", name: "Paris Turu", description: "5 günlük Paris turu", guideId: "guide2", startDate: Date(), endDate: Date().addingTimeInterval(5*24*60*60), isActive: true)
    ]
    
    // Chat için mock veriler
    static func getChats() -> [MockChat] {
        return [
            MockChat(
                id: "1",
                groupName: "Roma Turu",
                lastMessage: "Yarın saat 9'da buluşuyoruz",
                lastMessageTime: "14:30",
                unreadCount: 3,
                messages: [
                    MockMessage(id: "1", content: "Merhaba grup!", timestamp: Date(), isFromAdmin: true),
                    MockMessage(id: "2", content: "Yarın saat 9'da buluşuyoruz", timestamp: Date(), isFromAdmin: true),
                    MockMessage(id: "3", content: "Tamam, teşekkürler", timestamp: Date(), isFromAdmin: false)
                ]
            ),
            MockChat(
                id: "2",
                groupName: "Paris Turu",
                lastMessage: "Hava durumu nasıl?",
                lastMessageTime: "13:15",
                unreadCount: 0,
                messages: [
                    MockMessage(id: "4", content: "Herkese iyi günler", timestamp: Date(), isFromAdmin: true),
                    MockMessage(id: "5", content: "Hava durumu nasıl?", timestamp: Date(), isFromAdmin: false)
                ]
            )
        ]
    }
    
    // Üyeler için mock veriler
    static func getMembers() -> [MockMember] {
        return [
            MockMember(id: "1", name: "Ahmet Yılmaz", phone: "+90 555 111 2233", bluetoothEnabled: true),
            MockMember(id: "2", name: "Ayşe Demir", phone: "+90 555 444 5566", bluetoothEnabled: false),
            MockMember(id: "3", name: "Mehmet Kaya", phone: "+90 555 777 8899", bluetoothEnabled: true)
        ]
    }
    
    // Bluetooth cihazları için mock veriler
    static func getConnectedDevices() -> [BluetoothDevice] {
        return [
            BluetoothDevice(id: "Device-001", name: "iPhone 12", signalStrength: 0.9),
            BluetoothDevice(id: "Device-002", name: "iPhone 13", signalStrength: 0.6),
            BluetoothDevice(id: "Device-003", name: "iPhone 14", signalStrength: 0.3)
        ]
    }
    
    static func getNearbyDevices() -> [BluetoothDevice] {
        return [
            BluetoothDevice(id: "Device-004", name: "iPhone 11", signalStrength: 0.4),
            BluetoothDevice(id: "Device-005", name: "iPhone SE", signalStrength: 0.7)
        ]
    }
    
    static func getMemberCount(for groupId: String) -> Int {
        return Int.random(in: 5...20)
    }
}
