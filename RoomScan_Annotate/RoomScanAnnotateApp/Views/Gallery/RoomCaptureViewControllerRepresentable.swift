//
//  RoomCaptureViewControllerRepresentable.swift
//  RoomScanAnnotate
//
//  Created by Ryan Rotella on 4/14/25.
//  Copyright © 2025 Apple. All rights reserved.
//

import SwiftUI
import RoomPlan

// SwiftUI wrapper for UIKit RoomCaptureViewController
struct RoomCaptureViewControllerRepresentable: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    @EnvironmentObject var dataStore: RoomDataStore
    
    func makeUIViewController(context: Context) -> UINavigationController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navController = storyboard.instantiateViewController(withIdentifier: "RoomCaptureViewNavigationController") as! UINavigationController
        
        if let roomCaptureVC = navController.topViewController as? RoomCaptureViewController {
            roomCaptureVC.onScanComplete = { capturedRoom in
                if let capturedRoom = capturedRoom {
                    // Generate a default name with date
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateStyle = .short
                    dateFormatter.timeStyle = .short
                    let name = "Room Scan - \(dateFormatter.string(from: Date()))"
                    
                    // Create a new room model
                    var newRoom = RoomModel(name: name, capturedRoom: capturedRoom)
                    
                    // Generate and save thumbnail
                    if let thumbnail = generateThumbnail(for: capturedRoom) {
                        newRoom.thumbnailImageData = thumbnail.jpegData(compressionQuality: 0.7)
                    }
                    
                    // Add to data store
                    dataStore.addRoom(newRoom)
                    
                    // Export USDZ
                    do {
                        let destinationURL = FileManager.default.temporaryDirectory.appendingPathComponent("Room.usdz")
                        try capturedRoom.export(to: destinationURL, exportOptions: .parametric)
                        if let usdzData = try? Data(contentsOf: destinationURL) {
                            dataStore.saveUsdzFile(for: &newRoom, usdzData: usdzData)
                        }
                    } catch {
                        print("Error exporting room: \(error)")
                    }
                }
                
                isPresented = false
            }
        }
        
        return navController
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        // Nothing to update
    }
    
    // Helper function to generate a thumbnail from CapturedRoom
    private func generateThumbnail(for capturedRoom: CapturedRoom) -> UIImage? {
        // Implementation would use SceneKit or RealityKit to render a preview
        // This is a placeholder that should be replaced with actual rendering code
        return UIImage(systemName: "house.fill")
    }
}
