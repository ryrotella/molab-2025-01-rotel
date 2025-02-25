//
//  testView.swift
//  dillabes
//
//  Created by Ryan Rotella on 2/24/25.
//

import SwiftUI
let timer = Timer.publish(every: 10, on: .main, in: .common).autoconnect()


struct TestView: View {
    @StateObject private var imageLoader = ImageLoader()

    var body: some View {
        WatercolorBackground()
        NavigationStack{
            
        }
        .onReceive(timer) { _ in
            //imageLoader.randomize()
            //WatercolorBackground()
                //.ignoresSafeArea()
        }
        
    }
        
       
}


#Preview {
    TestView()
}
