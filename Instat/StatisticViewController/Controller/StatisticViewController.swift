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
    @IBOutlet weak var headerCollectionView:UICollectionView!
    @IBOutlet weak var playerCollectionView:UICollectionView!
    @IBOutlet weak var footerCollectionView:UICollectionView!
    
    let dataManager = DataManager()
    
    let numberOfHeaderSection = 1 // Количество секций в хедере
    let numberOfFooterSection = 2 // Количество секций в футере
    let nameColumnWidth:CGFloat = 170.0 // Ширина колонки с именами игроков
    let nameColumn = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Instat"
        self.teamSegmentControl.removeAllSegments()
        initialize()
        
        dataManager.fetch {
            DispatchQueue.main.async {
                self.title = self.dataManager.match?.title.uppercased()
                self.setupSegmentController()
                self.reloadCollectionViews()
                self.headerCollectionView.reloadData()
                self.headerCollectionView.isHidden = false
                self.footerCollectionView.isHidden = false
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    func initialize() {
        headerCollectionView.isHidden = true
        footerCollectionView.isHidden = true
        setupCollectionView()
    }
    
     func reloadCollectionViews() {
        playerCollectionView.reloadData()
        footerCollectionView.reloadData()
    }
    
    @IBAction func selectTeam() {
        dataManager.selectTeam(teamSegmentControl.selectedSegmentIndex)
        reloadCollectionViews()
    }
    
    func setupSegmentController() {
        self.teamSegmentControl.insertSegment(withTitle: self.dataManager.match?.teamHome?.name, at: TeamIndex.homeTeam.rawValue, animated: false)
        self.teamSegmentControl.selectedSegmentIndex = TeamIndex.homeTeam.rawValue
        self.teamSegmentControl.insertSegment(withTitle: self.dataManager.match?.teamGuest?.name, at: TeamIndex.guestTeam.rawValue, animated: false)
    }
    
}


extension StatisticViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    enum CollectionTag: Int {
        case headerTag = 100
        case playerTag
        case footerTag
    }
    
    enum Column: Int {
        case header
        case normal
    }
    
    enum TeamSection: Int {
        case average, total
    }
    
    func setupCollectionView() {
        headerCollectionView.tag = CollectionTag.headerTag.rawValue
        playerCollectionView.tag = CollectionTag.playerTag.rawValue
        footerCollectionView.tag = CollectionTag.footerTag.rawValue
        
        let headerFlow = UICollectionViewFlowLayout()
        headerFlow.sectionInset = UIEdgeInsets.zero
        headerFlow.minimumInteritemSpacing = 0
        headerFlow.minimumLineSpacing = 0
        headerCollectionView.collectionViewLayout = headerFlow
        
        let flow = UICollectionViewFlowLayout()
        flow.sectionInset = UIEdgeInsets.zero
        flow.minimumInteritemSpacing = 0
        flow.minimumLineSpacing = 0
        playerCollectionView.collectionViewLayout = flow
        
        let footerFlow = UICollectionViewFlowLayout()
        footerFlow.sectionInset = UIEdgeInsets.zero
        footerFlow.minimumInteritemSpacing = 0
        footerFlow.minimumLineSpacing = 0
        footerCollectionView.collectionViewLayout = footerFlow
        
        headerCollectionView.dataSource = self
        headerCollectionView.delegate = self
        
        playerCollectionView.dataSource = self
        playerCollectionView.delegate = self
        
        footerCollectionView.dataSource = self
        footerCollectionView.delegate = self
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        var numberOfSection = 0
        switch collectionView.tag {
        case CollectionTag.headerTag.rawValue:
            numberOfSection = numberOfHeaderSection
            
        case CollectionTag.playerTag.rawValue:
            numberOfSection = dataManager.numberOfPlayers()
            
        case CollectionTag.footerTag.rawValue:
            numberOfSection = numberOfFooterSection
        default: break
        }
        return numberOfSection
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  dataManager.numberOfParams() + nameColumn // Количество колонок в таблице
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        switch collectionView.tag {
        case CollectionTag.headerTag.rawValue:
            cell = setupHeaderCell(at: indexPath)
            
        case CollectionTag.playerTag.rawValue:
            cell = setupPlayerCell(at: indexPath)
            
        case CollectionTag.footerTag.rawValue:
            cell = setupFooterCell(at: indexPath)
            
        default:  break
        }
        
        cell.contentView.layer.borderWidth = 0.5
        cell.contentView.layer.borderColor = UIColor.gray.cgColor
        return cell
    }
    
    // UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
                
        let height = heightCell(tag: collectionView.tag)
        switch indexPath.item {
        case Column.header.rawValue:
            return CGSize(width: nameColumnWidth, height: height)
            
        default:
            let screenRect = collectionView.frame.size.width
            let screenWidth = screenRect - nameColumnWidth
            let cellWidth = screenWidth / CGFloat(dataManager.numberOfParams())
            return CGSize(width: cellWidth, height: height)
        }
    }
    
    // UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView.tag {
            
        case CollectionTag.headerTag.rawValue:
            dataManager.sortStatistics(byColumnIndex: indexPath)
            let cell = collectionView.cellForItem(at: indexPath) as! HeaderCell
            cell.showSortDirection(dataManager.sortDirection)
            playerCollectionView.reloadData()
            
            
        default: break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        switch collectionView.tag {
        case CollectionTag.headerTag.rawValue:
            let cell = collectionView.cellForItem(at: indexPath) as! HeaderCell
            cell.showSortDirection(.none)
            playerCollectionView.reloadData()
        default: break
        }
    }
    
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        headerCollectionView.reloadData()
        playerCollectionView.reloadData()
        footerCollectionView.reloadData()
    }
    
    
    func heightCell(tag:Int) -> CGFloat {
        return tag == CollectionTag.headerTag.rawValue ? 70.0 : 50.0
    }
    
    // Устанавливаем заголовок таблицы
    func setupHeaderCell(at index:IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell
        let headerCell = headerCollectionView.dequeueReusableCell(withReuseIdentifier: "headerCell", for: index) as! HeaderCell
        if let columnHeaderName = dataManager.columnHeaderName(by: index) {
            headerCell.lblTitle.text = columnHeaderName
        }
        cell = headerCell
        return cell
    }
    
    // Устанавливаем имя и статистику игроков
    func setupPlayerCell(at index:IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell
        
        switch index.item {
        case Column.header.rawValue:
            let playerCell = playerCollectionView.dequeueReusableCell(withReuseIdentifier: "playerCell", for: index) as! PlayerCell
            if let player = dataManager.player(at: index) {
                if let name = player.name {
                    playerCell.lblName.text = name
                }
                if let order = player.order {
                    playerCell.lblOrder.text = String(order)
                }
            }
            cell = playerCell
            
        default:
            let statCell = playerCollectionView.dequeueReusableCell(withReuseIdentifier: "statisticCell", for: index) as! StatisticCell
            if let playerStat = dataManager.playerStatistic(at: index) {
                if let value = playerStat.value {
                    statCell.lblValue.text = String(value as Double)
                } else if let leftVal = playerStat.valueLeft, let rightVal = playerStat.valueRight {
                    statCell.lblValue.text = "\(leftVal) / \(rightVal)"
                }
            }
            cell = statCell
        }
        
        return cell
    }
    
    // Устанавливаем статистику по команде в футер
    func setupFooterCell(at index:IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell
        let footerCell = footerCollectionView.dequeueReusableCell(withReuseIdentifier: "footerCell", for: index) as! FooterCell
        
        switch index.section {
        case TeamSection.average.rawValue:
            if let footerName = dataManager.averageTeamStatistic(by: index)  {
                footerCell.lblTitle.text = footerName
            }
            
        case TeamSection.total.rawValue:
            if let footerName = dataManager.totalTeamStatistic(by: index) {
                footerCell.lblTitle.text = footerName
            }
            
        default: break
        }
        
        cell = footerCell
        return cell
    }
    
}
