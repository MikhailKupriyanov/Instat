//
//  Player.swift
//  Instat
//
//  Created by mpkupriyanov on 13.06.17.
//  Copyright © 2017 mpkupriyanov. All rights reserved.
//

import Foundation

struct Player {
    var playerId: Int?
    var name: String?
    var order: Int8?
    var statistics = [PlayerStatValue]()
    
     init(_ dictionary:[String:AnyObject]) {
        self.playerId = dictionary["playerId"] as? Int
        
        if let name = dictionary["playerName"] as? String {
            // Убираем пробелы спереди имени, чтобы была верная сортировка по имени
            self.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        self.order = dictionary["order"] as? Int8
    }

}

