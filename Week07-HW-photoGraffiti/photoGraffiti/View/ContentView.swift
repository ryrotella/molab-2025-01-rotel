//
//  ContentView.swift
//  photoGraffiti
//
//  Created by Ryan Rotella on 3/13/25.
//

//
//  ContentView.swift
//  Instafilter
//
//  Created by Paul Hudson on 12/12/2023.
//

import CoreImage
import PhotosUI
import StoreKit
import SwiftUI

struct ContentView: View {
    @State private var processedImage: Image?
    @State private var selectedItem: PhotosPickerItem?
    @ObservedObject var canvas: Canvas

  
    var body: some View {
        
            NavigationStack {
                
                SelectPhoto(processedImage: $processedImage, selectedItem: $selectedItem)
                
                CanvasView(canvas: canvas)
                    


                
            }
            
       
        
    }



    

}

#Preview {
    ContentView(canvas: Canvas())
       // .previewLayout(.sizeThatFits)
}
