//
//  OrderType.swift
//  PrayerList
//
//  Created by Devin  on 4/02/19.
//  Copyright © 2019 Devin Davies. All rights reserved.
//

import Foundation

enum SetType: String, CaseIterable {
    case consecutive = "CONSECUTIVE"
    case random = "RANDOM"
    
    var title: String {
        switch self {
        case .consecutive:
            return "Consecutive"
        case .random:
            return "Random"
        }
    }
}
