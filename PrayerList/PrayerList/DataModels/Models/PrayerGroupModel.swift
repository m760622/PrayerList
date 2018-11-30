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
    
    var currentItems = [PrayerItemModel]()
    
    init(name: String){
        self.name = name
        self.uuid = UUID().uuidString
    }
    
    init(coreDataGroup: CoreDataPrayerGroup){
        self.name = coreDataGroup.name
        self.uuid = coreDataGroup.uuid
        
        if !coreDataGroup.items.isEmpty {
            self.currentItems = Array(coreDataGroup.items.map({PrayerItemModel(coreDataPrayerItem: $0)}))
        }
    }
}
