//
//  BoardScoreButtons.swift
//  basketball-v1
//
//  Created by Ryan Rotella on 3/8/25.
//

import SwiftUI

struct BoardScoreButtons: View {
    //@StateObject private var gameTeams = GameTeams()
    @Environment(Document.self) var document
    @Binding var shotRemaining: Int //store as tenths of seconds - 24.0 * 10
    @AppStorage("score1") var score1:Int = 0
    @AppStorage("score2") var score2:Int = 0
    
    
    var body: some View {
        VStack{
            VStack {
                
                Button("\(document.model.teams[0].name) +1"){
                    score1 += 1
                    shotRemaining = 240
                }
                .font(.system(size: 20))
                .frame(width: 100, height: 25)
                .background(Color.gray)
                .foregroundColor(Color.white)
                .cornerRadius(30)
                Button("\(document.model.teams[0].name) +2"){
                    score1 += 2
                    shotRemaining = 240
                }
                .font(.system(size: 20))
                .frame(width: 100, height: 25)
                .background(Color.gray)
                .foregroundColor(Color.white)
                .cornerRadius(30)
                Button("\(document.model.teams[0].name) +3"){
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
                Button("\(document.model.teams[0].name) -1"){
                    score1 -= 1
                    shotRemaining = 240
                }
                .font(.system(size: 20))
                .frame(width: 100, height: 25)
                .background(Color.red)
                .foregroundColor(Color.white)
                .cornerRadius(30)
                Button("\(document.model.teams[0].name) -2"){
                    score1 -= 2
                    shotRemaining = 240
                }
                .font(.system(size: 20))
                .frame(width: 100, height: 25)
                .background(Color.red)
                .foregroundColor(Color.white)
                .cornerRadius(30)
                Button("\(document.model.teams[0].name) -3"){
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
                Button("\(document.model.teams[1].name) +1"){
                    score2 += 1
                    shotRemaining = 240
                }
                .font(.system(size: 20))
                .frame(width: 110, height: 25)
                .background(Color.teal)
                .foregroundColor(Color.white)
                .cornerRadius(30)
                Button("\(document.model.teams[1].name) +2"){
                    score2 += 2
                    shotRemaining = 240
                }
                .font(.system(size: 20))
                .frame(width: 110, height: 25)
                .background(Color.teal)
                .foregroundColor(Color.white)
                .cornerRadius(30)
                Button("\(document.model.teams[1].name) +3"){
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
                Button("\(document.model.teams[1].name) -1"){
                    score2 -= 1
                }
                .font(.system(size: 20))
                .frame(width: 110, height: 25)
                .background(Color.red)
                .foregroundColor(Color.white)
                .cornerRadius(30)
                Button("\(document.model.teams[1].name) -2"){
                    score2 -= 2
                }
                .font(.system(size: 20))
                .frame(width: 110, height: 25)
                .background(Color.red)
                .foregroundColor(Color.white)
                .cornerRadius(30)
                Button("\(document.model.teams[1].name) -3"){
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
    }
    
       
    }


//#Preview {
//    BoardScoreButtons()
//}
