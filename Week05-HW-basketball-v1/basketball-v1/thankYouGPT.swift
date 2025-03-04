//
//  test.swift
//  basketball-v1
//
//  Created by Ryan Rotella on 3/1/25.
//

import SwiftUI

//from chatGpt: https://chatgpt.com/c/67c388b3-cbec-8002-bfc0-843807292e41
struct ScoreboardView: View {
    @State private var gameClockSeconds: Int = 720 // Default: 12 minutes (12 * 60)
    @State private var shotClockTenths: Int = 240  // Default: 24.0 seconds (24 * 10)

    @State private var gameClockInput: String = ""  // User input for game clock
    @State private var shotClockInput: String = ""  // User input for shot clock

    @State private var timerRunning: Bool = false
    @State private var timer: Timer?

    var body: some View {
        VStack {
            // Game Clock Display
            Text("Game Clock: \(formattedTime(gameClockSeconds))")
                .font(.largeTitle)
                .padding()

            // Shot Clock Display
            Text("Shot Clock: \(formattedShotClock(shotClockTenths))")
                .font(.title)
                .foregroundColor(.red)
                .padding()

            // Game Clock Input
            TextField("Enter game time (MM:SS)", text: $gameClockInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numbersAndPunctuation)
                .multilineTextAlignment(.center)
                .padding()

            Button("Update Game Clock") {
                if let seconds = parseTimeInput(gameClockInput) {
                    gameClockSeconds = seconds
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)

            // Shot Clock Input
            TextField("Enter shot clock time (SS.t)", text: $shotClockInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numbersAndPunctuation)
                .multilineTextAlignment(.center)
                .padding()

            Button("Update Shot Clock") {
                if let tenths = parseShotClockInput(shotClockInput) {
                    shotClockTenths = tenths
                }
            }
            .padding()
            .background(Color.orange)
            .foregroundColor(.white)
            .cornerRadius(10)

            // Start/Stop Timer Button
            Button(timerRunning ? "Stop Clock" : "Start Clock") {
                toggleTimer()
            }
            .padding()
            .background(timerRunning ? Color.red : Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }

    // Convert game clock seconds to MM:SS format
    func formattedTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    // Convert shot clock tenths to SS.t format
    func formattedShotClock(_ tenths: Int) -> String {
        let seconds = tenths / 10
        let tenthsPart = tenths % 10
        return String(format: "%02d.%d", seconds, tenthsPart)
    }

    // Parse MM:SS input into total seconds
    func parseTimeInput(_ input: String) -> Int? {
        let components = input.split(separator: ":").compactMap { Int($0) }
        if components.count == 2 {
            return (components[0] * 60) + components[1]
        }
        return nil
    }

    // Parse SS.t or SS input into total tenths
    func parseShotClockInput(_ input: String) -> Int? {
        let components = input.split(separator: ".").compactMap { Int($0) }
        if components.count == 1 {
            return components[0] * 10  // Convert seconds to tenths
        } else if components.count == 2 {
            return (components[0] * 10) + components[1]
        }
        return nil
    }

    // Toggle the game clock running state
    func toggleTimer() {
        if timerRunning {
            timer?.invalidate()
            timerRunning = false
        } else {
            timerRunning = true
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                if gameClockSeconds > 0 || shotClockTenths > 0 {
                    // Decrease the shot clock every 0.1 seconds
                    if shotClockTenths > 0 {
                        shotClockTenths -= 1
                    }

                    // Decrease the game clock every full second
                    if shotClockTenths % 10 == 0 {
                        if gameClockSeconds > 0 {
                            gameClockSeconds -= 1
                        }
                    }
                } else {
                    timer?.invalidate()
                    timerRunning = false
                }
            }
        }
    }
}

struct ScoreboardView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreboardView()
    }
}
