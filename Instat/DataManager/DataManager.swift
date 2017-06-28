//
//  DataManager.swift
//  Instat
//
//  Created by mpkupriyanov on 13.06.17.
//  Copyright © 2017 mpkupriyanov. All rights reserved.
//

import Foundation

class DataManager {
    
    var match: Match?
    private var statistics: Statistics?
    private var playerManager: PlayerManager?
    
    var selectedTeam: Team?
    var sortDirection = SortDirection.asc
    fileprivate var sortedColumnIndex = IndexPath() // Текущая колонка сортировки
    
    func fetch(completion:@escaping()-> Void) {
        let apiManager = APIManager()
        apiManager.requestData { (response) in
            // Создаем матч с командами
            self.match = Match(response)
            
            // Создаем статистику
            self.statistics = Statistics(response)
            
            // Создаем игроков
            self.playerManager = PlayerManager(response)
            
            // Для каждой команды добавляем статистику игроков
            if let statistics = self.statistics {
                self.match?.teamHome?.manager = self.playerManager
                self.match?.teamHome?.createTeamStatistic(statistics)
                self.match?.teamGuest?.manager = self.playerManager
                self.match?.teamGuest?.createTeamStatistic(statistics)
            }
            
            self.selectedTeam = self.match?.teamHome
            completion()
        }
    }
    
    func selectTeam(_ index:Int) {
        switch index {
        case TeamIndex.homeTeam.rawValue:
            selectedTeam = match?.teamHome
        case TeamIndex.guestTeam.rawValue:
            selectedTeam = match?.teamGuest
        default:
            break
        }
        if !sortedColumnIndex.isEmpty {
            sortItems(by: sortedColumnIndex)
        }
       
    }
    
    // Наименование заголовков статистики
    func columnHeaderName(by index:IndexPath) -> String? {
        if index.item == 0 {
            return "Player"
        }
        return statistics?.items[index.item - 1].name
    }
    
    // Статистика по команде, Итого
    func totalTeamStatistic(by index:IndexPath) -> String? {
        if index.item == 0 {
            return "Total"
        }
        return selectedTeam?.stats[index.item - 1].totalValue
    }
    
    // Статистика по команде, Среднее
    func averageTeamStatistic(by index:IndexPath) -> String? {
        if index.item == 0 {
            return "Average"
        }
        return selectedTeam?.stats[index.item - 1].avgValue
    }
    
    // Количество параметров статистики
    func numberOfParams() -> Int {
        guard let count = statistics?.items.count else {
            return 0
        }
        return count
    }
    
    // Количество игроков в команде
    func numberOfPlayers() -> Int {
        guard let count = selectedTeam?.players.count else {
            return 0
        }
        return count
    }
    
    // Имя игрока
    func player(at index:IndexPath) -> Player? {
        return selectedTeam?.players[index.section]
    }
    
    // Получаем параметр статистики по игроку
    func playerStatistic(at index:IndexPath) -> PlayerStatValue? {
        return selectedTeam?.players[index.section].statistics[index.item - 1]
    }
    
}

extension DataManager {
    
    func sortStatistics(byColumnIndex index:IndexPath) {
        sortedColumnIndex = index
        
        switch sortDirection {
        case .asc:
            sortDirection = .desc
            
        case .desc:
            sortDirection = .asc
            
        default: break
        }
        
        sortItems(by: index)
    }
    
    fileprivate func sortItems(by index:IndexPath) {
        
        // Сортируем по имени игрока
        if index.item == 0 {
            switch sortDirection {
            case .asc:
                selectedTeam?.players.sort(by: { $0.name! < $1.name! })
                
            case .desc:
                selectedTeam?.players.sort(by: { $0.name! > $1.name! })
                
            default: break
            }
            return
        }
        
        // Сортируем по параметру статистики
        selectedTeam?.players.sort(by: { (player1, player2) -> Bool in
            if let value1 = player1.statistics[index.item - 1].value, let value2 = player2.statistics[index.item - 1].value {
                switch sortDirection {
                case .asc:
                    if value1 < value2 { return true }
                    
                case .desc:
                    if value1 > value2 { return true }
                    
                default: break
                }
                
            } else if let valueLeft1 = player1.statistics[index.item - 1].valueLeft, let valueLeft2 = player2.statistics[index.item - 1].valueLeft, let valueRight1 = player1.statistics[index.item - 1].valueRight, let valueRight2 = player2.statistics[index.item - 1].valueRight {
                switch sortDirection {
                case .asc:
                    if valueLeft1 <= valueLeft2 && valueRight1 <= valueRight2 { return true }
                    
                case .desc:
                    if valueLeft1 >= valueLeft2 && valueRight1 >= valueRight2 { return true }
                    
                default: break
                }
            }
            return false
        })
    }
}
