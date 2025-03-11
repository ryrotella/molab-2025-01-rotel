//
//  TeamsJSON.swift
//  basketball-v1
//
//  Created by Ryan Rotella on 3/7/25.
//

import SwiftUI

extension TeamsModel {
    
    func saveAsJSON(fileName: String){
        do{
            try saveJSON(fileName: fileName, val: self)
        }
        catch {
            fatalError("Model saveAsJson error \(error)")
        }
    }
    
    init(JSONfileName fileName: String){
        teams = []
        do {
            self = try loadJSON(TeamsModel.self, fileName: fileName)
        } catch {
            print("Model init JSONfileName error \(error)")
        }
    }
}
