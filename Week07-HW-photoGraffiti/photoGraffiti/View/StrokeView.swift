//
//  StrokeView.swift
//  photoGraffiti
//
//  Created by Ryan Rotella on 3/13/25.
//

//From WWDC: Draw Together

/*
Abstract:
A view to draw an individual stroke.
*/

import SwiftUI

struct StrokeView: View {
    @ObservedObject var stroke: Stroke
    @Binding var sColor:Color

    var body: some View {
        stroke.path
            .stroke(sColor, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
    }
}

//struct StrokeView_Previews: PreviewProvider {
//    static var previews: some View {
//        StrokeView(stroke: Stroke(color: .red))
//            .previewLayout(.sizeThatFits)
//    }
//}
