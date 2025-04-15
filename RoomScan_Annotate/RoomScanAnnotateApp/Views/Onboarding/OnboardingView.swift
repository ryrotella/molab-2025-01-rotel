//
//  OnboardingView.swift
//  RoomScanAnnotate
//
//  Created by Ryan Rotella on 4/14/25.
//  Copyright © 2025 Apple. All rights reserved.
//

// OnboardingView.swift - SwiftUI version of the onboarding screen
import SwiftUI

struct OnboardingView: View {
    @Binding var hasSeenOnboarding: Bool
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "house.fill")
                .font(.system(size: 80))
                .foregroundColor(.blue)
            
            Text("Room Scanner & Annotation")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Scan your rooms in 3D and add annotations to remember details or share with others.")
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 15) {
                FeatureRow(icon: "camera.fill", title: "Scan Rooms", description: "Use RoomPlan to create 3D models of your rooms")
                FeatureRow(icon: "note.text", title: "Add Annotations", description: "Place sticky notes in your 3D model")
                FeatureRow(icon: "square.and.arrow.up", title: "Export & Share", description: "Export to USDZ or share with others")
            }
            .padding()
            
            Spacer()
            
            Button(action: {
                hasSeenOnboarding = true
            }) {
                Text("Get Started")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 30)
        }
        .padding()
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 30))
                .frame(width: 40, height: 40)
                .foregroundColor(.blue)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}
