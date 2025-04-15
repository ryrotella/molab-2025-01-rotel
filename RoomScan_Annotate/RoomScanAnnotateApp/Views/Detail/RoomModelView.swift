import SwiftUI
import UIKit
import RoomPlan
import SceneKit
import ARKit

// SceneKit view for displaying the 3D room model with annotations
struct RoomModelView: UIViewRepresentable {
    @Binding var room: RoomModel
    @Binding var selectedAnnotation: Annotation?
    @Binding var isInAnnotationMode: Bool
    
    // Used for communication between parent RoomDetailView and this view
    var onTapToAddAnnotation: ((SIMD3<Float>) -> Void)?
    
    func makeUIView(context: Context) -> SCNView {
        let sceneView = SCNView()
        sceneView.scene = SCNScene()
        sceneView.allowsCameraControl = true
        sceneView.autoenablesDefaultLighting = true
        sceneView.backgroundColor = .systemBackground
        
        // Set up tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
        sceneView.addGestureRecognizer(tapGesture)
        
        return sceneView
    }
    
    func updateUIView(_ sceneView: SCNView, context: Context) {
        // Clear the scene
        sceneView.scene = SCNScene()
        
        // Load the room model from USDZ if available
        if let usdzPath = room.usdzFilePath {
            let roomNode = SCNReferenceNode(url: usdzPath)
            roomNode?.load()
            if let roomNode = roomNode {
                sceneView.scene?.rootNode.addChildNode(roomNode)
            }
        }
        
        // Add annotations
        for annotation in room.annotations {
            let annotationNode = createAnnotationNode(for: annotation)
            sceneView.scene?.rootNode.addChildNode(annotationNode)
            
            // Highlight selected annotation
            if selectedAnnotation?.id == annotation.id {
                let highlightNode = SCNNode()
                highlightNode.geometry = SCNSphere(radius: 0.08)
                highlightNode.geometry?.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.3)
                highlightNode.position = SCNVector3(annotation.position.x, annotation.position.y, annotation.position.z)
                sceneView.scene?.rootNode.addChildNode(highlightNode)
            }
        }
        
        // Store coordinator references
        context.coordinator.sceneView = sceneView
        context.coordinator.parent = self
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // Create a node for an annotation
    private func createAnnotationNode(for annotation: Annotation) -> SCNNode {
        let node = SCNNode()
        
        // Create sphere for the annotation point
        let sphere = SCNSphere(radius: 0.03)
        sphere.firstMaterial?.diffuse.contents = annotation.color.uiColor
        let sphereNode = SCNNode(geometry: sphere)
        
        // Add text label
        let textGeometry = SCNText(string: annotation.text, extrusionDepth: 0.001)
        textGeometry.font = UIFont.systemFont(ofSize: 0.1)
        textGeometry.firstMaterial?.diffuse.contents = UIColor.white
        
        let textNode = SCNNode(geometry: textGeometry)
        textNode.scale = SCNVector3(0.1, 0.1, 0.1)
        
        // Center the text
        let (min, max) = textGeometry.boundingBox
        let width = Float(max.x - min.x)
        textNode.pivot = SCNMatrix4MakeTranslation(width/2, 0, 0)
        
        // Position the text above the sphere
        textNode.position = SCNVector3(0, 0.1, 0)
        
        // Create a billboard constraint so text always faces the camera
        let billboardConstraint = SCNBillboardConstraint()
        textNode.constraints = [billboardConstraint]
        
        // Add both to the parent node
        node.addChildNode(sphereNode)
        node.addChildNode(textNode)
        
        // Set the position
        node.position = SCNVector3(annotation.position.x, annotation.position.y, annotation.position.z)
        
        return node
    }
    
    // Coordinator for handling interactions
    class Coordinator: NSObject {
        var parent: RoomModelView
        var sceneView: SCNView?
        
        init(_ parent: RoomModelView) {
            self.parent = parent
        }
        
        @objc func handleTap(_ gestureRecognize: UIGestureRecognizer) {
            guard let sceneView = sceneView else { return }
            
            let location = gestureRecognize.location(in: sceneView)
            
            if parent.isInAnnotationMode {
                // Add a new annotation at tap location
                let hitResults = sceneView.hitTest(location, options: [:])
                
                if let hit = hitResults.first {
                    let position = hit.worldCoordinates
                    let positionVector = SIMD3<Float>(Float(position.x), Float(position.y), Float(position.z))
                    
                    // Use the callback to communicate with parent view
                    DispatchQueue.main.async {
                        self.parent.onTapToAddAnnotation?(positionVector)
                    }
                }
            } else {
                // Select an existing annotation
                let hitResults = sceneView.hitTest(location, options: [:])
                
                // Find the first hit that is an annotation
                for hit in hitResults {
                    // Traverse up to find a node that represents an annotation
                    var currentNode: SCNNode? = hit.node
                    while currentNode != nil {
                        // Check if any of our annotations are at this position
                        let nodePosition = currentNode?.worldPosition
                        if let position = nodePosition {
                            for annotation in parent.room.annotations {
                                let annotationPos = SCNVector3(annotation.position.x, annotation.position.y, annotation.position.z)
                                let distance = distance(nodePosition: position, annotationPos: annotationPos)
                                
                                if distance < 0.1 { // Within 10cm
                                    DispatchQueue.main.async {
                                        self.parent.selectedAnnotation = annotation
                                    }
                                    return
                                }
                            }
                        }
                        currentNode = currentNode?.parent
                    }
                }
                
                // If no annotation was selected, deselect current one
                if !hitResults.isEmpty {
                    DispatchQueue.main.async {
                        self.parent.selectedAnnotation = nil
                    }
                }
            }
        }
        
        private func distance(nodePosition: SCNVector3, annotationPos: SCNVector3) -> Float {
            let dx = nodePosition.x - annotationPos.x
            let dy = nodePosition.y - annotationPos.y
            let dz = nodePosition.z - annotationPos.z
            return sqrt(dx*dx + dy*dy + dz*dz)
        }
    }
}
