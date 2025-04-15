//
//  SIMD3Extension.swift
//  RoomScanAnnotate
//
//  Created by Ryan Rotella on 4/14/25.
//  Copyright © 2025 Apple. All rights reserved.
//
import UIKit
import RoomPlan
import SceneKit
import ARKit

// Extension for SIMD3 to allow for use in SwiftUI views
extension SIMD3: Hashable where Scalar: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
        hasher.combine(z)
    }
}
