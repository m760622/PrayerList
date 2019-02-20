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
    
    var remindOnDays = [DayAlert]()
    var shouldRemind: Bool = false
    var remindTime: TimeAlert = TimeAlert.atTime
    var notificationIdentifiers = [String]()
    
    var lastCompleted: Date?
    var time: Date?
    
    var categoryIds = [String]()
    
    init(name: String, order: Int) {
        self.name = name
        self.order = order
        self.uuid = UUID().uuidString
    }
    
    init(coreDataPrayer: CoreDataPrayer) {
        self.name = coreDataPrayer.name
        self.uuid = coreDataPrayer.uuid
        self.order = Int(coreDataPrayer.order)
        self.lastCompleted = coreDataPrayer.lastCompleted as Date?
        self.time = coreDataPrayer.time as Date?
        self.shouldRemind = coreDataPrayer.shouldRemind
        
        self.remindOnDays = coreDataPrayer.remindOnDays.map({DayAlert(rawValue: $0)!})
        self.notificationIdentifiers = coreDataPrayer.notificationIdentifiers.components(separatedBy: ",")
        
        self.remindTime = TimeAlert(rawValue: coreDataPrayer.remindTime)!
        
        if !coreDataPrayer.categories.isEmpty {
            let categoriesArray = Array(coreDataPrayer.categories).sorted { (a, b) -> Bool in
                return a.order < b.order
            }
            self.categoryIds = categoriesArray.map({$0.uuid})
        }
    }
}
