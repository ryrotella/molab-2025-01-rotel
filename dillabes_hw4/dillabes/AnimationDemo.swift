//
//  AnimationDemo.swift
//  dillabes
//
//  Created by jht2 on 3/3/25.
//

import SwiftUI

struct AnimationDemo: View {
  @State private var rotationDegrees = 0.0
  
  
  private var animation: Animation {
    .linear
    .speed(0.1)
    .repeatForever(autoreverses: false)
  }
  
  
  var body: some View {
    Image(systemName: "gear")
      .font(.system(size: 86))
      .rotationEffect(.degrees(rotationDegrees))
      .onAppear {
        withAnimation(animation) {
          rotationDegrees = 360.0
        }
      }
  }
}

#Preview {
  AnimationDemo()
}

