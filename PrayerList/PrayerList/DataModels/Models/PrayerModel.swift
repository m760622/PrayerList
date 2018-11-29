//
//  PrayerModel.swift
//  PrayerList
//
//  Created by Devin  on 29/11/18.
//  Copyright © 2018 Devin Davies. All rights reserved.
//

import Foundation

class PrayerModel {
    
    var name: String!
    var uuid: String!
    var order: Int
    
    init(name: String, order: Int) {
        self.name = name
        self.order = order
        self.uuid = UUID().uuidString
    }
    
    init(coreDataPrayer: CoreDataPrayer) {
        self.name = coreDataPrayer.name
        self.uuid = coreDataPrayer.uuid
        self.order = Int(coreDataPrayer.order)
    }
}
