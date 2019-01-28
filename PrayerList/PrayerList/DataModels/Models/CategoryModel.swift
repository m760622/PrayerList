//
//  PrayerCategory.swift
//  PrayerList
//
//  Created by Devin  on 30/11/18.
//  Copyright © 2018 Devin Davies. All rights reserved.
//

import Foundation

class CategoryModel {
    
    var name: String
    var uuid: String
    var order: Int
    
    var prayers = [PrayerModel]()
    var items = [ItemModel]()
    
    init(name: String, order: Int){
        self.name = name
        self.uuid = UUID().uuidString
        self.order = order
    }
    
    init(coreDataCategory: CoreDataPrayerCategory) {
        self.name = coreDataCategory.name
        self.uuid = coreDataCategory.uuid
        self.order = Int(coreDataCategory.order)
        
        if !coreDataCategory.groups.isEmpty {
            self.items = Array(coreDataCategory.groups.map({ItemModel(coreDataGroup: $0)})).sorted(by: {$0.order < $1.order})
        }
        
        if !coreDataCategory.prayers.isEmpty {
            self.prayers = Array(coreDataCategory.prayers.map({PrayerModel(coreDataPrayer: $0)})).sorted(by: {$0.order < $1.order})
        }
    }
    
    func retrieveItemsForPrayer(prayer: PrayerModel) -> [ItemModel] {
        return items.filter({$0.prayerIds.contains(prayer.uuid)})
    }
    
}
