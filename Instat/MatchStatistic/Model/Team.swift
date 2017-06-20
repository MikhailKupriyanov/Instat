//
//  Team.swift
//  Instat
//
//  Created by mpkupriyanov on 13.06.17.
//  Copyright © 2017 mpkupriyanov. All rights reserved.
//

import Foundation

class Team {
    var teamID: Int?
    var name: String?
    var stats = [TeamStat]()
    
    
    init(_ dict:[String:AnyObject]) {
        self.teamID = Int(dict["teamID"] as! String)
        self.name = dict["name"] as? String
    }
}

extension Team {
   
    func createTeamStatistic(_ statistics:Statistics) {
        for item in statistics.items {
            for teamItem in item.teams {
                if teamItem.teamId == teamID {
                    stats.append(teamItem)
                }
            }
        }
    }
    
}
