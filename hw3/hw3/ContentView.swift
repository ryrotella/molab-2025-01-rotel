import SwiftUI



// Modified ContentView to use the new background
struct ContentView: View {
    @StateObject private var imageLoader = ImageLoader()
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    let timer = Timer.publish(every: 3.5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack (spacing: 1) {
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
