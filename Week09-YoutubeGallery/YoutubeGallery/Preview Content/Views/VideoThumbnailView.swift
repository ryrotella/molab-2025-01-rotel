//
//  VideoThumbnailView.swift
//  YoutubeGallery
//
//  Created by Ryan Rotella on 4/3/25.
//

import SwiftUI

struct VideoThumbnailView: View {
    let video: VideoItem
    
    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: video.thumbnailURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .foregroundColor(.gray)
            }
            .frame(height: 180)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                Image(systemName: "play.circle.fill")
                    .font(.system(size: 42))
                    .foregroundColor(.white)
                    .shadow(radius: 2)
            )
            
            Text(video.title)
                .font(.headline)
                .lineLimit(2)
                .padding(.leading, 10)
            
            Text("Added by: \(video.addedBy)")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.leading, 10)
        }
    }
}

//#Preview {
//    VideoThumbnailView()
//}
