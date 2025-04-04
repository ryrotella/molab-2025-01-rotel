//
//  VideosStore.swift
//  YoutubeGallery
//
//  Created by Ryan Rotella on 4/3/25.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

class VideosStore: ObservableObject {
    @Published var videos: [VideoItem] = []
    private var db = Firestore.firestore()
    
    func fetchVideos() {
        db.collection("videos").order(by: "dateAdded", descending: true).addSnapshotListener { snapshot, error in
            guard let documents = snapshot?.documents else {
                print("Error fetching videos: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            self.videos = documents.compactMap { document -> VideoItem? in
                try? document.data(as: VideoItem.self)
            }
        }
    }
    
    func addVideo(title: String, youtubeURL: String, thumbnailURL: String, username: String) {
        let newVideo = VideoItem(
            title: title,
            youtubeURL: youtubeURL,
            thumbnailURL: thumbnailURL,
            addedBy: username,
            dateAdded: Date()
        )
        
        do {
            _ = try db.collection("videos").addDocument(from: newVideo)
        } catch {
            print("Error adding video: \(error.localizedDescription)")
        }
    }
    
    func deleteVideo(at indexSet: IndexSet) {
        for index in indexSet {
            let video = videos[index]
            db.collection("videos").document(video.id).delete()
        }
    }
}
