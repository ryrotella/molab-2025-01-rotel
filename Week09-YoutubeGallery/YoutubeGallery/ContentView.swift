//
//  ContentView.swift
//  YoutubeGallery
//
//  Created by Ryan Rotella on 4/3/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var videosStore = VideosStore()
    @StateObject var authService = AuthService()
    
    var body: some View {
        Group {
            if authService.isLoggedIn {
                VideoGalleryView()
                    .environmentObject(videosStore)
                    .environmentObject(authService)
            } else {
                LoginView()
                    .environmentObject(authService)
            }
        }
    }
}

#Preview {
    ContentView()
}
