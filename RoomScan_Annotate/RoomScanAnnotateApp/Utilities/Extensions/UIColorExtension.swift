//
//  UIColorExtension.swift
//  RoomScanAnnotate
//
//  Created by Ryan Rotella on 4/14/25.
//  Copyright © 2025 Apple. All rights reserved.
//
import UIKit
import RoomPlan
import SceneKit
import ARKit
import RealityKit
import SwiftUICore


// Extension to help with color conversions between UIColor and SwiftUI Color
extension UIColor {
    func toColor() -> Color {
        return Color(self)
    }
}


