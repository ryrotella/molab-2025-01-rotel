//
//  AlbumView.swift
//  dillabes
//
//  Created by Ryan Rotella on 2/22/25.
//

import AVFoundation
import SwiftUI

//from John Henry's sample code, Audio-State-Demo

func loadBundleAudio(_ fileName: String) -> AVAudioPlayer? {
  let path = Bundle.main.path(forResource: fileName, ofType: nil)!
  let url = URL(fileURLWithPath: path)
  do {
    return try AVAudioPlayer(contentsOf: url)
  } catch {
    print("loadBundleAudio error", error)
  }
  return nil
}

// From 05-ImageEditDemo
// Read in an image from a url string
func imageFor(string str: String) async -> UIImage!  {
  guard let url = URL(string: str),
        let imgData = try? Data(contentsOf: url),
        let uiImage = UIImage(data:imgData)
  else {
    return nil
  }
  return uiImage
}

struct AlbumView: View {
  //  @StateObject private var imageLoader = ImageLoader()
  let album: Album
  //  @State private var soundFile: String
  @State private var player: AVAudioPlayer? = nil
  //added by Claude.ai
  @State private var audioLevel: CGFloat = 0.0
  @State private var isPlaying: Bool = false
  @State private var currentTrackIndex: Int = 0
  @State var uiImage:UIImage?
  
  // Initialize in init() - from Claude.ai - https://claude.ai/chat/e766c9c2-73ba-41d5-bbe7-b45328331871
  //  init(album: Album) {
  //    self.album = album
  //    // Initialize the @State property
  //    _soundFile = State(initialValue: self.album.audio)
  //  }
  
  var body: some View {
    let _ = Self._printChanges()
    TimelineView(.animation) { timeline in
      ScrollView {
        ZStack {
//          WatercolorBackground()
//            .ignoresSafeArea()
          VStack(spacing: 0) {
            // Progress bar
            // !!@ Why does this not show?
            // see use of TimelineView 04-Audio-State-Demo / PlayAudioDJView
            //
            if let player {
              ProgressView(
                value: player.currentTime, total: player.duration
              )
              .padding(.horizontal)
              .padding(.top)
            }
            AlbumExtractedView(album: album, player: $player, isPlaying: $isPlaying, uiImage: uiImage)
            //          .task {
            //            await imageLoader.loadImages()
            //          }
          }
        }
      }
      .task {
        uiImage =  await imageFor(string: album.imageLink)
      }
    }
  }
}

struct AlbumExtractedView: View {
  let album: Album
  @Binding var player: AVAudioPlayer?
  @Binding var isPlaying: Bool
  var uiImage:UIImage?
  var body: some View {
    let _ = Self._printChanges()
    ZStack {
      //main content area
      VStack(alignment: .center, spacing: 20) {
        //Now playing bar - eventually want to do each song but just playing an album for right now
        AlbumMainView(album: album, player: $player, isPlaying: $isPlaying)
        //Tracks and Notes
        // AlbumTrackNotesView(album: album)
        //Spacer()
        // Artist and release info
        HStack {
          Text(album.artist)
            .font(.headline)
          Spacer()
          Text("Released:\n\(album.year)")
            .font(.headline)
            .multilineTextAlignment(.trailing)
        }
        .padding(.horizontal)
        .padding(.bottom)
        
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(Color(UIColor.systemGray6))
      // Spinning record at the bottom
      VStack {
        Spacer()
        //test view image: imageLoader.albums[0].cover
        //for real code: album.cover
        if let uiImage = uiImage {
          // AlbumCoverView(uiImage: uiImage, isPlaying: $isPlaying)
          if isPlaying {
            AlbumCoverAnimatedView(uiImage: uiImage)
          }
          else {
            AlbumCoverStaticView(uiImage: uiImage)
          }
        }
      }
    }
  }
}

struct AlbumMainView: View {
  let album: Album
  @Binding var player: AVAudioPlayer?
  @Binding var isPlaying: Bool
  var body: some View {
    Group {
      Text("Playing: \(album.name) by \(album.artist)")
        .font(.headline)
        .padding(.top)
        .padding(.horizontal)
      HStack {
        Button("Play") {
          print("Button Play")
          player = loadBundleAudio(album.audio)
          // player = loadBundleAudio(soundFile)
          print("player", player as Any)
          // Loop indefinitely
          //player?.numberOfLoops = -1
          player?.play()
          isPlaying = true
        }
        Button("Stop") {
          print("Button Stop")
          player?.stop()
          isPlaying = false
        }
      }
      //Text("soundIndex \(soundIndex)")
      //Text(soundFile)
      if let player = player {
        Text("duration " + String(format: "%.1f", player.duration))
          .lineSpacing(2)
        Text(
          "currentTime " + String(format: "%.1f", player.currentTime)
        )
        .lineSpacing(2)
      }
    }
  }
}

#Preview {
  AlbumView(album: modalSoul)
}

// Deal with rotation animation start/stop with own timer
// replaced by AlbumCoverAnimatedView and AlbumCoverStaticView
//
struct AlbumCoverView: View {
  //  let album: Album
  var uiImage:UIImage
  @Binding var isPlaying: Bool
  @State private var rotation: Double = 0
  @State private var rotationTimer: Timer? = nil
  private var animation: Animation {
    .linear
    .speed(0.1)
    .repeatForever(autoreverses: false)
  }
  var body: some View {
    let _ = Self._printChanges()
    Image(uiImage: uiImage)
      .resizable()
      .aspectRatio(contentMode: .fill)
      .frame(width: 175, height: 175)
      .clipShape(Circle())
      .rotationEffect(.degrees(rotation))
      .shadow(radius: 8)
      .offset(y: 100)
      .onChange(of: isPlaying) { _, newValue in
        print("AlbumCoverView onChange isPlaying: \(isPlaying)")
        if isPlaying {
          withAnimation(animation) {
            rotation = 360.0
          }
        }
      }
      .onChange(of: isPlaying) { _, newValue in
        if newValue {
          // Start rotation timer when playing
          rotationTimer = Timer.scheduledTimer(
            withTimeInterval: 0.05, repeats: true
          ) { _ in
            rotation += 1
            if rotation >= 360 {
              rotation = 0
            }
          }
        } else {
          // Stop rotation timer when paused
          rotationTimer?.invalidate()
          rotationTimer = nil
        }
      }
      .onDisappear {
        // Clean up timer when view disappears
        rotationTimer?.invalidate()
        rotationTimer = nil
      }
      .onAppear {
        print("AlbumCoverView uiImage", uiImage)
        print("AlbumCoverView isPlaying", isPlaying)
        if isPlaying {
          withAnimation(animation) {
            rotation = 360.0
          }
        }
      }
  }
}

struct AlbumCoverAnimatedView: View {
  //  let album: Album
  var uiImage:UIImage
  @State private var rotation: Double = 0
  private var animation: Animation {
    .linear
    .speed(0.1)
    .repeatForever(autoreverses: false)
  }
  var body: some View {
    let _ = Self._printChanges()
    Image(uiImage: uiImage)
      .resizable()
      .aspectRatio(contentMode: .fill)
      .frame(width: 175, height: 175)
      .clipShape(Circle())
      .rotationEffect(.degrees(rotation))
      .shadow(radius: 8)
      .offset(y: 100)
      .onAppear {
        print("AlbumCoverAnimatedView uiImage", uiImage)
        withAnimation(animation) {
          rotation = 360.0
        }
      }
  }
}

struct AlbumCoverStaticView: View {
  //  let album: Album
  var uiImage:UIImage
  var body: some View {
    let _ = Self._printChanges()
    Image(uiImage: uiImage)
      .resizable()
      .aspectRatio(contentMode: .fill)
      .frame(width: 175, height: 175)
      .clipShape(Circle())
      .shadow(radius: 8)
      .offset(y: 100)
      .onAppear {
        print("AlbumCoverStaticView uiImage", uiImage)
      }
  }
}

struct AlbumTrackNotesView: View {
  let album: Album
  var body: some View {
    HStack(alignment: .top) {
      //Track List
      VStack(alignment: .leading, spacing: 10) {
        Text("Track List")
          .font(.headline)
        ForEach(0..<album.trackList.count, id: \.self) { index in
          Text(album.trackList[index])
            .foregroundStyle(.primary)
          //onTapGesture{currentTrackIndex = index
          // Play the selected track playCurrentTrack()}
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
    }
    .padding(.horizontal)
  }
}


