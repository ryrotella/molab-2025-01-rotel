//
//  VideoGalleryView.swift
//  YoutubeGallery
//
//  Created by Ryan Rotella on 4/3/25.
//

import SwiftUI

struct VideoGalleryView: View {
    @EnvironmentObject var videosStore: VideosStore
    @EnvironmentObject var authService: AuthService
    @State private var showAddVideo = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 160, maximum: 200))], spacing: 36) {
                    ForEach(videosStore.videos) { video in
                        NavigationLink(destination: VideoDetailView(video: video)) {
                            VideoThumbnailView(video: video)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
            }
            .navigationTitle("YouTube Gallery")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showAddVideo = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        authService.signOut()
                    }) {
                        Text("Sign Out")
                    }
                }
            }
            .sheet(isPresented: $showAddVideo) {
                AddVideoView()
            }
        }
        .onAppear {
            videosStore.fetchVideos()
        }
    }
}

#Preview {
    VideoGalleryView()
}
