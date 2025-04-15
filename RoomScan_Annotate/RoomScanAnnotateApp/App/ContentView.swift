//
//  ContentView.swift
//  RoomScanAnnotate
//
//  Created by Ryan Rotella on 4/14/25.
//  Copyright © 2025 Apple. All rights reserved.
//

// ContentView.swift
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var dataStore: RoomDataStore
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
    
    var body: some View {
        if hasSeenOnboarding {
            GalleryView()
                .environmentObject(dataStore)
        } else {
            OnboardingView(hasSeenOnboarding: $hasSeenOnboarding)
        }
    }
}
