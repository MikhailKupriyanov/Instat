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
    var players = [Player]()
    
    var manager: PlayerManager?
    
    init(_ dict:[String:AnyObject]) {
        self.teamID = Int(dict["teamID"] as! String)
        self.name = dict["name"] as? String
    }
}

extension Team {
    
    // Статистика по команде
    func createTeamStatistic(_ statistics:Statistics) {
        _ = statistics.items.map({
            $0.teams.map({
                if $0.teamId == teamID {
                    stats.append($0)
                }
            })
        })
        addPlayers()
    }
    
    // Добавляем игрока и его статистику
    private func addPlayers() {
        guard let manager = manager else {
            return
        }
        for playerStat in (stats.first?.players)! {
            let playerStatItems = stats.flatMap { $0.players.filter { $0.playerId == playerStat.playerId! } } // Вся статистика по игроку
            
            var player = manager.playerById(playerStat.playerId!)
            player.statistics = playerStatItems
            self.players.append(player)
        }
    }
    
}
