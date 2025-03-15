//
//  CanvasImage.swift
//  photoGraffiti
//
//  Created by Ryan Rotella on 3/13/25.
//

//from WWDC: Drawing Together

/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A model that represents the canvas to draw on.
*/

import Foundation
import Combine
import SwiftUI
//import GroupActivities

struct CanvasImage: Identifiable {
    let id = UUID()
    let location: CGPoint
    let imageData: Data
}

@MainActor
class Canvas: ObservableObject {
    @Published var strokes = [Stroke]()
    @Published var activeStroke: Stroke?
    @Published var images = [CanvasImage]()
    @Published var selectedImageData: Data?
    let strokeColor = Stroke.Color.random

    var subscriptions = Set<AnyCancellable>()
    var tasks = Set<Task<Void, Never>>()

    func addPointToActiveStroke(_ point: CGPoint) {
        let stroke: Stroke
        if let activeStroke = activeStroke {
            stroke = activeStroke
        } else {
            stroke = Stroke(color: strokeColor)
            activeStroke = stroke
        }

        stroke.points.append(point)

    }

    func finishStroke() {
        guard let activeStroke = activeStroke else {
            return
        }

        strokes.append(activeStroke)
        self.activeStroke = nil
    }

    func addImage(_ imageData: Data, at location: CGPoint) {
        let newImage = CanvasImage(location: location, imageData: imageData)
           images.append(newImage)
       }



    func reset() {
        // Clear the local drawing canvas.
        strokes = []
        images = []

    }

    var pointCount: Int {
        return strokes.reduce(0) { $0 + $1.points.count }
    }





}
