//
//  scoreTeam.swift
//  basketball-v1
//
//  Created by Ryan Rotella on 2/28/25.
//

import SwiftUI

struct ScoreTeam: Hashable {
    
    
    var teamImage: UIImage = UIImage()
    //var teamImageLink: String
    var city: String
    var name: String
//    var score: Int = 0
    
    mutating func changeCover(_ image : UIImage) {
        teamImage = image
    }
}


var nets: ScoreTeam = ScoreTeam(teamImage: UIImage(named: "nets") ?? UIImage(),
                                city: "Brooklyn",
                                name: "Nets"
                                )

var grizz: ScoreTeam = ScoreTeam(teamImage: UIImage(named: "grizzlies") ?? UIImage(),
                                 city: "Memphis",
                                name: "Grizzlies"
                                )


class GameTeams: ObservableObject {
    @Published var teams: [ScoreTeam] = [nets, grizz]
    
}
