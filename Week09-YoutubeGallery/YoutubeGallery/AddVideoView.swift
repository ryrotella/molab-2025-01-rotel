////
////  AddVideoView.swift
////  YoutubeGallery
////
////  Created by Ryan Rotella on 4/3/25.
////
//
import SwiftUI
//
//struct AddVideoView: View {
//    @EnvironmentObject var videosStore: VideosStore
//    @EnvironmentObject var authService: AuthService
//    @Environment(\.dismiss) private var dismiss
//    
//    @State private var youtubeURL = ""
//    @State private var title = ""
//    @State private var thumbnailURL = ""
//    @State private var isValidatingURL = false
//    @State private var errorMessage = ""
//    @State private var showError = false
//    
//    var body: some View {
//        NavigationStack {
//            Form {
//                Section(header: Text("Video Link")) {
//                    TextField("YouTube URL", text: $youtubeURL)
//                        .autocapitalization(.none)
//                        .disableAutocorrection(true)
//                        .keyboardType(.URL)
//                    
//                    Button("Validate URL") {
//                        validateURL()
//                    }
//                    .disabled(youtubeURL.isEmpty)
//                }
//                
//                if !title.isEmpty {
//                    Section(header: Text("Video Details")) {
//                        TextField("Title", text: $title)
//                        
//                        if !thumbnailURL.isEmpty {
//                            AsyncImage(url: URL(string: thumbnailURL)) { image in
//                                image
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fit)
//                            } placeholder: {
//                                Rectangle()
//                                    .foregroundColor(.gray)
//                            }
//                            .frame(height: 160)
//                            .clipShape(RoundedRectangle(cornerRadius: 8))
//                        }
//                    }
//                }
//            }
//            .navigationTitle("Add Video")
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .cancellationAction) {
//                    Button("Cancel") {
//                        dismiss()
//                    }
//                }
//                
//                ToolbarItem(placement: .confirmationAction) {
//                    Button("Add") {
//                        addVideo()
//                    }
//                    .disabled(title.isEmpty || youtubeURL.isEmpty || thumbnailURL.isEmpty)
//                }
//            }
//            .overlay {
//                if isValidatingURL {
//                    ProgressView("Validating URL...")
//                        .padding()
//                        .background(Color(.systemBackground))
//                        .cornerRadius(8)
//                        .shadow(radius: 4)
//                }
//            }
//            .alert("Error", isPresented: $showError) {
//                Button("OK") {}
//            } message: {
//                Text(errorMessage)
//            }
//        }
//    }
//    
//    private func validateURL() {
//        isValidatingURL = true
//        
//        YouTubeURLParser.extractVideoInfo(from: youtubeURL) { videoTitle, videoThumbnail in
//            title = videoTitle
//            thumbnailURL = videoThumbnail
//            isValidatingURL = false
//        }
//    }
//    
//    private func addVideo() {
//        guard !title.isEmpty, !youtubeURL.isEmpty, !thumbnailURL.isEmpty else {
//            errorMessage = "Please fill in all fields"
//            showError = true
//            return
//        }
//        
//        videosStore.addVideo(
//            title: title,
//            youtubeURL: youtubeURL,
//            thumbnailURL: thumbnailURL,
//            username: authService.username
//        )
//        
//        dismiss()
//    }
//}
//
//#Preview {
//    AddVideoView()
//}

struct AddVideoView: View {
    @EnvironmentObject var videosStore: VideosStore
    @EnvironmentObject var authService: AuthService
    @Environment(\.dismiss) private var dismiss
    
    @State private var youtubeURL = ""
    @State private var title = ""
    @State private var thumbnailURL = ""
    @State private var isValidatingURL = false
    @State private var errorMessage = ""
    @State private var showError = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Video Link")) {
                    TextField("YouTube URL", text: $youtubeURL)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .keyboardType(.URL)
                    
                    Button("Validate URL") {
                        validateURL()
                    }
                    .disabled(youtubeURL.isEmpty)
                }
                
                Section(header: Text("Video Details")) {
                    TextField("Video Title", text: $title)
                    
                    if !thumbnailURL.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Thumbnail Preview:")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            AsyncImage(url: URL(string: thumbnailURL)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            } placeholder: {
                                Rectangle()
                                    .foregroundColor(.gray)
                            }
                            .frame(height: 160)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                }
            }
            .navigationTitle("Add Video")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        addVideo()
                    }
                    .disabled(title.isEmpty || youtubeURL.isEmpty || thumbnailURL.isEmpty)
                }
            }
            .overlay {
                if isValidatingURL {
                    ProgressView("Validating URL...")
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(8)
                        .shadow(radius: 4)
                }
            }
            .alert("Error", isPresented: $showError) {
                Button("OK") {}
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private func validateURL() {
        isValidatingURL = true
        
        // Extract video ID from URL
        guard let url = URL(string: youtubeURL),
              let videoID = extractVideoID(from: url) else {
            isValidatingURL = false
            errorMessage = "Invalid YouTube URL. Please enter a valid YouTube video link."
            showError = true
            return
        }
        
        // Just set the thumbnail URL based on the video ID
        thumbnailURL = "https://img.youtube.com/vi/\(videoID)/0.jpg"
        isValidatingURL = false
    }
    
    private func extractVideoID(from url: URL) -> String? {
        if url.host == "youtu.be" {
            return url.lastPathComponent
        } else if url.host?.contains("youtube.com") == true {
            guard let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems else { return nil }
            return queryItems.first(where: { $0.name == "v" })?.value
        }
        return nil
    }
    
    private func addVideo() {
        guard !title.isEmpty, !youtubeURL.isEmpty, !thumbnailURL.isEmpty else {
            errorMessage = "Please fill in all fields"
            showError = true
            return
        }
        
        videosStore.addVideo(
            title: title,
            youtubeURL: youtubeURL,
            thumbnailURL: thumbnailURL,
            username: authService.username
        )
        
        dismiss()
    }
}
