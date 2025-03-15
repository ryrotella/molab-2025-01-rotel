//
//  ControlBar.swift
//  photoGraffiti
//
//  Created by Ryan Rotella on 3/14/25.
//


/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A view that contains the buttons for interacting with the canvas or app.
*/

import SwiftUI
import PhotosUI

struct ControlBar: View {
    @ObservedObject var canvas: Canvas

    var body: some View {
        HStack {
            Spacer()

            Button {
                canvas.reset()
            } label: {
                Image(systemName: "trash.fill")
            }
        }
        .buttonStyle(.bordered)
        .controlSize(.large)
    }
}

struct ControlBar_Previews: PreviewProvider {
    static var previews: some View {
        ControlBar(canvas: Canvas())
            .previewLayout(.sizeThatFits)
    }
}
