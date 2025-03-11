//
//  Document.swift
//  basketball-v1
//
//  Created by Ryan Rotella on 3/7/25.
//

import Foundation

@Observable
class Document {
    var model: TeamsModel
    //@Published var teams: [ScoreTeam]
    
    //file name to store JSON for model items
    let saveFileName = "teams.json"
    
    //true to initialize model items with sample items
    let initSampleItems = true
    
    init() {
        print("Teams model init")
        
        model = TeamsModel(JSONfileName: saveFileName)
        
        if initSampleItems && model.teams.isEmpty {
            //items for testing
            model.teams = []
            addTeam(team: nets)
            addTeam(team: grizz)
            
        }
        
    }
    
    //teamImageLink, city, name
    
    func addTeam(teamImageLink: String, city: String, name: String){
        let team = ScoreTeam(id: UUID(), teamImageLink: teamImageLink, city: city, name: name)
        model.addTeam(team: team)
    }
    
    func addTeam(team: ScoreTeam){
        model.addTeam(team: team)
        saveModel()
    }
    
    func updateTeam(team: ScoreTeam){
        model.updateTeam(team: team)
        saveModel()

    }
    
    func deleteTeam(id: UUID){
        model.deleteTeam(id: id)
        saveModel()
    }
    
    func saveModel() {
        print("Document saveModel")
        model.saveAsJSON(fileName: saveFileName)
    }
    
}

//array of image url strings for teams

let logoArray: [String] = [
    
]
