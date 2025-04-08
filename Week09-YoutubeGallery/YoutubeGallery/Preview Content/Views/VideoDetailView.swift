//
//  VideoDetailView.swift
//  YoutubeGallery
//
//  Created by Ryan Rotella on 4/3/25.
//

import SwiftUI
import WebKit

struct YouTubePlayerView: UIViewRepresentable {
    let videoID: String
    
    func makeUIView(context: Context) -> WKWebView {
        // Create a configuration with necessary settings
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        
        // Add this line to allow fullscreen
        configuration.allowsPictureInPictureMediaPlayback = true
        
        // Create the webview with the configuration
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.scrollView.isScrollEnabled = false
        webView.allowsBackForwardNavigationGestures = false
        webView.allowsLinkPreview = false
        
        // Set the navigation delegate to handle fullscreen
        webView.navigationDelegate = context.coordinator
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Create a more detailed HTML embed to handle fullscreen and autoplay controls properly
        let html = """
        <!DOCTYPE html>
        <html>
        <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
            <style>
                body { margin: 0; padding: 0; background-color: black; }
                .container { position: relative; padding-bottom: 56.25%; height: 0; overflow: hidden; }
                iframe { position: absolute; top: 0; left: 0; width: 100%; height: 100%; }
            </style>
        </head>
        <body>
            <div class="container">
                <iframe src="https://www.youtube.com/embed/\(videoID)?playsinline=1&fs=1&rel=0" 
                    frameborder="0" 
                    allowfullscreen="true"
                    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; fullscreen">
                </iframe>
            </div>
        </body>
        </html>
        """
        
        uiView.loadHTMLString(html, baseURL: nil)
    }
    
    // Add a coordinator to handle fullscreen mode
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: YouTubePlayerView
        
        init(_ parent: YouTubePlayerView) {
            self.parent = parent
        }
        
        // This detects when the user taps the fullscreen button
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            // Optional JavaScript to improve fullscreen behavior
            let script = """
            var videoElements = document.getElementsByTagName('iframe');
            for (var i = 0; i < videoElements.length; i++) {
                videoElements[i].setAttribute('allowfullscreen', 'true');
            }
            """
            webView.evaluateJavaScript(script, completionHandler: nil)
        }
    }
}

struct VideoDetailView: View {
    let video: VideoItem
    @State private var isShowingFullVideo = false
    @Environment(\.openURL) var openURL
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Video Player
                if let videoID = video.videoID {
                    YouTubePlayerView(videoID: videoID)
                        .frame(height: 220)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(.systemGray5), lineWidth: 1)
                        )
                        .shadow(radius: 2)
                } else {
                    // Fallback to thumbnail with play button
                    AsyncImage(url: URL(string: video.thumbnailURL)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        Rectangle()
                            .foregroundColor(.gray)
                    }
                    .frame(height: 220)
                    .cornerRadius(8)
                    .overlay(
                        Button {
                            if let url = URL(string: video.youtubeURL) {
                                openURL(url)
                            }
                        } label: {
                            Image(systemName: "play.circle.fill")
                                .font(.system(size: 64))
                                .foregroundColor(.white)
                                .shadow(radius: 4)
                        }
                    )
                }
                
                // Video Title
                Text(video.title)
                    .font(.title2)
                    .fontWeight(.bold)
                
                // Video Actions
                HStack(spacing: 20) {
                    Button {
                        if let url = URL(string: video.youtubeURL) {
                            openURL(url)
                        }
                    } label: {
                        Label("Watch on YouTube", systemImage: "play.rectangle")
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button {
                        guard let url = URL(string: video.youtubeURL) else { return }
                        let activityVC = UIActivityViewController(
                            activityItems: [url],
                            applicationActivities: nil
                        )
                        
                        // Get the current window scene
                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                           let rootViewController = windowScene.windows.first?.rootViewController {
                            rootViewController.present(activityVC, animated: true)
                        }
                    } label: {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }
                    .buttonStyle(.bordered)
                }
                
                Divider()
                
                // Video Info
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .foregroundColor(.blue)
                        Text("Added by: \(video.addedBy)")
                        Spacer()
                    }
                    
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(.blue)
                        Text("Date added: \(formattedDate)")
                        Spacer()
                    }
                    
                    if let videoID = video.videoID {
                        HStack {
                            Image(systemName: "link")
                                .foregroundColor(.blue)
                            Text("Video ID: \(videoID)")
                                .lineLimit(1)
                                .truncationMode(.middle)
                            Spacer()
                        }
                    }
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                
                // Related Videos Section
                // In a full app, you would implement this section to show videos
                // from the same user or with similar tags
                Text("More from this user")
                    .font(.headline)
                    .padding(.top, 8)
                
                Text("This feature will display other videos added by \(video.addedBy)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Video Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button {
                        // In a real app, you would implement favoriting
                        // functionality here
                    } label: {
                        Label("Add to Favorites", systemImage: "heart")
                    }
                    
                    Button {
                        if let url = URL(string: video.youtubeURL) {
                            openURL(url)
                        }
                    } label: {
                        Label("Open in YouTube", systemImage: "arrow.up.right.square")
                    }
                    
                    Divider()
                    
                    Button(role: .destructive) {
                        // In a real app, you would implement reporting
                        // functionality here
                    } label: {
                        Label("Report Video", systemImage: "exclamationmark.triangle")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: video.dateAdded)
    }
}

// Preview Provider for SwiftUI Canvas
struct VideoDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            VideoDetailView(video: VideoItem(
                id: "1",
                title: "SwiftUI Tutorial for Beginners",
                youtubeURL: "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
                thumbnailURL: "https://img.youtube.com/vi/dQw4w9WgXcQ/0.jpg",
                addedBy: "Developer",
                dateAdded: Date()
            ))
        }
    }
}
