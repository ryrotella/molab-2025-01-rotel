//
//  RoomScanAnnotationApp.swift
//  RoomScanAnnotate
//
//  Created by Ryan Rotella on 4/14/25.
//  Copyright © 2025 Apple. All rights reserved.
//

// RoomScanAnnotationApp.swift
import SwiftUI
import RoomPlan

@main
struct RoomScanAnnotationApp: App {
    @StateObject private var dataStore = RoomDataStore()
    
    var body: some Scene {
        WindowGroup {
            if RoomCaptureSession.isSupported {
                ContentView()
                    .environmentObject(dataStore)
            } else {
                UnsupportedDeviceView()
            }
        }
    }
}






