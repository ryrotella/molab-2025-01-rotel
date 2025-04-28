//
//  RoomModel.swift
//  RoomScanAnnotate
//
//  Created by Ryan Rotella on 4/14/25.
//  Copyright © 2025 Apple. All rights reserved.
//
import UIKit
import RoomPlan
import SceneKit
import ARKit
import SwiftUI

// RoomModel.swift - Data model for a room scan
struct RoomModel: Identifiable, Codable {
    var id = UUID()
    var name: String
    var creationDate: Date
    var annotations: [Annotation]
    var thumbnailImageData: Data?
    
    // Path to the saved USDZ file
    var usdzFilePath: URL?
    
    var skyboxStyle: String = "black" // Store as String for Codable compatibility
    var customSkyboxColorData: Data? // Store color as Data
    
    // Temporary non-serializable properties
    var capturedRoom: CapturedRoom? {
        // This is used at runtime but not stored directly
        get {
            return nil // In a real implementation, you would load from the USDZ file if needed
        }
        set {
            // When set, we would export to USDZ
            if let newValue = newValue {
                do {
                    // Create a unique filename
                    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                    let usdzDirectory = documentsDirectory.appendingPathComponent("RoomModels", isDirectory: true)
                    
                    // Create directory if it doesn't exist
                    if !FileManager.default.fileExists(atPath: usdzDirectory.path) {
                        try FileManager.default.createDirectory(at: usdzDirectory, withIntermediateDirectories: true, attributes: nil)
                    }
                    
                    // Set the USDZ file path
                    usdzFilePath = usdzDirectory.appendingPathComponent("\(id.uuidString).usdz")
                    
                    if let usdzPath = usdzFilePath {
                        try newValue.export(to: usdzPath, exportOptions: .parametric)
                    }
                } catch {
                    print("Error saving captured room: \(error)")
                }
            }
        }
    }
    
    init(name: String, capturedRoom: CapturedRoom? = nil) {
        self.id = UUID()
        self.name = name
        self.creationDate = Date()
        self.annotations = []
        self.capturedRoom = capturedRoom
    }
    
    // Helper to convert between SkyboxStyle enum and String
    func getSkyboxStyleEnum() -> SkyboxStyle {
        return SkyboxStyle(rawValue: skyboxStyle) ?? .black
    }
    
    // Helper to convert between Color and Data
    func getCustomSkyboxColor() -> Color {
        if let colorData = customSkyboxColorData,
           let uiColor = try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData) {
            return Color(uiColor)
        }
        return Color.gray
    }
}

