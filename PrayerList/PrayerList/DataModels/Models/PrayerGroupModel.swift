//
//  PrayerGroup.swift
//  PrayerList
//
//  Created by Devin  on 30/11/18.
//  Copyright © 2018 Devin Davies. All rights reserved.
//

import Foundation

class PrayerGroupModel {
    
    var name: String
    var uuid: String
    var order: Int
    
    var currentItems = [PrayerItemModel]()
    
    init(name: String, order: Int){
        self.name = name
        self.uuid = UUID().uuidString
        self.order = order
    }
    
    init(coreDataGroup: CoreDataPrayerGroup){
        self.name = coreDataGroup.name
        self.uuid = coreDataGroup.uuid
        self.order = Int(coreDataGroup.order)
        
        if !coreDataGroup.items.isEmpty {
            self.currentItems = Array(coreDataGroup.items.map({PrayerItemModel(coreDataPrayerItem: $0)}))
        }
    }
}
