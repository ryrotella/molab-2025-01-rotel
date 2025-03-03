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

struct AlbumView: View {
  @StateObject private var imageLoader = ImageLoader()
  let album: Album
  @State private var soundFile: String
  @State private var player: AVAudioPlayer? = nil
  //added by Claude.ai
  @State private var audioLevel: CGFloat = 0.0
  @State private var isPlaying: Bool = false
  @State private var currentTrackIndex: Int = 0
  @State private var rotation: Double = 0
  @State private var rotationTimer: Timer? = nil

  // Initialize in init() - from Claude.ai - https://claude.ai/chat/e766c9c2-73ba-41d5-bbe7-b45328331871
  init(album: Album) {
    self.album = album
    // Initialize the @State property
    _soundFile = State(initialValue: self.album.audio)
  }

  var body: some View {
    ScrollView {
      ZStack {
        WatercolorBackground()
          .ignoresSafeArea()
        VStack(spacing: 0) {
          // Progress bar
          ProgressView(
            value: player?.currentTime ?? 0, total: player?.duration ?? 100
          )
          .padding(.horizontal)
          .padding(.top)
          ZStack {
            //main content area
            VStack(alignment: .center, spacing: 20) {
              //Now playing bar - eventually want to do each song but just playing an album for right now
              Text("Playing: \(album.name) by \(album.artist)")
                .font(.headline)
                .padding(.top)
                .padding(.horizontal)
              HStack {
                Button("Play") {
                  print("Button Play")
                  player = loadBundleAudio(soundFile)
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
              //Tracks and Notes
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
              Image(uiImage: album.cover)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 175, height: 175)
                .clipShape(Circle())
                .rotationEffect(.degrees(rotation))
                .shadow(radius: 8)
                .offset(y: 100)
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
            }

          }
          .task {
            await imageLoader.loadImages()
          }
        }
      }
    }
  }
}

#Preview {
  AlbumView(album: modalSoul)
}
