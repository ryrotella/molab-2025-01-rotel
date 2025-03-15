//
//  photoGraffitiApp.swift
//  photoGraffiti
//
//  Created by Ryan Rotella on 3/13/25.
//

import SwiftUI

@main
struct photoGraffitiApp: App {
    var body: some Scene {
        WindowGroup {
            //ContentView(canvas: Canvas())
            DrawingViewControllerRepresentable()
        }
    }
}
