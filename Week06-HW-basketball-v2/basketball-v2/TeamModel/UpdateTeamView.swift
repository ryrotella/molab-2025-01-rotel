//
//  UpdateTeamView.swift
//  basketball-v1
//
//  Created by Ryan Rotella on 3/8/25.
//

import SwiftUI

struct UpdateTeamView: View {
    @State var team: ScoreTeam
    
    @State var uiImage:UIImage?
    
    @Environment(\.dismiss) var dismiss
  @Environment(Document.self) var document
    
    var body: some View {
        VStack {
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
            
            HStack {
                Button("Update") {
                    print("UpdateTeamView Update")
                    document.updateTeam(team: team)
                    dismiss()
                }
                Spacer()
                Button("Delete") {
                    document.deleteTeam(id: team.id)
                    dismiss();
                }
            }.padding(10)
            Form {
                TextField("team image url", text: $team.teamImageLink)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                TextField("city", text: $team.city)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                TextField("name", text: $team.name)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
//                TextField("systemName", text: $item.systemName)
//                    .textInputAutocapitalization(.never)
//                    .disableAutocorrection(true)
            }
        }
        .task {
            uiImage =  await imageFor(string: team.teamImageLink)
        }
    }
}

struct UpdateTeamView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateTeamView(team: ScoreTeam())
        .environment(Document())

    }
}
