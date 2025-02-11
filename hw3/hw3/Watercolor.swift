//
//  Watercolor.swift
//  hw3
//
//  Created by Ryan Rotella on 2/11/25.
//

import SwiftUI


//collaborated with Claude.ai: https://claude.ai/chat/9b1f0767-03fd-439d-b37e-c922767a4c5b
struct WatercolorShape: Shape {
    let seed: Int
    
    // Add some randomness to make it more organic
     func randomOffset() -> CGFloat {
        CGFloat.random(in: -50...50)
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        // Create multiple organic curves for watercolor effect
        path.move(to: CGPoint(x: 0, y: height * -0.1))
        
        // First blob
        path.addCurve(
            to: CGPoint(x: width * 0.8, y: height * 0.2 + randomOffset()),
            control1: CGPoint(x: width * 1.2, y: height * -0.2 + randomOffset()),
            control2: CGPoint(x: width * 0.7, y: height * 0.0 + randomOffset())
        )
        
        // Second blob
        path.addCurve(
            to: CGPoint(x: width, y: height * 0.8),
            control1: CGPoint(x: width , y: height * 0.5 + randomOffset()),
            control2: CGPoint(x: width * 0.6, y: height * 0.55 + randomOffset())
        )
        
        // Bottom curve
        path.addCurve(
            to: CGPoint(x: 0, y: height * 0.8),
            control1: CGPoint(x: width * 0.8, y: height * 0.9 + randomOffset()),
            control2: CGPoint(x: width * 0.5, y: height * 0.9 + randomOffset())
        )
        
        return path
    }
}


struct WatercolorBackground: View {
    @State private var animate = false
    
//    var randomColor = CGFloat.random(in: 0.2...0.9)
//    var randomOpacity = CGFloat.random(in: 0.2...0.5)
    
    let colors: [Color] = [
        Color(red: CGFloat.random(in: 0.2...0.9), green: CGFloat.random(in: 0.2...0.9), blue: CGFloat.random(in: 0.2...0.9), opacity: 0.3),
        Color(red: CGFloat.random(in: 0.2...0.9), green: CGFloat.random(in: 0.2...0.9), blue: CGFloat.random(in: 0.2...0.9), opacity: 0.3),
        Color(red: CGFloat.random(in: 0.2...0.9), green: CGFloat.random(in: 0.2...0.9), blue: CGFloat.random(in: 0.2...0.9), opacity: 0.3)
    ]
    
    var body: some View {
        ZStack {
            ForEach(0..<3) { index in
                WatercolorShape(seed: index)
                    .fill(colors[index])
                    .scaleEffect(animate ? 1.1 : 1.0)
                    .offset(x: animate ? 30 : -70, y: animate ? -5 : 5)
                    .animation(
                        Animation.easeInOut(duration: 7)
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 1.5),
                        value: animate
                    )
            }
        }
        .onAppear {
            animate = true
        }
    }
}
