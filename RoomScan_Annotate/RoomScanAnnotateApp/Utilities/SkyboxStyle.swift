//
//  SkyboxStyle.swift
//  RoomScanAnnotate
//
//  Created by Ryan Rotella on 4/27/25.
//  Copyright © 2025 Apple. All rights reserved.
//

import SwiftUI

enum SkyboxStyle: String, CaseIterable, Identifiable {
    case black
    case gradient
    case sky
    case night
    case space
    case custom
    
    var id: String { self.rawValue }
    
    // UI display name
    var displayName: String {
        switch self {
        case .black: return "Default Black"
        case .gradient: return "Gradient"
        case .sky: return "Blue Sky"
        case .night: return "Night Sky"
        case .space: return "Space"
        case .custom: return "Custom Color"
        }
    }
    
    // Helper to get a UIColor for solid colors or an image name for image-based skyboxes
    func getSkyboxContent() -> Any {
        switch self {
        case .black:
            return UIColor.black
        case .gradient:
            // Create a gradient background
            let topColor = UIColor(red: 0.4, green: 0.6, blue: 0.9, alpha: 1.0)
            let bottomColor = UIColor(red: 0.8, green: 0.9, blue: 1.0, alpha: 1.0)
            
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = CGRect(x: 0, y: 0, width: 1024, height: 1024)
            gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
            
            UIGraphicsBeginImageContextWithOptions(gradientLayer.frame.size, false, 0)
            gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
            let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return gradientImage!
        case .sky:
            return UIColor(red: 0.53, green: 0.81, blue: 0.92, alpha: 1.0) // Light blue
        case .night:
            return UIColor(red: 0.05, green: 0.05, blue: 0.2, alpha: 1.0) // Dark blue
        case .space:
            return UIColor(red: 0.01, green: 0.01, blue: 0.05, alpha: 1.0) // Nearly black
        case .custom:
            // Return a default color for custom, will be overridden
            return UIColor.gray
        }
    }
}
