//
//  CameraControlView.swift
//  RoomScanAnnotate
//
//  Created by Ryan Rotella on 4/19/25.
//  Copyright © 2025 Apple. All rights reserved.
//
import SwiftUI
import SceneKit
import RealityKit
import RoomPlan
import QuickLook


struct CameraControlView: View {
    var onMoveUp: () -> Void
    var onMoveDown: () -> Void
    var onMoveLeft: () -> Void
    var onMoveRight: () -> Void
    var onMoveForward: () -> Void
    var onMoveBackward: () -> Void
    var onReset: () -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            // Top row - Up button
            HStack {
                Spacer()
                Button(action: onMoveUp) {
                    Image(systemName: "arrow.up")
                        .frame(width: 44, height: 44)
                        .background(Color.black.opacity(0.5))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                Spacer()
            }
            
            // Middle row - Left, Reset, Right buttons
            HStack {
                Button(action: onMoveLeft) {
                    Image(systemName: "arrow.left")
                        .frame(width: 44, height: 44)
                        .background(Color.black.opacity(0.5))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                Spacer()
                
                Button(action: onReset) {
                    Image(systemName: "arrow.counterclockwise")
                        .frame(width: 44, height: 44)
                        .background(Color.black.opacity(0.5))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                Spacer()
                
                Button(action: onMoveRight) {
                    Image(systemName: "arrow.right")
                        .frame(width: 44, height: 44)
                        .background(Color.black.opacity(0.5))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            
            // Bottom row - Down, Forward, Backward buttons
            HStack {
                Button(action: onMoveDown) {
                    Image(systemName: "arrow.down")
                        .frame(width: 44, height: 44)
                        .background(Color.black.opacity(0.5))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                Spacer()
                
                Button(action: onMoveForward) {
                    Image(systemName: "arrow.up.to.line")
                        .frame(width: 44, height: 44)
                        .background(Color.black.opacity(0.5))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                Button(action: onMoveBackward) {
                    Image(systemName: "arrow.down.to.line")
                        .frame(width: 44, height: 44)
                        .background(Color.black.opacity(0.5))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }
        .padding(20)
    }
}
