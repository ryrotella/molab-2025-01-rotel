//
//  CanvasView.swift
//  photoGraffiti
//
//  Created by Ryan Rotella on 3/13/25.
//


/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The view that draws the strokes to the canvas and responds to user input.
*/

import SwiftUI
import _PhotosUI_SwiftUI

struct CanvasView: View {
    @ObservedObject var canvas: Canvas
    @State private var selectedColor: Color = .black // Default color
    @State private var selectedImageItem: PhotosPickerItem? // Selected image item


    var body: some View {
        
        ZStack{
            
            
           // VStack{
                GeometryReader { _ in
                    ForEach(canvas.strokes) { stroke in
                        StrokeView(stroke: stroke, sColor: $selectedColor)
                    }
                    
                   
                    
                    ForEach(canvas.images) { image in
                        if let uiImage = UIImage(data: image.imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 250, height: 250)
                                .position(image.location)
                        }
                    }
                    
                    if let activeStroke = canvas.activeStroke {
                        StrokeView(stroke: activeStroke, sColor: $selectedColor)
                    }
                    
                }
           // }
            HStack{
                //Spacer()
                ColorPicker("Select Color", selection: $selectedColor)
                Spacer()
//                PhotosPicker(selection: $selectedImageItem, matching: .images) {
//                                    Label("Pick Image", systemImage: "photo")
//                                        .padding()
//                                        .background(Color.blue)
//                                        .foregroundColor(.white)
//                                        .cornerRadius(8)
//                                }
//                                .onChange(of: selectedImageItem) { loadImage() }
                
                Spacer()
                ControlBar(canvas: canvas)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        }
        .frame(maxHeight: .infinity)
        .background(Color(uiColor: .systemBackground))
        .gesture(strokeGesture)
        
       
    }

    var strokeGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                canvas.addPointToActiveStroke(value.location)
            }
            .onEnded { value in
                canvas.addPointToActiveStroke(value.location)
                canvas.finishStroke()
            }
    }
    func loadImage() {
           Task {
               guard let imageData = try await selectedImageItem?.loadTransferable(type: Data.self) else { return }
               canvas.addImage(imageData, at: CGPoint(x: 200, y: 200)) // Default position
           }
       }
}

struct CanvasView_Previews: PreviewProvider {
    static var previews: some View {
        CanvasView(canvas: Canvas())
            .previewLayout(.sizeThatFits)
    }
}
