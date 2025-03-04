//
//  Spin.swift
//  basketball-v1
//
//  Created by Ryan Rotella on 2/28/25.
//

/*
 
 one version created by chat: https://chatgpt.com/c/67c388b3-cbec-8002-bfc0-843807292e41
 */

/*
 this created by claude.ai:
 https://claude.ai/chat/5a2e0af2-3a43-45fd-8d61-1da89151d70d
 */

//
//  Spin.swift
//  basketball-v1
//
//  Created by Ryan Rotella on 2/28/25.
//

import UIKit
import SceneKit
import SwiftUI

import UIKit
import SceneKit

class BasketballViewController: UIViewController {
    
    private var sceneView: SCNView!
    private var scene: SCNScene!
    private var basketballNode: SCNNode!
    private var lastPanLocation: CGPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup SceneKit view
        setupSceneView()
        
        // Create and configure the scene
        setupScene()
        
        // Add the basketball SCN model
        addBasketballModel()
        
        // Setup gesture recognizer
        setupGestureRecognizer()
    }
    
    private func setupSceneView() {
        sceneView = SCNView(frame: view.bounds)
        sceneView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        sceneView.backgroundColor = UIColor.lightGray
        sceneView.allowsCameraControl = false
        sceneView.showsStatistics = true
        view.addSubview(sceneView)
    }
    
    private func setupScene() {
        scene = SCNScene()
        
        // Add ambient light
        let ambientLight = SCNNode()
        ambientLight.light = SCNLight()
        ambientLight.light?.type = .ambient
        ambientLight.light?.color = UIColor(white: 0.5, alpha: 1.0)
        scene.rootNode.addChildNode(ambientLight)
        
        // Add directional light
        let directionalLight = SCNNode()
        directionalLight.light = SCNLight()
        directionalLight.light?.type = .directional
        directionalLight.light?.color = UIColor(white: 0.8, alpha: 1.0)
        directionalLight.position = SCNVector3(x: 5, y: 5, z: 5)
        directionalLight.eulerAngles = SCNVector3(x: -Float.pi/4, y: Float.pi/4, z: 0)
        scene.rootNode.addChildNode(directionalLight)
        
        // Setup camera
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 7, y: 0, z: 65)
        scene.rootNode.addChildNode(cameraNode)
        
        sceneView.scene = scene
    }
    
    private func addBasketballModel() {
        // Load the SCN file
        guard let basketballScene = SCNScene(named: "basketball.scn") else {
            print("Failed to find basketball.scn in bundle")
            // Fall back to basic sphere
            addBasicBasketball()
            return
        }
        
        // Find the main node in the scene
        // SCN files often have a root node with child nodes that make up the model
        // We'll get all of the root level nodes and add them to our container node
        
        // Create a container node for the basketball
        basketballNode = SCNNode()
        
        // Add all root nodes from the scene to our container node
        for childNode in basketballScene.rootNode.childNodes {
            basketballNode.addChildNode(childNode.clone())
        }
        
        // Position the basketball
        basketballNode.position = SCNVector3(x: 0, y: 0, z: 0)
        
        // You may need to adjust scale depending on the size of your model
        basketballNode.scale = SCNVector3(x: 0.2, y: 0.2, z: 0.2)
        
        // Add the basketball to the scene
        scene.rootNode.addChildNode(basketballNode)
    }
    
    // Fallback method if the SCN model fails to load
    private func addBasicBasketball() {
        // Create a sphere geometry for the basketball
        let basketballGeometry = SCNSphere(radius: 1.0)
        
        // Create a material for the basketball
        let basketballMaterial = SCNMaterial()
        basketballMaterial.diffuse.contents = UIColor.orange
        
        // Add some lighting properties to enhance 3D appearance
        basketballMaterial.lightingModel = .physicallyBased
        basketballMaterial.roughness.contents = 0.8
        basketballMaterial.metalness.contents = 0.0
        
        basketballGeometry.materials = [basketballMaterial]
        
        // Create a node for the basketball
        basketballNode = SCNNode(geometry: basketballGeometry)
        basketballNode.position = SCNVector3(x: 0, y: 0, z: 0)
        
        // Add the basketball to the scene
        scene.rootNode.addChildNode(basketballNode)
    }
    
    private func setupGestureRecognizer() {
        // Create a pan gesture recognizer
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        
        // Add it to the SceneKit view
        sceneView.addGestureRecognizer(panGesture)
        
        // Print confirmation
        print("Pan gesture recognizer set up")
    }

    @objc private func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        // Get the current location of the touch
        let currentLocation = gestureRecognizer.location(in: sceneView)
        
        // Handle different gesture states
        switch gestureRecognizer.state {
        case .began:
            // Store initial touch location when gesture begins
            lastPanLocation = currentLocation
            print("Pan gesture began")
            
        case .changed:
            // Make sure we have a previous location
            guard let lastLocation = lastPanLocation else { return }
            
            // Calculate the difference between the current and last touch positions
            let deltaX = currentLocation.x - lastLocation.x
            let deltaY = currentLocation.y - lastLocation.y
            
            // Print the deltas for debugging
            print("Pan delta X: \(deltaX), delta Y: \(deltaY)")
            
            // Convert screen movement to rotation angles
            // Adjust these multipliers to control rotation sensitivity
            let rotationY = deltaX * 0.02  // Horizontal movement rotates around Y axis
            let rotationX = deltaY * 0.02  // Vertical movement rotates around X axis
            
            // Create rotation actions
            // Using SCNAction for smooth animation
            let rotateX = SCNAction.rotateBy(x: CGFloat(rotationX), y: 0, z: 0, duration: 1.5)
            let rotateY = SCNAction.rotateBy(x: 0, y: CGFloat(rotationY), z: 0, duration: 1.5)
            
            // Apply the rotation to the basketball node
            basketballNode.runAction(SCNAction.group([rotateX, rotateY]))
            
            // Update the last location for the next movement
            lastPanLocation = currentLocation
            
        case .ended, .cancelled:
            // Add momentum for a more natural feel
            if let lastLocation = lastPanLocation {
                let deltaX = currentLocation.x - lastLocation.x
                let deltaY = currentLocation.y - lastLocation.y
                
                // Create longer, slowing rotations for momentum effect
                let momentumRotateX = SCNAction.rotateBy(x: CGFloat(deltaY * 0.01), y: 0, z: 0, duration: 1.0)
                let momentumRotateY = SCNAction.rotateBy(x: 0, y: CGFloat(deltaX * 0.01), z: 0, duration: 1.0)
                
                // Add easing to create a slowing down effect
                momentumRotateX.timingMode = .easeOut
                momentumRotateY.timingMode = .easeOut
                
                // Apply the momentum rotation
                basketballNode.runAction(SCNAction.group([momentumRotateX, momentumRotateY]))
                print("Pan gesture ended with momentum")
            }
            
            // Reset the last location
            lastPanLocation = nil
            
        default:
            break
        }
    }
}

struct Spin: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> BasketballViewController {
        return BasketballViewController()
    }
    
    func updateUIViewController(_ uiViewController: BasketballViewController, context: Context) {
    }
}

struct BasketballViewControllerPreview_Previews: PreviewProvider {
    static var previews: some View {
        Spin()
            .edgesIgnoringSafeArea(.all)
    }
}
