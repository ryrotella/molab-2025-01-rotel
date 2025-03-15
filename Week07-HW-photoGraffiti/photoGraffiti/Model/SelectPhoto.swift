//
//  SelectPhoto.swift
//  photoGraffiti
//
//  Created by Ryan Rotella on 3/13/25.
//

import SwiftUI
import _PhotosUI_SwiftUI

struct SelectPhoto: View {
    @Binding var processedImage: Image?
    @Binding var selectedItem: PhotosPickerItem?
    @State private var isPickerPresented = false
    
    var body: some View {
        ZStack {
           // Spacer()

           
                if let processedImage {
                    processedImage
                        .resizable()
                        .scaledToFill()
                } else {
                   // ContentUnavailableView("No picture", systemImage: "photo.badge.plus", description: Text(""))
                }
                
           
          
                Button(action: {
                                showPhotoPicker()
                            }) {
                                Label("Select Photo", systemImage: "photo.on.rectangle")
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
            
            .buttonStyle(.plain)
            .photosPicker(isPresented: $isPickerPresented, selection: $selectedItem)
            .onChange(of: selectedItem, loadImage)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)


            //Spacer()

        }
    }
    
    func showPhotoPicker() {
          isPickerPresented = true
      }

    
    func loadImage() {
        Task {
            guard let imageData = try await selectedItem?.loadTransferable(type: Data.self) else { return }
            guard let inputImage = UIImage(data: imageData) else { return }

            
            processedImage = Image(uiImage: inputImage)
        }
    }
}




