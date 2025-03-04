//
//  Scoreboard.swift
//  basketball-v1
//
//  Created by Ryan Rotella on 2/28/25.
//

import SwiftUI

struct Scoreboard: View {
    @StateObject private var gameTeams = GameTeams()
    // Game clock
    @State var gameTimeRemaining = 900.0
    @State private var gTime: String = ""
     
    //Shot clock
    @State var shotRemaining: Int = 240 //store as tenths of seconds - 24.0 * 10
    @State private var sTime: String = ""
    
    // Flag for timer state.
    @State var timerIsRunning = false
    
    @State var quarters = [1, 2, 3, 4]
    
    @State var qIndex = 0
    
    @AppStorage("score1") var score1:Int = 0
    @AppStorage("score2") var score2:Int = 0
    
    // Timer gets called every second.
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        Spacer()
        VStack{
            HStack (alignment: .top, spacing: 50){
                Image(uiImage: gameTeams.teams[0].teamImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaledToFill()
                    .frame(width: 100, height: 100, alignment: .leading)
                VStack{
                    Text(gameTeams.teams[0].city)
                        .font(.system(size: 28))
                        .foregroundStyle(.blue)
                        .fontWeight(.heavy)
                    Text(gameTeams.teams[0].name)
                        .font(.system(size: 35))
                        .foregroundStyle(.gray)
                        .fontWeight(.heavy)
                }
                Text("\(score1)")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
            }
            .padding(12)
            .border(width: 5, edges: [.bottom], color: .white)
            
            HStack (alignment: .top, spacing: 50){
                Image(uiImage: gameTeams.teams[1].teamImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaledToFill()
                    .frame(width: 75, height: 75, alignment: .leading)
                VStack{
                    Text(gameTeams.teams[1].city)
                        .font(.system(size: 28))
                        .foregroundStyle(.cyan)
                        .fontWeight(.heavy)
                    
                    Text(gameTeams.teams[1].name)
                        .font(.system(size: 33))
                        .foregroundStyle(.red)
                        .fontWeight(.heavy)
                }
                .padding(.leading, 15)
                Text("\(score2)")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                    .padding(.trailing, 12)
                
            }
            .padding(20)
            .border(width: 2, edges: [.bottom], color: .gray)
            HStack (alignment: .bottom, spacing: 70){
                Text("Q\(quarters[qIndex])")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                Text(timeString(from: gameTimeRemaining))
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                Text(formattedShotClock(shotRemaining))
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                
            }
            
        }
        .background(scoreBg())
        Spacer()
        HStack{
            //score buttons
            //gameTeams.teams[0]
            VStack {
                VStack {
                    
                    Button("\(gameTeams.teams[0].name) +1"){
                        score1 += 1
                        shotRemaining = 240
                    }
                    .font(.system(size: 20))
                    .frame(width: 100, height: 25)
                    .background(Color.gray)
                    .foregroundColor(Color.white)
                    .cornerRadius(30)
                    Button("\(gameTeams.teams[0].name) +2"){
                        score1 += 2
                        shotRemaining = 240
                    }
                    .font(.system(size: 20))
                    .frame(width: 100, height: 25)
                    .background(Color.gray)
                    .foregroundColor(Color.white)
                    .cornerRadius(30)
                    Button("\(gameTeams.teams[0].name) +3"){
                        score1 += 3
                        shotRemaining = 240
                    }
                    .font(.system(size: 20))
                    .frame(width: 100, height: 25)
                    .background(Color.gray)
                    .foregroundColor(Color.white)
                    .cornerRadius(30)
                    .padding(.bottom, 5)
                    .border(width: 2, edges: [.bottom], color: .blue)
                    Button("\(gameTeams.teams[0].name) -1"){
                        score1 -= 1
                        shotRemaining = 240
                    }
                    .font(.system(size: 20))
                    .frame(width: 100, height: 25)
                    .background(Color.red)
                    .foregroundColor(Color.white)
                    .cornerRadius(30)
                    Button("\(gameTeams.teams[0].name) -2"){
                        score1 -= 2
                        shotRemaining = 240
                    }
                    .font(.system(size: 20))
                    .frame(width: 100, height: 25)
                    .background(Color.red)
                    .foregroundColor(Color.white)
                    .cornerRadius(30)
                    Button("\(gameTeams.teams[0].name) -3"){
                        score1 -= 3
                        shotRemaining = 240
                    }
                    .font(.system(size: 20))
                    .frame(width: 100, height: 25)
                    .background(Color.red)
                    .foregroundColor(Color.white)
                    .cornerRadius(30)
                }
                .padding(.bottom, 10)
                .border(width: 5, edges: [.bottom], color: .black)
                VStack {
                    Button("\(gameTeams.teams[1].name) +1"){
                        score2 += 1
                        shotRemaining = 240
                    }
                    .font(.system(size: 20))
                    .frame(width: 110, height: 25)
                    .background(Color.teal)
                    .foregroundColor(Color.white)
                    .cornerRadius(30)
                    Button("\(gameTeams.teams[1].name) +2"){
                        score2 += 2
                        shotRemaining = 240
                    }
                    .font(.system(size: 20))
                    .frame(width: 110, height: 25)
                    .background(Color.teal)
                    .foregroundColor(Color.white)
                    .cornerRadius(30)
                    Button("\(gameTeams.teams[1].name) +3"){
                        score2 += 3
                        shotRemaining = 240
                    }
                    .font(.system(size: 20))
                    .frame(width: 110, height: 25)
                    .background(Color.teal)
                    .foregroundColor(Color.white)
                    .cornerRadius(30)
                    .padding(.bottom, 5)
                    .border(width: 2, edges: [.bottom], color: .blue)
                    Button("\(gameTeams.teams[1].name) -1"){
                        score2 -= 1
                    }
                    .font(.system(size: 20))
                    .frame(width: 110, height: 25)
                    .background(Color.red)
                    .foregroundColor(Color.white)
                    .cornerRadius(30)
                    Button("\(gameTeams.teams[1].name) -2"){
                        score2 -= 2
                    }
                    .font(.system(size: 20))
                    .frame(width: 110, height: 25)
                    .background(Color.red)
                    .foregroundColor(Color.white)
                    .cornerRadius(30)
                    Button("\(gameTeams.teams[1].name) -3"){
                        score2 -= 3
                    }
                    .font(.system(size: 20))
                    .frame(width: 110, height: 25)
                    .background(Color.red)
                    .foregroundColor(Color.white)
                    .cornerRadius(30)
                }
            }
            .padding(50)
//            .border(width: 2, edges: [.trailing], color: .gray)
            
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
    
}

#Preview {
    Scoreboard()
}




//from Taskin's code - https://github.com/TaskinRe/Molab-2025-01-Taskin/blob/main/Week_06%20Assignmnet/Week_06%20Assignmnet/MeditationView.swift

private func timeString(from time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

// Parse MM:SS input into total seconds
func parseTimeInput(_ input: String) -> Int? {
    let components = input.split(separator: ":").compactMap { Int($0) }
    if components.count == 2 {
        return (components[0] * 60) + components[1]
    }
    return nil
}

// Convert shot clock tenths to SS.t format
func formattedShotClock(_ tenths: Int) -> String {
    let seconds = tenths / 10
    let tenthsPart = tenths % 10
    return String(format: "%02d.%d", seconds, tenthsPart)
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
