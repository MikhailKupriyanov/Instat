//
//  Match.swift
//  Instat
//
//  Created by mpkupriyanov on 13.06.17.
//  Copyright © 2017 mpkupriyanov. All rights reserved.
//
//

import Foundation

class Match {
    var matchID: String?
    var teamHome: Team?
    var teamGuest: Team?
    var teamHomeScore: String?
    var teamGuestScore: String?
    
    var title: String {
        get {
            guard let teamHomeName = self.teamHome?.name, let teamGuestName = self.teamGuest?.name, let homeScore = self.teamHomeScore, let guestScore = self.teamGuestScore else { return "" }
         
            return teamHomeName + "  " + homeScore + " - " + guestScore + "  " + teamGuestName
        }
    }

    init(_ dict:[String:AnyObject]?) {
        guard let dictionary = dict else { return }
        self.matchID = dictionary["match_id"] as? String
        self.teamHomeScore = dictionary["team1_score"] as? String
        self.teamGuestScore = dictionary["team2_score"] as? String
        
        createTeamHome(dictionary)
        createTeamGuest(dictionary)
        
    }
}

extension Match {
    
    // Создаем команду хозяев
    func createTeamHome(_ dict:[String:AnyObject]) {
        var homeTeamDictionary:[String:AnyObject] = [:]
        homeTeamDictionary["teamID"] = dict["team1_id"]
        homeTeamDictionary["name"] = dict["team1_name_eng"]
        self.teamHome = Team(homeTeamDictionary)
    }
    
    // Создаем команду гостей
    func createTeamGuest(_ dict:[String:AnyObject]) {
        var homeTeamDictionary:[String:AnyObject] = [:]
        homeTeamDictionary["teamID"] = dict["team2_id"]
        homeTeamDictionary["name"] = dict["team2_name_eng"]
        self.teamGuest = Team(homeTeamDictionary)
    }
    
}
