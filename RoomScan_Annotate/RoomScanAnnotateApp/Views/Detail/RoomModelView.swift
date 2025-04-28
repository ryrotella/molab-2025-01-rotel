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
    
    // Add a binding to track annotations that need to be deleted
    @Binding var annotationToDelete: UUID?
    
    // Used for communication between parent RoomDetailView and this view
    var onTapToAddAnnotation: ((SIMD3<Float>) -> Void)?
    
    // Add skybox binding options
    @Binding var skyboxStyle: SkyboxStyle
    @Binding var customSkyboxColor: Color // For custom color option
    

    
    func makeUIView(context: Context) -> SCNView {
        let sceneView = SCNView()
        sceneView.scene = SCNScene()
        sceneView.allowsCameraControl = true
        sceneView.autoenablesDefaultLighting = true
        sceneView.backgroundColor = .systemBackground
        
        // Apply the skybox
        updateSkybox(sceneView)
        
        
        // Set up initial camera
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(0, 0, 5)
        sceneView.scene?.rootNode.addChildNode(cameraNode)
        sceneView.pointOfView = cameraNode
        
        // Set up tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
        sceneView.addGestureRecognizer(tapGesture)
        
        //load room model
        loadRoomModel(sceneView)
        
        //Store the view in a coordinator
        context.coordinator.sceneView = sceneView

        // Set up notification observer for annotation selection
            NotificationCenter.default.addObserver(
                context.coordinator,
                selector: #selector(Coordinator.annotationSelected(_:)),
                name: .annotationSelected,
                object: nil
            )
            
            NotificationCenter.default.addObserver(
                context.coordinator,
                selector: #selector(Coordinator.annotationUpdated(_:)),
                name: .annotationUpdated,
                object: nil
            )
        
        // Add observer for annotation deletion
            NotificationCenter.default.addObserver(
                context.coordinator,
                selector: #selector(Coordinator.annotationDeleted(_:)),
                name: .annotationDeleted,
                object: nil
            )
        
        // Add camera control notification observers
            NotificationCenter.default.addObserver(
                context.coordinator,
                selector: #selector(Coordinator.moveCameraUp),
                name: .cameraMovedUp,
                object: nil
            )
            
            NotificationCenter.default.addObserver(
                context.coordinator,
                selector: #selector(Coordinator.moveCameraDown),
                name: .cameraMovedDown,
                object: nil
            )
            
            NotificationCenter.default.addObserver(
                context.coordinator,
                selector: #selector(Coordinator.moveCameraLeft),
                name: .cameraMovedLeft,
                object: nil
            )
            
            NotificationCenter.default.addObserver(
                context.coordinator,
                selector: #selector(Coordinator.moveCameraRight),
                name: .cameraMovedRight,
                object: nil
            )
            
            NotificationCenter.default.addObserver(
                context.coordinator,
                selector: #selector(Coordinator.moveCameraForward),
                name: .cameraMovedForward,
                object: nil
            )
            
            NotificationCenter.default.addObserver(
                context.coordinator,
                selector: #selector(Coordinator.moveCameraBackward),
                name: .cameraMovedBackward,
                object: nil
            )
            
            NotificationCenter.default.addObserver(
                context.coordinator,
                selector: #selector(Coordinator.resetCamera),
                name: .cameraReset,
                object: nil
            )
        
        
        
        return sceneView
    }
    
    func updateUIView(_ sceneView: SCNView, context: Context) {
        // Store the current camera position and orientation
            let currentCamera = sceneView.pointOfView?.clone()
        
            // Update the skybox
            updateSkybox(sceneView)
            
        // First, remove all existing annotation nodes to prevent duplicates
            let existingAnnotationNodes = SceneHelper.findAnnotationNodes(in: sceneView.scene!.rootNode)
        
            for node in existingAnnotationNodes {
                node.removeFromParentNode()
            }
            
        // Check if we have an annotation to delete
                if let idToDelete = annotationToDelete {
                    // Reset the deletion tracking
                    DispatchQueue.main.async {
                        self.annotationToDelete = nil
                    }
                }
            
            // Then add the current annotations from the data model
            for annotation in room.annotations {
                let annotationNode = createAnnotationNode(for: annotation)
                sceneView.scene?.rootNode.addChildNode(annotationNode)
                
                // Highlight selected annotation
                if selectedAnnotation?.id == annotation.id {
                    let highlightNode = SCNNode()
                    highlightNode.geometry = SCNSphere(radius: 0.09)
                    highlightNode.geometry?.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.3)
                    highlightNode.position = SCNVector3(annotation.position.x, annotation.position.y, annotation.position.z)
                    sceneView.scene?.rootNode.addChildNode(highlightNode)
                }
            }
            
            // Restore the camera to prevent jumping
            if let savedCamera = context.coordinator.lastCameraNode, context.coordinator.shouldRestoreCamera {
                sceneView.pointOfView = savedCamera
                context.coordinator.shouldRestoreCamera = false
            } else if let currentCamera = currentCamera {
                sceneView.pointOfView = currentCamera
            }
            
            // Update coordinator reference
            context.coordinator.parent = self
        }
    
    private func loadRoomModel(_ sceneView: SCNView) {
            // Clear existing content
            sceneView.scene?.rootNode.childNodes.forEach { node in
                if node.camera == nil { // Don't remove the camera
                    node.removeFromParentNode()
                }
            }
            
            // Load the room model from USDZ if available
            if let usdzPath = room.usdzFilePath {
                let roomNode = SCNReferenceNode(url: usdzPath)
                roomNode?.load()
                if let roomNode = roomNode {
                    // Apply transparency to all wall geometries
                    applyTransparencyToWalls(node: roomNode)
                    sceneView.scene?.rootNode.addChildNode(roomNode)
                }
            }
        }
    
    // Helper function to recursively apply transparency to walls
    private func applyTransparencyToWalls(node: SCNNode) {
        // Check if the node name contains "wall" or similar identifiers
        if node.name?.lowercased().contains("wall") == true ||
           node.name?.lowercased().contains("surface") == true {
            // Apply transparency to this node's geometry
            if let geometry = node.geometry {
                // Iterate through all materials and make them semi-transparent
                for material in geometry.materials {
                    // Set the material's transparency
                    material.transparency = 0.6  // 0.0 is fully opaque, 1.0 is fully transparent
                    
                    // Or alternatively set the alpha component of the diffuse color
                    if let diffuseColor = material.diffuse.contents as? UIColor {
                        material.diffuse.contents = diffuseColor.withAlphaComponent(0.4)
                    }
                    
                    // Enable depth write for better rendering of transparent objects
                    material.writesToDepthBuffer = true
                    material.readsFromDepthBuffer = true
                }
            }
        }
        
        // Recursively process child nodes
        for childNode in node.childNodes {
            applyTransparencyToWalls(node: childNode)
        }
    }
    
    func createTextWithBackground(text: String, position: SCNVector3, color: UIColor) -> SCNNode {
        // Create parent node
        let containerNode = SCNNode()
        containerNode.position = position
        
        // Create text geometry
        let textGeometry = SCNText(string: text, extrusionDepth: 0.01)
        textGeometry.font = UIFont.boldSystemFont(ofSize: 0.5) // Larger, bolder font
        textGeometry.firstMaterial?.diffuse.contents = UIColor.white // White text for better contrast
        textGeometry.alignmentMode = CATextLayerAlignmentMode.center.rawValue
        textGeometry.firstMaterial?.isDoubleSided = true
        
        // Create text node
        let textNode = SCNNode(geometry: textGeometry)
        
        // Calculate bounding box
        let (min, max) = textGeometry.boundingBox
        let width = max.x - min.x
        let height = max.y - min.y
        
        // Center the text
        textNode.pivot = SCNMatrix4MakeTranslation((max.x + min.x) / 2, (max.y + min.y) / 2, min.z)
        textNode.position = SCNVector3Zero
        
        // Create background node - with generous padding
        let backgroundGeometry = SCNPlane(width: CGFloat(width * 1.2), height: CGFloat(height * 1.5))
        backgroundGeometry.firstMaterial?.diffuse.contents = color.withAlphaComponent(0.8) // Semi-transparent background
        backgroundGeometry.firstMaterial?.isDoubleSided = true
        backgroundGeometry.cornerRadius = 0.05 // Rounded corners
        
        let backgroundNode = SCNNode(geometry: backgroundGeometry)
        backgroundNode.position = SCNVector3(0, 0, -0.01) // Positioned just behind text
        
        // Add both to container
        containerNode.addChildNode(backgroundNode)
        containerNode.addChildNode(textNode)
        
        // Add billboard constraint to always face camera
        let constraint = SCNBillboardConstraint()
        constraint.freeAxes = .all
        containerNode.constraints = [constraint]
        
        return containerNode
    }
    
    // New function to update the skybox
    private func updateSkybox(_ sceneView: SCNView) {
        switch skyboxStyle {
        case .black, .sky, .night, .space:
            // For simple color backgrounds
            if let color = skyboxStyle.getSkyboxContent() as? UIColor {
                sceneView.backgroundColor = color
                sceneView.scene?.background.contents = nil
            }
        case .gradient:
            // For image-based gradient
            if let image = skyboxStyle.getSkyboxContent() as? UIImage {
                sceneView.scene?.background.contents = image
            }
        case .custom:
            // Convert SwiftUI Color to UIColor
            let uiColor = UIColor(customSkyboxColor)
            sceneView.backgroundColor = uiColor
            sceneView.scene?.background.contents = nil
        }
    }
    
    private func updateAnnotations(_ sceneView: SCNView) {
            // Remove existing annotation nodes
            SceneHelper.findAnnotationNodes(in: sceneView.scene!.rootNode).forEach { node in
                node.removeFromParentNode()
            }
            
            // Add annotations
            for annotation in room.annotations {
                let annotationNode = createAnnotationNode(for: annotation)
                sceneView.scene?.rootNode.addChildNode(annotationNode)
                
                // Highlight selected annotation
                if selectedAnnotation?.id == annotation.id {
                    let highlightNode = SCNNode()
                    highlightNode.geometry = SCNSphere(radius: 0.09)
                    highlightNode.geometry?.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.3)
                    highlightNode.position = SCNVector3(annotation.position.x, annotation.position.y, annotation.position.z)
                    sceneView.scene?.rootNode.addChildNode(highlightNode)
                }
            }
        
        }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func removeAnnotationNode(from sceneView: SCNView, withId id: UUID) {
        let annotationNodes = SceneHelper.findAnnotationNodes(in: sceneView.scene!.rootNode)
            .filter { $0.annotationId == id }
        
        for node in annotationNodes {
            node.removeFromParentNode()
        }
        
        print("Removed \(annotationNodes.count) nodes with ID: \(id)")
    }
    
    /// Create a node for an annotation
    private func createAnnotationNode(for annotation: Annotation) -> AnnotationNode {
        let node = AnnotationNode(annotationId: annotation.id)
        
        node.name = annotation.id.uuidString
        
        // Create sphere for the annotation point
        let sphere = SCNSphere(radius: 0.06)
        sphere.firstMaterial?.diffuse.contents = annotation.color.uiColor
        let sphereNode = SCNNode(geometry: sphere)
        sphereNode.name = "sphere"
        
        // Create text with background
        let textNode = createTextWithBackground(
            text: annotation.text,
            position: SCNVector3(0, 0.2, 0), // Position above the sphere
            color: annotation.color.uiColor
        )
        textNode.name = "textGroup"
        
        // Add to parent node
        node.addChildNode(textNode)
        
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
        
        var lastCameraNode: SCNNode?
        var shouldRestoreCamera = false
        
        init(_ parent: RoomModelView) {
            self.parent = parent
        }
        
        // Method to save the current camera state
        func saveCameraState() {
            guard let sceneView = sceneView, let currentCamera = sceneView.pointOfView else { return }
            
            // Create a deep copy of the camera node
            lastCameraNode = SCNNode()
            lastCameraNode?.camera = SCNCamera()
            lastCameraNode?.position = currentCamera.position
            lastCameraNode?.orientation = currentCamera.orientation
            
            // Set flag to restore this camera after annotation
            shouldRestoreCamera = true
        }
        
        func navigateToAnnotation(_ annotation: Annotation, offsetX: Float = 1.2, offsetY: Float = 0.8, offsetZ: Float = 1.2) {
            guard let sceneView = sceneView else { return }
            
            let annotationPosition = SCNVector3(annotation.position.x, annotation.position.y, annotation.position.z)
            
            // Use a simpler approach with fixed offsets that work reliably
            // Position the camera 2 units away from the annotation in a diagonal direction
            
            // Use the provided offset values
            let cameraOffset = SCNVector3(offsetX, offsetY, offsetZ)
            let viewPosition = SCNVector3(
                annotationPosition.x - cameraOffset.x,
                annotationPosition.y + cameraOffset.y,
                annotationPosition.z - cameraOffset.z
            )
            
            // First move to an intermediate position to avoid clipping through walls
            let intermediatePosition = SCNVector3(
                (sceneView.pointOfView?.position.x ?? 0) * 0.3 + viewPosition.x * 0.7,
                (sceneView.pointOfView?.position.y ?? 0) * 0.3 + viewPosition.y * 0.7,
                (sceneView.pointOfView?.position.z ?? 0) * 0.3 + viewPosition.z * 0.7
            )
            
            // Two-stage animation for smoother movement
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.6
            SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            sceneView.pointOfView?.position = intermediatePosition
            SCNTransaction.completionBlock = {
                // Second stage - move to final position
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.4
                sceneView.pointOfView?.position = viewPosition
                
                // Look directly at the annotation
                let lookAt = SCNNode()
                lookAt.position = annotationPosition
                sceneView.scene?.rootNode.addChildNode(lookAt)
                
                let constraint = SCNLookAtConstraint(target: lookAt)
                constraint.isGimbalLockEnabled = true
                sceneView.pointOfView?.constraints = [constraint]
                
                SCNTransaction.commit()
                
                // Clean up after animation
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    sceneView.pointOfView?.constraints = []
                    lookAt.removeFromParentNode()
                }
            }
            SCNTransaction.commit()
        }
        
        @objc func annotationSelected(_ notification: Notification) {
            guard let annotationId = notification.userInfo?["annotationId"] as? UUID else { return }
            
            // Extract optional camera offset parameters if provided
            let offsetX = notification.userInfo?["offsetX"] as? Double ?? 1.2
            let offsetY = notification.userInfo?["offsetY"] as? Double ?? 0.8
            let offsetZ = notification.userInfo?["offsetZ"] as? Double ?? 1.2
            
            // Find the annotation with this ID
            if let annotation = parent.room.annotations.first(where: { $0.id == annotationId }) {
                navigateToAnnotation(annotation, offsetX: Float(offsetX), offsetY: Float(offsetY), offsetZ: Float(offsetZ))
            }
        }
        
        @objc func annotationDeleted(_ notification: Notification) {
            guard let sceneView = sceneView,
                  let annotationId = notification.userInfo?["annotationId"] as? UUID else { return }
            
            // Find and remove all nodes related to this annotation
            let nodesToRemove = SceneHelper.findAnnotationNodes(in: sceneView.scene!.rootNode)
                .filter { $0.annotationId == annotationId }
            
            // Remove each node
            for node in nodesToRemove {
                node.removeFromParentNode()
            }
            
            print("Removed \(nodesToRemove.count) nodes for deleted annotation with ID: \(annotationId)")
        }
        

        @objc func annotationUpdated(_ notification: Notification) {
            guard let sceneView = sceneView,
                  let annotationId = notification.userInfo?["annotationId"] as? UUID,
                  let newText = notification.userInfo?["newText"] as? String else { return }
            
            // Find all annotation nodes with this ID
            let annotationNodes = SceneHelper.findAnnotationNodes(in: sceneView.scene!.rootNode)
                .filter { $0.annotationId == annotationId }
            
            for node in annotationNodes {
                // Find the text node (assuming it's a child with name "text")
                if let textNode = node.childNodes.first(where: { $0.name == "text" }) {
                    // Update the text content
                    if let textGeometry = textNode.geometry as? SCNText {
                        SCNTransaction.begin()
                        SCNTransaction.animationDuration = 0.3
                        textGeometry.string = newText
                        SCNTransaction.commit()
                    }
                }
            }
        }
        
        func deleteAnnotation(withId id: UUID) {
                    guard let sceneView = sceneView else { return }
                    parent.removeAnnotationNode(from: sceneView, withId: id)
                }
        
        
        @objc func handleTap(_ gestureRecognize: UIGestureRecognizer) {
            guard let sceneView = sceneView else { return }
            
            // Exit if this is a multi-touch gesture (like a pinch)
            if gestureRecognize.numberOfTouches > 1 {
                return
            }
            
            let location = gestureRecognize.location(in: sceneView)
            
            if parent.isInAnnotationMode {
                // Save camera state before adding annotation
                saveCameraState()
                
                // Add a new annotation at tap location
                let hitResults = sceneView.hitTest(location, options: [:])
                
                if let hit = hitResults.first {
                    let position = hit.worldCoordinates
                    let positionVector = SIMD3<Float>(Float(position.x), Float(position.y), Float(position.z))
                    
                    // Use the callback to communicate with parent view
                    DispatchQueue.main.async {
                        self.parent.onTapToAddAnnotation?(positionVector)
                        
                        // Restore camera state after a short delay to ensure the annotation is added
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                            self.restoreCameraState()
//                        }
                    }
                }
            } else {
                // We're selecting annotations, not adding them
                let hitResults = sceneView.hitTest(location, options: [:])
                
                if hitResults.isEmpty {
                    return
                }
                
                // Try to find an annotation node
                var annotationFound = false
                
                for hit in hitResults {
                    var node = hit.node
                    
                    // Check if this node is an annotation
                    if let annotationNode = node as? AnnotationNode {
                        let annotationId = annotationNode.annotationId
                        
                        // Find the corresponding annotation
                        if let annotation = parent.room.annotations.first(where: { $0.id == annotationId }) {
                            annotationFound = true
                            DispatchQueue.main.async {
                                self.parent.selectedAnnotation = annotation
                                
                                // Notify that an annotation was selected
                                NotificationCenter.default.post(
                                    name: .annotationSelected,
                                    object: nil,
                                    userInfo: ["annotationId": annotation.id]
                                )
                            }
                            break
                        }
                    }
                    
                    // Check parent nodes too
                    while !annotationFound, let parentNode = node.parent {
                        node = parentNode
                        
                        if let annotationNode = node as? AnnotationNode {
                            let annotationId = annotationNode.annotationId
                            
                            // Find the corresponding annotation
                            if let annotation = parent.room.annotations.first(where: { $0.id == annotationId }) {
                                annotationFound = true
                                DispatchQueue.main.async {
                                    self.parent.selectedAnnotation = annotation
                                    
                                    // Notify that an annotation was selected
                                    NotificationCenter.default.post(
                                        name: .annotationSelected,
                                        object: nil,
                                        userInfo: ["annotationId": annotation.id]
                                    )
                                }
                                break
                            }
                        }
                    }
                    
                    if annotationFound {
                        break
                    }
                }
                
                // If no annotation was found, deselect the current one
                if !annotationFound {
                    DispatchQueue.main.async {
                        self.parent.selectedAnnotation = nil
                    }
                }
            }
        }
        
        @objc func moveCameraUp() {
            moveCamera(direction: SCNVector3(0, 0.3, 0))
        }

        @objc func moveCameraDown() {
            moveCamera(direction: SCNVector3(0, -0.3, 0))
        }

        @objc func moveCameraLeft() {
            moveCamera(direction: SCNVector3(-0.3, 0, 0))
        }

        @objc func moveCameraRight() {
            moveCamera(direction: SCNVector3(0.3, 0, 0))
        }

        @objc func moveCameraForward() {
            // Move in the direction the camera is facing
            guard let camera = sceneView?.pointOfView else { return }
            
            // Get the camera's forward vector
            let forwardVector = camera.worldFront
            
            // Normalize and scale the vector
            let normalizedVector = normalize(vector: forwardVector)
            let scaledVector = SCNVector3(
                normalizedVector.x * 0.3,
                normalizedVector.y * 0.3,
                normalizedVector.z * 0.3
            )
            
            moveCamera(direction: scaledVector)
        }

        @objc func moveCameraBackward() {
            // Move in the opposite direction the camera is facing
            guard let camera = sceneView?.pointOfView else { return }
            
            // Get the camera's forward vector
            let forwardVector = camera.worldFront
            
            // Normalize, invert, and scale the vector
            let normalizedVector = normalize(vector: forwardVector)
            let scaledVector = SCNVector3(
                -normalizedVector.x * 0.3,
                -normalizedVector.y * 0.3,
                -normalizedVector.z * 0.3
            )
            
            moveCamera(direction: scaledVector)
        }

        @objc func resetCamera() {
            guard let sceneView = sceneView else { return }
            
            // Animate to a default camera position
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            
            sceneView.pointOfView?.position = SCNVector3(0, 1.5, 5)
            
            // Look at the center of the scene
            let lookAtConstraint = SCNLookAtConstraint(target: SCNNode())
            sceneView.pointOfView?.constraints = [lookAtConstraint]
            
            SCNTransaction.commit()
            
            // Remove the constraint after animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                sceneView.pointOfView?.constraints = []
                
                // Set a standard orientation looking at the center
                sceneView.pointOfView?.eulerAngles = SCNVector3(0, 0, 0)
            }
        }
        
        private func moveCamera(direction: SCNVector3) {
            guard let camera = sceneView?.pointOfView else { return }
            
            let currentPosition = camera.position
            let newPosition = SCNVector3(
                currentPosition.x + direction.x,
                currentPosition.y + direction.y,
                currentPosition.z + direction.z
            )
            
            // Animate camera movement
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.2
            camera.position = newPosition
            SCNTransaction.commit()
        }

        private func normalize(vector: SCNVector3) -> SCNVector3 {
            let length = sqrt(vector.x * vector.x + vector.y * vector.y + vector.z * vector.z)
            if length == 0 {
                return SCNVector3(0, 0, -1) // Default forward direction
            }
            return SCNVector3(
                vector.x / length,
                vector.y / length,
                vector.z / length
            )
        }

     
        
        private func distance(nodePosition: SCNVector3, annotationPos: SCNVector3) -> Float {
            let dx = nodePosition.x - annotationPos.x
            let dy = nodePosition.y - annotationPos.y
            let dz = nodePosition.z - annotationPos.z
            return sqrt(dx*dx + dy*dy + dz*dz)
        }
    }
}
