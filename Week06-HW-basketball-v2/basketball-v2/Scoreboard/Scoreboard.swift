//
//  Scoreboard.swift
//  basketball-v1
//
//  Created by Ryan Rotella on 2/28/25.
//

import SwiftUI

struct Scoreboard: View {
    @Environment(Document.self) var document

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
     
    var body: some View {
        Spacer()
        MainBoard(gameTimeRemaining: $gameTimeRemaining, shotRemaining: $shotRemaining, quarters: $quarters, qIndex: $qIndex)
        Spacer()
        HStack{

            BoardScoreButtons(shotRemaining: $shotRemaining)
            BoardTimeButtons(gameTimeRemaining: $gameTimeRemaining, gTime: $gTime, shotRemaining: $shotRemaining, sTime: $sTime, timerIsRunning: $timerIsRunning, quarters: $quarters, qIndex: $qIndex)
            }
        }
    }


#Preview {
    Scoreboard()
        .environment(Document())
}





//from Taskin's code - https://github.com/TaskinRe/Molab-2025-01-Taskin/blob/main/Week_06%20Assignmnet/Week_06%20Assignmnet/MeditationView.swift






