//
//  PlayerStat.swift
//  Instat
//
//  Created by mpkupriyanov on 18.06.17.
//  Copyright © 2017 mpkupriyanov. All rights reserved.
//

import Foundation

// Статистика по всем параметрам
struct Statistics {
    var items = [ParameterStat]()
}

extension Statistics {
    
    init(_ dict:[String: AnyObject]) {
        if let stats = dict["stats"] {
            for stat in stats as! NSArray  {
                self.items.append(ParameterStat(stat as! [String : AnyObject]))
            }
        }
    }

}

// Статистика параметра
struct ParameterStat {
    var name: String?
    var teams = [TeamStat]()
    
    init(_ dict:[String: AnyObject]) {
        self.name = dict["paramName"] as? String
        if let teamsStat = dict["teams"] {
            for team in teamsStat as! NSArray  {
                self.teams.append(TeamStat(team as! [String : AnyObject]))
            }
        }
    }
}

// Статистика команды
struct TeamStat {
    var teamId: Int?
    private var totalVal: Double?
    private var avgVal: Double?
    
    private var totalLeftValue: Double?
    private var totalRightValue: Double?
    
    private var avgLeftValue: Double?
    private var avgRightValue: Double?
    
    var totalValue: String? {
        get {
            if let total = totalVal {
                return String(total.string2Digits)
            }
            
            guard let totalLeft = totalLeftValue, let totalRight = totalRightValue else {
                return nil
            }
            return String(totalLeft.string2Digits) + " / " + String(totalRight.string2Digits)
        }
    }
    
    var avgValue: String? {
        get {
            if let avg = avgVal {
                return String(avg.string2Digits)
            }
            
            guard let avgLeft = avgLeftValue, let avgRight = avgRightValue else {
                return nil
            }
            return String(avgLeft.string2Digits) + " / " + String(avgRight.string2Digits)
        }
    }
    
    
    var players = [PlayerStatValue]()
    
    init(_ dict:[String: AnyObject]) {
        self.teamId = dict["teamId"] as? Int
        
        self.totalVal = determineTypeValue(dict["totalVal"] as AnyObject)
        self.avgVal = dict["avgVal"] as? Double
        
        self.totalLeftValue = determineTypeValue(dict["totalLeftVal"] as AnyObject)
        
        self.totalRightValue = determineTypeValue(dict["totalRightVal"] as AnyObject)
        
        self.avgLeftValue = dict["avgLeftVal"] as? Double
        self.avgRightValue = dict["avgRightVal"] as? Double
        
        if let playersStat = dict["players"] {
            for player in playersStat as! NSArray  {
                self.players.append(PlayerStatValue(player as! [String : AnyObject]))
            }
        }
    }
    
    private  func determineTypeValue(_ value: AnyObject) -> Double? {
        var determinedValue: Double?
        if let stringValue = value as? String {
            determinedValue = Double(stringValue)
        } else if let doubleValue = value as? Double {
            determinedValue = doubleValue
        }
        return determinedValue
    }
}

// Статистика игрока
struct PlayerStatValue {
    var playerId: Int?
    var value: Double?
    var valueLeft: Double?
    var valueRight: Double?
    
    init(_ dict:[String: AnyObject]) {
        self.playerId = dict["playerId"] as? Int
        self.value = dict["value"] as? Double
        self.valueLeft = dict["valueLeft"] as? Double
        self.valueRight = dict["valueRight"] as? Double
    }
}
