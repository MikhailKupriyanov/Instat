//
//  StatisticViewController.swift
//  Instat
//
//  Created by mpkupriyanov on 19.06.17.
//  Copyright © 2017 mpkupriyanov. All rights reserved.
//

import UIKit

class StatisticViewController: UIViewController {
    
    @IBOutlet weak var teamSegmentControl: UISegmentedControl!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var playerGridView = NGridView()
    var teamGridView = NGridView()
    
    let dataManager = DataManager()
    let playerNameColumnWidth:CGFloat = 150.0 // Ширина колонки с именами игроков
    let teamGridHeight: CGFloat = 80.0 // Высота итоговой таблицы по команде
    let playerNameColumn = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Instat"
        self.teamSegmentControl.removeAllSegments()
        
        dataManager.fetch {
            DispatchQueue.main.async {
                self.title = self.dataManager.match?.title.uppercased()
                self.setupSegmentController()
                
                self.reloadGridViews()
                self.activityIndicator.stopAnimating()
            }
            
        }
        
        initialize()
    }
    
    
    private func reloadGridViews() {
        playerGridView.reloadData()
        teamGridView.reloadData()
    }
    
    @IBAction func selectTeam() {
        dataManager.selectTeam(teamSegmentControl.selectedSegmentIndex)
        reloadGridViews()
    }
    
    func setupSegmentController() {
        self.teamSegmentControl.insertSegment(withTitle: self.dataManager.match?.teamHome?.name, at: TeamIndex.homeTeam.rawValue, animated: false)
        self.teamSegmentControl.selectedSegmentIndex = TeamIndex.homeTeam.rawValue
        self.teamSegmentControl.insertSegment(withTitle: self.dataManager.match?.teamGuest?.name, at: TeamIndex.guestTeam.rawValue, animated: false)
    }
    
}

extension StatisticViewController: NGridDataSource, NGridDelegate {
    
    func initialize() {
        
        // Here the place to paste yout license key.
        let licenseKey = "GaxT1nt+11dpEXTY/Ve6dCwO6NR4lnCLfGdClOyPbIA/LfgaBM/bxAYcS4+/Vc8dphBemoaW6nkHHI7RLXe7XXAkJeddKA+ZUR8PTwy2GpQtAgphmACNdXLNc4WzWweWm81TXwjbj+0IeMbYI/ToA0gXDQFAmkjHCPfEAKtzbu0EZVGaEXNNFGZmE4mFaf5xAyc9HH0w9pdYLB3EUJj0uJgBnK+wPk7Cztjcm2uWknJTsTs5/I2YOIxK0YCpU2iumL3o6T8cJMuBSWHEKESs5D5cT5FGoCb3Dd3HDfFID1caKG02P9VyJ3nuxbKNPDEWR+Xr2GgqLElfOyhE8wpIT+ALlxV+Zr6AH65+PLrVmfUyrg+SIN5Wh0Fj1rFk6XdcTJsGAGHvRSx7Awz6A7O9XH78+nLXChILwqt4pk1Ei8k+V0R8eafElwKpepeKax3xsrwkXbOI/+5tCNxv6QcPuJ2Q96ps3mztqS1dttzlBixSVpkRN6rnZuUM9DfSyw2U6cgnA6i2ecJe+3jIGzgc+6UsWUPuhZTuc83q9IRwrrkkdsieH0t9jpm8mgBBYldPVwLl/VYiZTNLUIkU93SWR6awAyiljgnDmeYziCUQ0av2qtJVLkatbO/6UqAjkPHokAE4edU/EqbYXksfE3oYkndaOFoL8Xaru71x4gm11T8="
        
        playerGridView.licenseKey = licenseKey
        teamGridView.licenseKey = licenseKey
        
        playerGridView.tag = 0
        teamGridView.tag = 1
        
        playerGridView.bounces = false
        teamGridView.bounces = false
        
        playerGridView.dataSource = self
        playerGridView.delegate = self
        
        teamGridView.dataSource = self
        teamGridView.delegate = self
        
        setupAppearance(playerGridView)
        setupAppearance(teamGridView)
        
        
        let teamGridFrame = CGRect(x: 0, y: self.view.frame.size.height - teamGridHeight, width: self.view.frame.size.width, height: teamGridHeight)
        teamGridView.frame = teamGridFrame
        self.view.addSubview(teamGridView)
        
        let frame = teamSegmentControl.frame
        let y = frame.origin.y + frame.size.height + 8
        playerGridView.frame = CGRect(x: 0, y: y, width: self.view.frame.size.width, height: self.view.frame.size.height - y - teamGridHeight)
        self.view.addSubview(playerGridView)
    }
    
    func setupAppearance(_ gridView: NGridView) {
        let columnHeaderCellStyle = NGridCellStyle.empty()!
        columnHeaderCellStyle.backgroundColor = UIColor(red: 246.0/255.0, green: 246.0/255.0, blue: 246.0/255.0, alpha: 1.0)
        columnHeaderCellStyle.setBorderColor(UIColor(red: 195.0/255.0, green: 195.0/255.0, blue: 195.0/255.0, alpha: 1.0))
        columnHeaderCellStyle.textAlignment = NSTextAlignment.center;
        columnHeaderCellStyle.textColor = UIColor(red: 50.0/255.0, green: 50.0/255.0, blue: 55.0/255.0, alpha: 1.0)
        columnHeaderCellStyle.font = UIFont.boldSystemFont(ofSize: 14.0)
        columnHeaderCellStyle.leftPadding = 7.0
        columnHeaderCellStyle.rightPadding = 7.0
        
        let rowHeaderCellSyle = columnHeaderCellStyle.copy() as! NGridCellStyle
        rowHeaderCellSyle.leftPadding = 25.0
        rowHeaderCellSyle.textAlignment = NSTextAlignment.left
        
        let regularCellStyle = NGridCellStyle.default()!
        regularCellStyle.textAlignment = NSTextAlignment.right
        regularCellStyle.font = UIFont.systemFont(ofSize: 14.0)
        regularCellStyle.textColor = UIColor(red: 70.0/255.0, green: 70.0/255.0, blue: 75.0/255.0, alpha: 1.0)
        regularCellStyle.setBorderColor(UIColor(red: 195.0/255.0, green: 195.0/255.0, blue: 195.0/255.0, alpha: 1.0))
        regularCellStyle.rightBorderDash = [1, 1]
        regularCellStyle.bottomBorderDash = [1, 1]
        regularCellStyle.leftBorderWidth = 0
        regularCellStyle.rightBorderWidth = 1.0
        regularCellStyle.leftPadding = 7.0
        regularCellStyle.rightPadding = 7.0
        regularCellStyle.textAlignment = .center
        regularCellStyle.backgroundColorInterchange = true
        regularCellStyle.firstInterchangedColor = UIColor(red: 253.0/255.0, green: 253.0/255.0, blue: 253.0/255.0, alpha: 1.0)
        regularCellStyle.secondInterchangedColor = UIColor.white
        
        let styleManager = (gridView.proxyDataSource as! NGridProxyDataSourceImpl).styleManager()!
        let styleLevel = styleManager.styleLevel(NGridStyleLevelOrder.level0)!
        styleLevel.setDefaultStyleForColumnHeader(columnHeaderCellStyle)
        styleLevel.setDefaultStyleForRowHeader(rowHeaderCellSyle)
        styleLevel.setDefaultStyle(regularCellStyle)
    }
    
    // MARK: Data source stuff
    
    func gridView(_ gridView: NGridView!, cellWith cellKey: NGridCellKey!) -> NGridCell! {
        
        var cell = gridView.dequeueReusableCell(withIdentifier: "CellID") as! NGridCommonCell!
        if (cell == nil) {
            cell = NGridCommonCell(reuseIdentifier: "CellID")
        }
        
        let cellValue = self.gridView(gridView, valueForCellWith: cellKey)
        cell?.text = "\(cellValue!)"
        return cell
    }
    
    func gridView(_ gridView: NGridView!, valueForCellWith cellKey: NGridCellKey!) -> NSObject! {
        
        switch cellKey.type {
        case .columnHeader:
           
            if gridView.tag == 0 {
                let columnHeaderName = dataManager.columnHeaderName(by: cellKey.columnKey)
                
                return columnHeaderName as NSObject!
            } else {
                var columnTeamHeaderName: String?
                switch cellKey.rowKey {
                case TeamHeaderSection.averageSection.rawValue:
                    columnTeamHeaderName = dataManager.averageTeamStatisticHeader(by: cellKey.columnKey)
                case TeamHeaderSection.totalSection.rawValue:
                    columnTeamHeaderName = dataManager.totalTeamStatisticHeader(by: cellKey.columnKey)
                default:
                    break
                }
                
                return columnTeamHeaderName as NSObject!
            }
            
        case .regular:
            
            if cellKey.columnKey == 0 {
                if let playerName = dataManager.getPlayerName(byRow: cellKey.rowKey) {
                    return playerName as NSObject!
                }
            } else {
                if let playerStat = dataManager.getPlayerStatistic(byRow:cellKey.rowKey, byCol:cellKey.columnKey) {
                    if let value = playerStat.value {
                        return value as NSObject!
                    } else if let leftVal = playerStat.valueLeft, let rightVal = playerStat.valueRight {
                        return "\(leftVal) / \(rightVal)" as NSObject!
                    }
                    
                }
            }
        default:
            break
        }
        return String() as NSObject!
    }
    
    
    func gridViewRowCount(_ gridView: NGridView!) -> Int {
        if gridView.tag == 0 {
            return dataManager.numberOfPlayers()
        }
        return 0
    }
    
    func gridViewColumnCount(_ gridView: NGridView!) -> Int {
        return dataManager.numberOfParams() + playerNameColumn // Количество колонок в таблице игроков
    }
    
    func gridViewRowHeaderCount(_ gridView: NGridView!) -> Int {
        return 0
    }
    
    func gridViewColumnHeaderCount(_ gridView: NGridView!) -> Int {
        if gridView.tag == 0 {
            return 1
        }
        return 2
    }
    
    // MARK: Delegate stuff
    
    func gridView(_ gridView: NGridView!, didTap cell: NGridCell!) {
        if gridView.tag == 0 {
            // First, check type of cell. We need only header cells...
            if (cell.key.type == NGridCellType.columnHeader) {
                // ... when get sort settings
                let settings = cell.parentGrid.sortSettings() as! NGridSortSettings!
                // ... check is this row sorted
                if (settings != nil && settings?.elementType == NGridSortElementType.column &&
                    settings?.elementKey == cell.key.columnKey) {
                    // ... and change sort direction
                    if (settings?.direction == NGridSortDirection.asc) {
                        settings?.direction = NGridSortDirection.desc
                    } else if (settings?.direction == NGridSortDirection.desc) {
                        settings?.direction = NGridSortDirection.none
                    } else {
                        settings?.direction = NGridSortDirection.asc
                    }
                    cell.parentGrid.setSortSettings(settings)
                } else {
                    // ... and create new sort setting
                    let settings = NGridSortSettings()
                    settings.elementKey = cell.key.columnKey;
                    settings.elementType = NGridSortElementType.column;
                    settings.direction = NGridSortDirection.asc;
                    cell.parentGrid.setSortSettings(settings)
                }
            }
        }
    }
    
    func gridView(_ gridView: NGridView!, widthForColumnWithKey columnKey: Int) -> CGFloat {
        if columnKey == 0 {
            return playerNameColumnWidth
        }
        let columnParamWidth = (self.view.frame.width - playerNameColumnWidth) / CGFloat(dataManager.numberOfParams())
        return columnParamWidth
    }
    
    func gridView(_ gridView: NGridView!, heightForRowWithKey rowKey: Int) -> CGFloat {
        return 50.0
    }
    
    func gridView(_ gridView: NGridView!, widthForHeaderRowWithKey key: Int) -> CGFloat {
        return 200.0
    }
    
    func gridView(_ gridView: NGridView!, heightForHeaderColumnWithKey key: Int) -> CGFloat {
        if gridView.tag == 0 { return 75.0 }
        return teamGridHeight / 2.0
    }
    
}
