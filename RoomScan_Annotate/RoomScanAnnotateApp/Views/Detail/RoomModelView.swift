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
    

    
    func makeUIView(context: Context) -> SCNView {
        let sceneView = SCNView()
        sceneView.scene = SCNScene()
        sceneView.allowsCameraControl = true
        sceneView.autoenablesDefaultLighting = true
        sceneView.backgroundColor = .systemBackground
        
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
            
        // Check if we have an annotation to delete
                if let idToDelete = annotationToDelete {
                    // Find and remove nodes with this annotation ID
                    let annotationNodes = SceneHelper.findAnnotationNodes(in: sceneView.scene!.rootNode)
                        .filter { $0.annotationId == idToDelete }
                    
                    for node in annotationNodes {
                        node.removeFromParentNode()
                    }
                    
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
                    highlightNode.geometry = SCNSphere(radius: 0.08)
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
                    sceneView.scene?.rootNode.addChildNode(roomNode)
                }
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
                    highlightNode.geometry = SCNSphere(radius: 0.08)
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
        
        // Add text label
        let textGeometry = SCNText(string: annotation.text, extrusionDepth: 0.009)
        textGeometry.font = UIFont.systemFont(ofSize: 1.0)
        textGeometry.firstMaterial?.diffuse.contents = annotation.color.uiColor
        
        let textNode = SCNNode(geometry: textGeometry)
        textNode.name = "text"
        textNode.scale = SCNVector3(0.3, 0.3, 0.3)
        
        // Center the text
        let (min, max) = textGeometry.boundingBox
        let width = Float(max.x - min.x)
        textNode.pivot = SCNMatrix4MakeTranslation(width/2, 0, 0)
        
        // Position the text above the sphere
        textNode.position = SCNVector3(0, 0.2, 0.25)
        
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
        
        func navigateToAnnotation(_ annotation: Annotation) {
            guard let sceneView = sceneView else { return }
            
            let position = SCNVector3(annotation.position.x, annotation.position.y, annotation.position.z)
            
            // Create a new position slightly offset from the annotation to view it better
            let viewPosition = SCNVector3(
                position.x - 0.8,
                position.y + 0.6,
                position.z - 1.9
            )
            
            // Animate camera move to the annotation
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            sceneView.pointOfView?.position = viewPosition
            
            // Create a look-at point that's slightly in front of the annotation
            // This prevents overshooting and keeps the annotation in view
            let lookAtNode = SCNNode()
            lookAtNode.position = position
            sceneView.scene?.rootNode.addChildNode(lookAtNode)
            
            let lookAtConstraint = SCNLookAtConstraint(target: lookAtNode)
            lookAtConstraint.isGimbalLockEnabled = true
            sceneView.pointOfView?.constraints = [lookAtConstraint]
            
            SCNTransaction.commit()
            
            // After animation, remove the constraint
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                // Save the final orientation
                let finalOrientation = sceneView.pointOfView?.orientation
                
                // Remove constraints
                sceneView.pointOfView?.constraints = []
                
                // Maintain the camera's orientation
                sceneView.pointOfView?.orientation = finalOrientation ?? SCNQuaternion()
                
                // Remove the temporary node
                lookAtNode.removeFromParentNode()
            }
        }
        
        @objc func annotationSelected(_ notification: Notification) {
            guard let annotationId = notification.userInfo?["annotationId"] as? UUID else { return }
            
            // Find the annotation with this ID
            if let annotation = parent.room.annotations.first(where: { $0.id == annotationId }) {
                navigateToAnnotation(annotation)
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
