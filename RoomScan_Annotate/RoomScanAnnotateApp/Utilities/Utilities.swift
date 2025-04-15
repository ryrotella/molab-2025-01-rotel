//
//  Utilities.swift
//  RoomScanAnnotate
//
//  Created by Ryan Rotella on 4/14/25.
//  Copyright © 2025 Apple. All rights reserved.
//
import UIKit
import RoomPlan
import SceneKit
import ARKit


// Notification names for app-wide events
extension Notification.Name {
    static let roomScanComplete = Notification.Name("roomScanComplete")
    static let annotationAdded = Notification.Name("annotationAdded")
    static let annotationUpdated = Notification.Name("annotationUpdated")
    static let annotationDeleted = Notification.Name("annotationDeleted")
}

// Custom SCNNode subclass for annotations that includes metadata
class AnnotationNode: SCNNode {
    var annotationId: UUID
    
    init(annotationId: UUID) {
        self.annotationId = annotationId
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



// Error types for the app
enum AppError: Error {
    case roomScanFailed
    case exportFailed
    case importFailed
    case annotationCreationFailed
    case usdzExportFailed
    case unsupportedDevice
    
    var localizedDescription: String {
        switch self {
        case .roomScanFailed:
            return "Failed to scan the room. Please try again."
        case .exportFailed:
            return "Failed to export the room. Please try again."
        case .importFailed:
            return "Failed to import the room. The file may be corrupted."
        case .annotationCreationFailed:
            return "Failed to create annotation. Please try again."
        case .usdzExportFailed:
            return "Failed to export USDZ file. Please try again."
        case .unsupportedDevice:
            return "This device does not support RoomPlan. A LiDAR sensor is required."
        }
    }
}
