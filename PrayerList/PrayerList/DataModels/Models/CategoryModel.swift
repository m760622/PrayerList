//
//  PrayerCategory.swift
//  PrayerList
//
//  Created by Devin  on 30/11/18.
//  Copyright © 2018 Devin Davies. All rights reserved.
//

import Foundation

class CategoryModel: NSObject {
    
    var name: String
    var uuid: String
    var order: Int
    
    var prayers = [PrayerModel]()
    var items = [ItemModel]()
    
    var setType: SetType = .consecutive
    var totalPerSet: Int = 3
    var showEmptyItems: Bool = false
    
    init(name: String, order: Int){
        self.name = name
        self.uuid = UUID().uuidString
        self.order = order
    }
    
    init(coreDataCategory: CoreDataCategory) {
        self.name = coreDataCategory.name
        self.uuid = coreDataCategory.uuid
        self.order = Int(coreDataCategory.order)
        self.totalPerSet = coreDataCategory.totalPerSet
        self.setType = SetType(rawValue: coreDataCategory.setType)!
        self.showEmptyItems = coreDataCategory.showEmptyItems
        
        if !coreDataCategory.groups.isEmpty {
            self.items = Array(coreDataCategory.groups.map({ItemModel(coreDataItem: $0)})).sorted(by: {$0.order < $1.order})
        }
        
        if !coreDataCategory.prayers.isEmpty {
            self.prayers = Array(coreDataCategory.prayers.map({PrayerModel(coreDataPrayer: $0)})).sorted(by: {$0.order < $1.order})
        }
    }
    
    
    
    func updatePrayerSelection(prayers: [PrayerModel]) {
        self.prayers = prayers
    }
    
}
