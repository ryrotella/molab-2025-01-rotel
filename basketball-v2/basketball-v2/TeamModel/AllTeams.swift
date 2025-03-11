//
//  AllTeams.swift
//  basketball-v1
//
//  Created by Ryan Rotella on 3/7/25.
//

import SwiftUI

struct AllTeams: View {
    @Environment(Document.self) var document
    
    var body: some View {
        NavigationView {
            List {
                // Display in reverse order to see new additions first
                ForEach(document.model.teams.reversed()) { team in
                    NavigationLink( destination:
                        UpdateTeamView(team: team)
                    )
                    {
                        TeamRow(team: team)
                       
                    }
                }
            }
            .navigationTitle("Teams")
            .navigationBarItems(
                trailing:
                    NavigationLink( destination:
                        AddTeamView(team: ScoreTeam())
                    )
                {
                    Text("Add a Team")
                }
            )
        }
    }
}

#Preview {
    AllTeams()
        .environment(Document())
}
