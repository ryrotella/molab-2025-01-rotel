//
//  UnsupportedDeviceView.swift
//  RoomScanAnnotate
//
//  Created by Ryan Rotella on 4/14/25.
//  Copyright © 2025 Apple. All rights reserved.
//

// UnsupportedDeviceView.swift
import SwiftUI

struct UnsupportedDeviceView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 80))
                .foregroundColor(.orange)
            
            Text("Unsupported Device")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("This app requires an iPhone or iPad with LiDAR scanner. Devices with LiDAR include iPhone 12 Pro, iPhone 12 Pro Max, iPhone 13 Pro, iPhone 13 Pro Max, and iPad Pro (2020 or later).")
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
    }
}
