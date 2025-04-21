//
//  SCNNode.swift
//  RoomScanAnnotate
//
//  Created by Ryan Rotella on 4/19/25.
//  Copyright © 2025 Apple. All rights reserved.
//

import UIKit
import RoomPlan
import SceneKit
import ARKit

extension SCNNode {
    var worldFront: SCNVector3 {
        let transform = self.transform
        return SCNVector3(
            -transform.m31,
            -transform.m32,
            -transform.m33
        )
    }
}
