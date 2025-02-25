//
//  ContentView.swift
//  dillabes
//
//  Created by Ryan Rotella on 2/22/25.
//

import SwiftUI



// Modified ContentView to use the new background
struct ContentView: View {
    @StateObject private var imageLoader = ImageLoader()
    @State private var selectedAlbumID: String? = nil
    @State private var showAlbumView = false
    
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    let timer = Timer.publish(every: 10, on: .main, in: .common).autoconnect()
    
    var body: some View {
        //changed from NavigationView to NavigationStack - based on Claude.ai
     
            NavigationStack {
                VStack (spacing: 1) {
                    LazyVGrid(columns: columns, spacing: 40) {
                        ForEach(0..<imageLoader.albums.count, id: \.self) { index in
                            Image(uiImage: imageLoader.albums[index].cover)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .scaledToFill()
                                .frame(width: 175, height: 175)
                                .cornerRadius(4)
                                .shadow(radius: 12)
                                .containerRelativeFrame(.horizontal) { size, axis in
                                    size * 0.8
                                }
                            
                            //asked claude.ai - "in swift, if a user taps/clicks on an image, how do i present a new page view"
                                .onTapGesture {
                                    selectedAlbumID = imageLoader.albums[index].name
                                    showAlbumView = true
                                }
                            
                        }
                    }
                    .padding()
                }
                .background {
                    WatercolorBackground()
                }
                .navigationDestination(isPresented: $showAlbumView){
                    if let albumID = selectedAlbumID,
                       let album = imageLoader.albums.first(where: {$0.name == albumID})
                    {
                        AlbumView(albumName: album.name,
                                  albumLink: album.audio,
                                  albumImage: album.cover,
                                  albumArtist: album.artist,
                                  year: album.year,
                                  tracklist: album.trackList,
                                  notes: album.notes
                        )
                        
                    }
                }
                .onReceive(timer) { _ in
                    imageLoader.randomize()
                    
                }
                .task {
                    await imageLoader.loadImages()
                    //imageLoader.randomize()
                    
                    //                let x: () = print("test", imageLoader.albums[0].cover)
                    //                let y: () = print("real image", imageLoader.albumImages[0])
                }
            }
        }
    }

#Preview {
    ContentView()
}
