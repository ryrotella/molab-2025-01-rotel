//
//  VideoItem.swift
//  YoutubeGallery
//
//  Created by Ryan Rotella on 4/3/25.
//

import SwiftUI
//import FirebaseFirestore
//import FirebaseAuth

// MARK: - Data Models

struct VideoItem: Identifiable, Codable {
    var id: String = UUID().uuidString
    let title: String
    let youtubeURL: String
    let thumbnailURL: String
    let addedBy: String
    let dateAdded: Date
    
    var videoID: String? {
        // Extract YouTube video ID from URL
        guard let url = URL(string: youtubeURL) else { return nil }
        
        if url.host == "youtu.be" {
            return url.lastPathComponent
        } else if url.host?.contains("youtube.com") == true {
            guard let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems else { return nil }
            return queryItems.first(where: { $0.name == "v" })?.value
        }
        
        return nil
    }
    
    var embedURL: URL? {
        guard let videoID = videoID else { return nil }
        return URL(string: "https://www.youtube.com/embed/\(videoID)")
    }
}
