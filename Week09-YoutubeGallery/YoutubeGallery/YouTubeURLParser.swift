//
//  YouTubeURLParser.swift
//  YoutubeGallery
//
//  Created by Ryan Rotella on 4/3/25.
//

import SwiftUI


struct YouTubeURLParser {
    static func extractVideoInfo(from urlString: String, completion: @escaping (String, String) -> Void) {
        // In a real app, you would use YouTube Data API to fetch video details
        // This is a simplified version
        guard let url = URL(string: urlString),
              let videoID = extractVideoID(from: url) else {
            completion("Untitled Video", "https://img.youtube.com/vi/default/0.jpg")
            return
        }
        
        // Use the video ID to create a thumbnail URL
        let thumbnailURL = "https://img.youtube.com/vi/\(videoID)/0.jpg"
        
        // For a complete app, you would fetch the actual title using YouTube Data API
        // For this example, we'll just use "YouTube Video" as the title
        completion("YouTube Video", thumbnailURL)
    }
    
    static func extractVideoID(from url: URL) -> String? {
        if url.host == "youtu.be" {
            return url.lastPathComponent
        } else if url.host?.contains("youtube.com") == true {
            guard let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems else { return nil }
            return queryItems.first(where: { $0.name == "v" })?.value
        }
        return nil
    }
}
