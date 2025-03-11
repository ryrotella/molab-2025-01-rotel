//
//  ContentView.swift
//  basketball-v1
//
//  Created by Ryan Rotella on 2/28/25.
//

import SwiftUI

struct ContentView: View {
    @Environment(Document.self) var document
    var body: some View {
        NavigationView {
            List{
                NavigationLink{
                    Scoreboard()
                } label: {
                    Text("Scoreboard")
                }
                NavigationLink{
                    AllTeams()
                } label: {
                   Text("List of all teams")
                }
                
                NavigationLink{
                    Spin()
                } label: {
                    Text("Spin")
                }
//                NavigationLink{
//                    Dribble()
//                } label: {
//                    Text("Dribble")
//                }
            }
        }
        .navigationTitle("Basketball Actions")
    }
}

#Preview {
    ContentView()
        .environment(Document())
}
