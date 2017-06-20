//
//  PlayerManager.swift
//  Instat
//
//  Created by mpkupriyanov on 17.06.17.
//  Copyright © 2017 mpkupriyanov. All rights reserved.
//

import Foundation

class PlayerManager {
    
    private var items = [Player]()
    
    init(_ dict:[String: AnyObject]) {
        if let allPlayers = dict["allPlayers"] {
            for player in allPlayers as! NSArray  {
                 items.append(Player(player as? [String: AnyObject]))
            }
        }
    }
    
    func playerById(_ playerId:Int) -> Player? {
        return items.filter({ $0.playerID == playerId }).first
    }
    
}
