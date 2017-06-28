//
//  Common.swift
//  Instat
//
//  Created by mpkupriyanov on 21.06.17.
//  Copyright © 2017 mpkupriyanov. All rights reserved.
//

import Foundation

extension Double {
    var string1Digit: String {
        return String(format: "%.1f", self)
    }
    var string2Digits: String {
        return String(format: "%.2f", self)
    }
}

enum TeamIndex: Int {
    case homeTeam
    case guestTeam
}

enum SortDirection: Int {
    case none, asc, desc
}
