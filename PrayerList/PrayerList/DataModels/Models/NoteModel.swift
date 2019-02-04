//
//  PrayerItem.swift
//  PrayerList
//
//  Created by Devin  on 30/11/18.
//  Copyright © 2018 Devin Davies. All rights reserved.
//

import Foundation

class NoteModel {
    
    var name: String
    var uuid: String
    var dateCreated: Date
    
    init(name: String){
        self.name = name
        self.uuid = UUID().uuidString
        self.dateCreated = Date()
    }
    
    init(coreDataPrayerItem: CoreDataNote){
        self.name = coreDataPrayerItem.name
        self.uuid = coreDataPrayerItem.uuid
        self.dateCreated = coreDataPrayerItem.dateCreated as Date
    }
}
