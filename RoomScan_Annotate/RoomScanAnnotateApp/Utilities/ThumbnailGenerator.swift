import UIKit
import RoomPlan
import SceneKit
import ARKit

// Utility class for generating thumbnails from 3D models
class ThumbnailGenerator {
    static func generateThumbnail(from usdzURL: URL, size: CGSize = CGSize(width: 300, height: 300)) -> UIImage? {
        // Create a scene
        var scene: SCNScene?
        do {
            scene = try SCNScene(url: usdzURL, options: nil)
        } catch {
            print("Error loading scene: \(error)")
            return nil
        }
        
        guard let scene = scene else { return nil }
        
        // Create camera
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(0, 0, 5)
        scene.rootNode.addChildNode(cameraNode)
        
        // Create a renderer
        let renderer = SCNRenderer(device: nil, options: nil)
        renderer.scene = scene
        renderer.pointOfView = cameraNode
        
        // Render the image
        let image = renderer.snapshot(atTime: 0, with: size, antialiasingMode: .multisampling4X)
        return image
    }
}
