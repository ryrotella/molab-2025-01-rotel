//
//  scoreTeam.swift
//  basketball-v1
//
//  Created by Ryan Rotella on 2/28/25.
//

import SwiftUI
import Foundation

//model
//Hashable
struct ScoreTeam: Identifiable, Codable {
    
    var id = UUID()
    var teamImageLink: String = ""
    //var teamImage: UIImage = UIImage()
    var city: String = ""
    var name: String = ""
//    var score: Int = 0
    
//    mutating func changeCover(_ image : UIImage) {
//        teamImage = image
//    }
}


var nets: ScoreTeam = ScoreTeam(teamImageLink: "https://cdn.freebiesupply.com/logos/large/2x/new-jersey-nets-logo-png-transparent.png",
                                //teamImage: UIImage(named: "nets") ?? UIImage(),
                                city: "Brooklyn",
                                name: "Nets"
                                )

var grizz: ScoreTeam = ScoreTeam( teamImageLink: "https://i.imgur.com/9W2Rhgm.png",
                                  //teamImage: UIImage(named: "grizzlies") ?? UIImage(),
                                 city: "Memphis",
                                name: "Grizzlies"
                                )


//class GameTeams: ObservableObject {
//    @Published var teams: [ScoreTeam] = [nets, grizz]
//    
//}
