import UIKit
import RoomPlan
import SceneKit
import ARKit

// Instead of trying to make CapturedRoom Codable directly (which has issues
// due to the internal structure of RoomPlan's classes), we'll create a wrapper
// class to store the data we need

// Wrapper class for serializing room scan data
class SerializableRoom: Codable {
    var id: UUID
    var name: String
    var creationDate: Date
    var usdzFileURL: URL?
    
    // We'll store the binary representation of the CapturedRoom
    var capturedRoomData: Data?
    
    init(id: UUID, name: String, creationDate: Date = Date()) {
        self.id = id
        self.name = name
        self.creationDate = creationDate
    }
    
    // Save the captured room to data
    func saveCapturedRoom(_ capturedRoom: CapturedRoom) throws {
        // Export the room to a temporary USDZ file
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("\(id.uuidString).usdz")
        try capturedRoom.export(to: tempURL, exportOptions: .parametric)
        
        // Read the USDZ file data
        self.capturedRoomData = try Data(contentsOf: tempURL)
        
        // Clean up the temporary file
        try? FileManager.default.removeItem(at: tempURL)
    }
    
    // Recover the captured room from saved data
    func loadCapturedRoom() -> CapturedRoom? {
        guard let capturedRoomData = capturedRoomData else { return nil }
        
        // Write data to a temporary file
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("\(id.uuidString).usdz")
        
        do {
            try capturedRoomData.write(to: tempURL)
            
            // RoomPlan doesn't provide a direct way to load a CapturedRoom from a file,
            // so we'll return nil and use the USDZ file path instead for visualization
            
            // Note: In a real app, you would need to find a way to recreate a CapturedRoom
            // or simply use the USDZ file directly for visualization
            
            return nil
        } catch {
            print("Error loading captured room: \(error)")
            return nil
        }
    }
}
