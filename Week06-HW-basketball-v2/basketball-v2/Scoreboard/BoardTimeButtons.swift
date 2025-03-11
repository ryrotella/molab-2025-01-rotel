//
//  BoardTimeButtons.swift
//  basketball-v1
//
//  Created by Ryan Rotella on 3/8/25.
//

import SwiftUI

struct BoardTimeButtons: View {
    // Game clock
    @Binding var gameTimeRemaining: Double
    @Binding var gTime: String
     
    //Shot clock
    @Binding var shotRemaining: Int //store as tenths of seconds - 24.0 * 10
    @Binding var sTime: String
    // Flag for timer state.
    @Binding var timerIsRunning: Bool
    
    @Binding var quarters: [Int]
    
    @Binding var qIndex: Int
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        //clock buttons
        VStack{
            Button(action: {
                // Toggle timer on/off.
                self.timerIsRunning.toggle()
                
            }) {
                // Start / Stop Button
                Text(timerIsRunning ? "Stop" : "Start")
                    .font(.system(size: 25))
                    .frame(width: 100, height: 35)
                    .background(Color.black)
                    .foregroundColor(Color.white)
                    .cornerRadius(30)
            }
            Button(action: {
                // change quarter of game
                
                //handle reset change from last to 1st
                if (qIndex < quarters.count-1){
                    self.qIndex += 1
                } else {
                    self.qIndex = 0
                }
                
                
            }) {
                // Start / Stop Button
                Text("Change \n Quarter")
                    .font(.system(size: 20))
                    .frame(width: 120, height: 50)
                    .background(Color.black)
                    .foregroundColor(Color.white)
                    .cornerRadius(30)
            }
            
            Button(action: {
                
                if let seconds = parseTimeInput(gTime) {
                    gameTimeRemaining = Double(seconds)
                }
                
            }) {
                // Start / Stop Button
                Text("Change \n Game Time")
                    .font(.system(size: 20))
                    .frame(width: 125, height: 50)
                    .background(Color.black)
                    .foregroundColor(Color.white)
                    .cornerRadius(30)
            }
            TextField("Enter Time (MM:SS)", text: $gTime)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numbersAndPunctuation)
                .multilineTextAlignment(.center)
                .padding()
            
            Button(action: {
                
                if let seconds = parseShotClockInput(sTime){
                    if (seconds <= 240){
                        shotRemaining = seconds
                    }
                }
                
            }) {
                // Start / Stop Button
                Text("Change \n Shot Clock")
                    .font(.system(size: 20))
                    .frame(width: 125, height: 50)
                    .background(Color.black)
                    .foregroundColor(Color.white)
                    .cornerRadius(30)
            }
            TextField("Enter Time (SS.s)", text: $sTime)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numbersAndPunctuation)
                .multilineTextAlignment(.center)
                .padding()
        }
        .onReceive(timer) { _ in
                        // Block gets called when timer updates.
                        
                        // If timeRemaining and timer is running, count down.
                        if self.gameTimeRemaining > 0 && self.shotRemaining > 0 && self.timerIsRunning {
                            //                    self.gameTimeRemaining -= 1
                            //                    self.shotRemaining -= 1
                            
                            // Decrease the shot clock every 0.1 seconds
                            if shotRemaining > 0 {
                                shotRemaining -= 1
                            }
                            
                            //Decrease the game clock every second
                            if shotRemaining % 10 == 0 {
                                if gameTimeRemaining > 0 {
                                    gameTimeRemaining -= 1
                                }
                            }
                            
                            print("Game Time Remaining:", self.gameTimeRemaining)
                            print("Shot Clock remaining:",
                                  self.shotRemaining)
                        }
                    }
        
        
        }
    }

// Parse SS.t or SS input into total tenths
private func parseShotClockInput(_ input: String) -> Int? {
    let components = input.split(separator: ".").compactMap { Int($0) }
    if components.count == 1 {
        return components[0] * 10  // Convert seconds to tenths
    } else if components.count == 2 {
        return (components[0] * 10) + components[1]
    }
    return nil
}

// Parse MM:SS input into total seconds
private func parseTimeInput(_ input: String) -> Int? {
    let components = input.split(separator: ":").compactMap { Int($0) }
    if components.count == 2 {
        return (components[0] * 60) + components[1]
    }
    return nil
}

//chatgpt: https://chatgpt.com/c/67cbdf15-a0e4-8002-afd6-bc43f1554d0f
// Update preview to provide sample bindings
struct BoardTimeButtons_Previews: PreviewProvider {
    static var previews: some View {
        BoardTimeButtons(
            gameTimeRemaining: .constant(900.0),
            gTime: .constant("12:00"),
            shotRemaining: .constant(240),
            sTime: .constant("24.0"),
            timerIsRunning: .constant(false),
            quarters: .constant([1, 2, 3, 4]),
            qIndex: .constant(0)
        )
    }
}
