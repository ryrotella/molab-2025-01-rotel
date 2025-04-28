//
//  SkyboxPickerView.swift
//  RoomScanAnnotate
//
//  Created by Ryan Rotella on 4/27/25.
//  Copyright © 2025 Apple. All rights reserved.
//

import SwiftUI

struct SkyboxPickerView: View {
    @Binding var skyboxStyle: SkyboxStyle
    @Binding var customSkyboxColor: Color
    @Binding var isPresented: Bool
    var onSave: () -> Void
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Background Style")) {
                    ForEach(SkyboxStyle.allCases) { style in
                        HStack {
                            // Show a preview of the skybox
                            RoundedRectangle(cornerRadius: 6)
                                .fill(getSkyboxPreviewColor(style))
                                .frame(width: 40, height: 40)
                            
                            Text(style.displayName)
                            
                            Spacer()
                            
                            if skyboxStyle == style {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            skyboxStyle = style
                        }
                    }
                }
                
                // Color picker section for custom color
                if skyboxStyle == .custom {
                    Section(header: Text("Custom Color")) {
                        ColorPicker("Select Color", selection: $customSkyboxColor)
                    }
                }
            }
            .navigationTitle("Background Options")
            .navigationBarItems(
                leading: Button("Cancel") {
                    isPresented = false
                },
                trailing: Button("Save") {
                    onSave()
                    isPresented = false
                }
            )
        }
    }
    
    // Helper to get preview colors for the skybox picker
    private func getSkyboxPreviewColor(_ style: SkyboxStyle) -> Color {
        switch style {
        case .black:
            return Color.black
        case .gradient:
            return Color(red: 0.4, green: 0.6, blue: 0.9)
        case .sky:
            return Color(red: 0.53, green: 0.81, blue: 0.92)
        case .night:
            return Color(red: 0.05, green: 0.05, blue: 0.2)
        case .space:
            return Color(red: 0.01, green: 0.01, blue: 0.05)
        case .custom:
            return customSkyboxColor
        }
    }
}
