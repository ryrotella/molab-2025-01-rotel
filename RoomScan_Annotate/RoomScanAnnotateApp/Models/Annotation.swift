//
//  Annotation.swift
//  RoomScanAnnotate
//
//  Created by Ryan Rotella on 4/14/25.
//  Copyright © 2025 Apple. All rights reserved.
//
import Foundation
import RoomPlan
import SwiftUI

// Annotation model for sticky notes
struct Annotation: Identifiable, Codable {
    var id = UUID()
    var text: String
    var color: AnnotationColor
    var position: SIMD3<Float> // 3D position in the room
    var creationDate: Date
    
    init(text: String, color: AnnotationColor, position: SIMD3<Float>) {
        self.text = text
        self.color = color
        self.position = position
        self.creationDate = Date()
    }
}

// Predefined colors for annotations
enum AnnotationColor: String, Codable, CaseIterable {
    case yellow
    case blue
    case green
    case red
    case purple
    
    var uiColor: UIColor {
        switch self {
        case .yellow: return UIColor.systemYellow
        case .blue: return UIColor.systemBlue
        case .green: return UIColor.systemGreen
        case .red: return UIColor.systemRed
        case .purple: return UIColor.systemPurple
        }
    }
    
    var color: Color {
        Color(uiColor)
    }
}
