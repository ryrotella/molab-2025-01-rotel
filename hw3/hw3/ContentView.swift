import SwiftUI

//collaborated with Claude.ai: https://claude.ai/chat/9b1f0767-03fd-439d-b37e-c922767a4c5b
struct WatercolorShape: Shape {
    let seed: Int
    
    // Add some randomness to make it more organic
    private func randomOffset() -> CGFloat {
        CGFloat.random(in: -50...50)
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        // Create multiple organic curves for watercolor effect
        path.move(to: CGPoint(x: 0, y: height * 0.1))
        
        // First blob
        path.addCurve(
            to: CGPoint(x: width * 0.8, y: height * 0.2 + randomOffset()),
            control1: CGPoint(x: width * 0.2, y: 0 + randomOffset()),
            control2: CGPoint(x: width * 0.3, y: height * 0.0 + randomOffset())
        )
        
        // Second blob
        path.addCurve(
            to: CGPoint(x: width, y: height * 0.3),
            control1: CGPoint(x: width , y: height * 0.3 + randomOffset()),
            control2: CGPoint(x: width * 0.5, y: height * 0.7 + randomOffset())
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
    
    let colors: [Color] = [
        Color(red: CGFloat.random(in: 0.2...0.9), green: CGFloat.random(in: 0.2...0.9), blue: CGFloat.random(in: 0.2...0.9), opacity: 0.3),
        Color(red: CGFloat.random(in: 0.2...0.9), green: CGFloat.random(in: 0.2...0.9), blue: CGFloat.random(in: 0.2...0.9), opacity: 0.4),
        Color(red: CGFloat.random(in: 0.2...0.9), green: CGFloat.random(in: 0.2...0.9), blue: CGFloat.random(in: 0.2...0.9), opacity: 0.4)
    ]
    
    var body: some View {
        ZStack {
            ForEach(0..<3) { index in
                WatercolorShape(seed: index)
                    .fill(colors[index])
                    .scaleEffect(animate ? 1.1 : 1.0)
                    .offset(x: animate ? 10 : -10, y: animate ? -5 : 5)
                    .animation(
                        Animation.easeInOut(duration: 4)
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.5),
                        value: animate
                    )
            }
        }
        .onAppear {
            animate = true
        }
    }
}

// Modified ContentView to use the new background
struct ContentView: View {
    @StateObject private var imageLoader = ImageLoader()
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    let timer = Timer.publish(every: 3.5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            LazyVGrid(columns: columns, spacing: 40) {
                ForEach(0..<imageLoader.albumImages.count, id: \.self) { index in
                    Image(uiImage: imageLoader.albumImages[index])
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaledToFill()
                        .frame(width: 175, height: 175)
                        .cornerRadius(4)
                        .shadow(radius: 12)
                        .containerRelativeFrame(.horizontal) { size, axis in
                            size * 0.8
                        }
                }
            }
            .padding()
        }
        .background {
            WatercolorBackground()
        }
        .onReceive(timer) { _ in
            imageLoader.randomize()
        }
        .task {
            await imageLoader.loadImages()
            imageLoader.randomize()
        }
    }
}

#Preview {
  ContentView()
}
