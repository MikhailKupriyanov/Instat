//
//  PlayerCell.swift
//  Instat
//
//  Created by mpkupriyanov on 27.06.17.
//  Copyright © 2017 mpkupriyanov. All rights reserved.
//

import UIKit

class PlayerCell: UICollectionViewCell {
        @IBOutlet weak var lblOrder: UILabel!
        @IBOutlet weak var lblName: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblOrder.layer.cornerRadius = lblOrder.frame.size.width / 2.0
    }
}
