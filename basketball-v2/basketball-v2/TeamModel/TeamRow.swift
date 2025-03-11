//
//  TeamRow.swift
//  basketball-v1
//
//  Created by Ryan Rotella on 3/7/25.
//

import SwiftUI

struct TeamRow: View {
    var team: ScoreTeam
    
    @State var uiImage:UIImage?

    
    var body: some View {
       
        HStack {
            Spacer()
            ZStack {
                
                if let uiImage {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width:100, height: 100)
                }
                
               
            }
            Spacer()
            Text("\(team.city) \(team.name)")
            Spacer()
        }
        .task {
            uiImage =  await imageFor(string: team.teamImageLink)
        }
    }
}

#Preview {
  TeamRow(team: grizz)
    .environment(Document())
}
