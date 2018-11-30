//
//  PrayerCategory.swift
//  PrayerList
//
//  Created by Devin  on 30/11/18.
//  Copyright © 2018 Devin Davies. All rights reserved.
//

import Foundation

class PrayerCategoryModel {
    
    var name: String
    var uuid: String
    var order: Int
    
    var groups = [PrayerGroupModel]()
    
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
            self.groups = Array(coreDataCategory.groups.map({PrayerGroupModel(coreDataGroup: $0)}))
        }
    }
    
}
