//
//  DataManager.swift
//  Instat
//
//  Created by mpkupriyanov on 13.06.17.
//  Copyright © 2017 mpkupriyanov. All rights reserved.
//

import Foundation

class DataManager {
    
    private var items:[Player] = []
    
    var match: Match?
    var statistics: Statistics?
    var playerManager: PlayerManager?
    
    var selectedTeam: Team?
    
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
                self.match?.teamHome?.createTeamStatistic(statistics)
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
    }
    
    // Наименование заголовков статистики
    func columnHeaderName(by index:Int) -> String? {
        if index == 0 {
            return "Player"
        }
        
        return statistics?.items[index - 1].name
    }
    
    // Статистика по команде, Итого
    func totalTeamStatisticHeader(by index:Int) -> String? {
        if index == 0 {
            return "Total"
        }
        return selectedTeam?.stats[index - 1].totalValue
    }
    
    // Статистика по команде, Среднее
    func averageTeamStatisticHeader(by index:Int) -> String? {
        if index == 0 {
            return "Average"
        }
        return selectedTeam?.stats[index - 1].avgValue
    }
    
    // Количество параметров
    func numberOfParams() -> Int {
        guard let count = statistics?.items.count else {
            return 0
        }
        return count
    }
    
    // Количество игроков в команде
    func numberOfPlayers() -> Int {
        guard let count = selectedTeam?.stats[0].players.count else {
            return 0
        }
        return count
    }
    
    // Имя игрока
    func getPlayerName(byRow row:Int) -> String? {
        var playerName: String?
        if let teamStat = selectedTeam?.stats[0].players[row] {
            playerName = playerManager?.playerById(teamStat.playerId!)?.name
        }
        return playerName
    }
    
    // Получаем параметр статистики по игроку
    func getPlayerStatistic(byRow row: Int, byCol col:Int) -> PlayerStatValue? {
        return selectedTeam?.stats[col - 1].players[row]
    }
    
}
