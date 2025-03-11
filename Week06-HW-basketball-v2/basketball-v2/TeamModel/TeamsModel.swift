//
//  TeamsModel.swift
//  basketball-v1
//
//  Created by Ryan Rotella on 3/7/25.
//

import SwiftUI

struct TeamsModel: Codable {
    var teams: [ScoreTeam]
    
    init () {
        teams = []
    }
    
    mutating func addTeam(team: ScoreTeam){
        teams.append(team)
    }
    
    mutating func updateTeam(team: ScoreTeam){
        if let index = findIndex(team.id){
            teams[index] = team
        }
    }
    
    mutating func deleteTeam(id: UUID){
        if let index = findIndex(id){
            teams.remove(at: index)
        }
    }
    
    func findIndex(_ id: UUID) -> Int? {
        teams.firstIndex { team in team.id == id}
    }
}
