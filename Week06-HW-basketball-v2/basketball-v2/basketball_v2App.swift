//
//  basketball_v1App.swift
//  basketball-v1
//
//  Created by Ryan Rotella on 2/28/25.
//

import SwiftUI

@main
struct basketball_v2App: App {
    
    @State var document = Document()
    @State var detector = MotionDetector(updateInterval: 0.01)

    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(document)
        }
    }
}
