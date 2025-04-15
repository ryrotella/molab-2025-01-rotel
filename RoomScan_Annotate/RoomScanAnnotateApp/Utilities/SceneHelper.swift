//
//  SceneHelper.swift
//  RoomScanAnnotate
//
//  Created by Ryan Rotella on 4/14/25.
//  Copyright © 2025 Apple. All rights reserved.
//

import UIKit
import RoomPlan
import SceneKit
import ARKit


// Helpers for working with SceneKit Nodes and the Rendered Scene
class SceneHelper {
    // Convert a screen point to a 3D position in the scene
    static func hitTest(_ sceneView: SCNView, at point: CGPoint) -> SCNVector3? {
        let hitResults = sceneView.hitTest(point, options: [:])
        return hitResults.first?.worldCoordinates
    }
    
    // Find all nodes with the given name
    static func findNodes(named name: String, in node: SCNNode) -> [SCNNode] {
        var results = [SCNNode]()
        
        if node.name == name {
            results.append(node)
        }
        
        for childNode in node.childNodes {
            results.append(contentsOf: findNodes(named: name, in: childNode))
        }
        
        return results
    }
    
    // Find annotation nodes
    static func findAnnotationNodes(in node: SCNNode) -> [AnnotationNode] {
        var results = [AnnotationNode]()
        
        if let annotationNode = node as? AnnotationNode {
            results.append(annotationNode)
        }
        
        for childNode in node.childNodes {
            results.append(contentsOf: findAnnotationNodes(in: childNode))
        }
        
        return results
    }
}
