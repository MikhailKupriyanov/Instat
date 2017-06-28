//
//  HeaderCell.swift
//  Instat
//
//  Created by mpkupriyanov on 27.06.17.
//  Copyright © 2017 mpkupriyanov. All rights reserved.
//

import UIKit

class HeaderCell: UICollectionViewCell {
    @IBOutlet weak var imgSortDirection: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    func showSortDirection(_ sortDirection:SortDirection) {
        switch sortDirection {
        case .asc:
            imgSortDirection.image = UIImage(named: "ascending")
        case .desc:
            imgSortDirection.image = UIImage(named: "descending")
        default:
            imgSortDirection.image = UIImage(named: "none")
        }
    }
    
}
