//
//  MainBoard.swift
//  basketball-v1
//
//  Created by Ryan Rotella on 3/8/25.
//

import SwiftUI

struct MainBoard: View {
    //@StateObject private var gameTeams = GameTeams()
    @Environment(Document.self) var document

    // Game clock
    @Binding var gameTimeRemaining: Double
    
    @State var uiImageOne:UIImage?
    @State var uiImageTwo:UIImage?
     
    //Shot clock
    @Binding var shotRemaining: Int //store as tenths of seconds - 24.0 * 10
    
    @Binding var quarters: [Int]
    
    @Binding var qIndex: Int
    
    @AppStorage("score1") var score1:Int = 0
    @AppStorage("score2") var score2:Int = 0
    
    var body: some View {
        VStack {
            HStack (alignment: .top, spacing: 50){
                if let uiImageOne {
                    Image(uiImage: uiImageOne)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaledToFill()
                        .frame(width: 100, height: 100, alignment: .leading)
                }
                VStack{
                    Text(document.model.teams[0].city)
                        .font(.system(size: 28))
                        .foregroundStyle(.blue)
                        .fontWeight(.heavy)
                    Text(document.model.teams[0].name)
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
                if let uiImageTwo{
                    Image(uiImage: uiImageTwo)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaledToFill()
                        .frame(width: 75, height: 75, alignment: .leading)
                }
                VStack{
                    Text(document.model.teams[1].city)
                        .font(.system(size: 28))
                        .foregroundStyle(.cyan)
                        .fontWeight(.heavy)
                    
                    Text(document.model.teams[1].name)
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
        .task {
            uiImageOne = await imageFor(string: document.model.teams[0].teamImageLink)
            uiImageTwo = await imageFor(string: document.model.teams[1].teamImageLink)
        }
    }
       
   
    
    
}

//#Preview {
//    MainBoard(quarters: <#Binding<[Int]>#>, qIndex: <#Binding<Int>#>)
//}

private func timeString(from time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

// Convert shot clock tenths to SS.t format
private func formattedShotClock(_ tenths: Int) -> String {
    let seconds = tenths / 10
    let tenthsPart = tenths % 10
    return String(format: "%02d.%d", seconds, tenthsPart)
}
