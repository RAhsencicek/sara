//
//  MockData.swift
//  sa-ra-(saferange)
//
//  Created by Ahsen on 31.12.2024.
//

import Foundation

struct MockData {
    // Bluetooth cihazları için mock veriler
    static let bluetoothDevices: [BluetoothDevice] = [
        BluetoothDevice(id: "Device-001", name: "iPhone 12", signalStrength: 0.9),
        BluetoothDevice(id: "Device-002", name: "iPhone 13", signalStrength: 0.6),
        BluetoothDevice(id: "Device-003", name: "iPhone 14", signalStrength: 0.3)
    ]
    
    // Mesajlar için mock veriler
    static let chats: [Chat] = [
        Chat(
            id: "1",
            groupName: "Roma Turu",
            lastMessage: "Yarın saat 9'da buluşuyoruz",
            lastMessageTime: "14:30",
            unreadCount: 3,
            messages: [
                Message(content: "Merhaba grup!", senderName: "Admin", isFromAdmin: true),
                Message(content: "Yarın saat 9'da buluşuyoruz", senderName: "Admin", isFromAdmin: true),
                Message(content: "Tamam, teşekkürler", senderName: "Ahmet Yılmaz")
            ]
        ),
        Chat(
            id: "2",
            groupName: "Paris Turu",
            lastMessage: "Hava durumu nasıl?",
            lastMessageTime: "13:15",
            unreadCount: 0,
            messages: [
                Message(content: "Herkese iyi günler", senderName: "Admin", isFromAdmin: true),
                Message(content: "Hava durumu nasıl?", senderName: "Mehmet Demir")
            ]
        )
    ]
    
    // Gruplar için mock veriler
    static let groups: [Group] = [
        Group(
            id: "1",
            name: "Roma Turu",
            description: "7 günlük Roma turu",
            guideId: "guide1",
            startDate: Date(),
            endDate: Date().addingTimeInterval(7*24*60*60),
            isActive: true
        ),
        Group(
            id: "2",
            name: "Paris Turu",
            description: "5 günlük Paris turu",
            guideId: "guide1",
            startDate: Date().addingTimeInterval(14*24*60*60),
            endDate: Date().addingTimeInterval(19*24*60*60),
            isActive: true
        )
    ]
}
