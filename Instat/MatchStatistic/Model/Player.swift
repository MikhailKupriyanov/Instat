//
//  Player.swift
//  Instat
//
//  Created by mpkupriyanov on 13.06.17.
//  Copyright © 2017 mpkupriyanov. All rights reserved.
//

import Foundation

struct Player {
    var playerID: Int?
    var name: String?
    var order: Int8?
    var stats = [PlayerStatValue]()
    
     init(_ dict:[String:AnyObject]?) {
        guard let dictionary = dict else { return }
        self.playerID = dictionary["playerId"] as? Int
        self.name = dictionary["playerName"] as? String
        self.order = dictionary["order"] as? Int8
    }
    
    
}
