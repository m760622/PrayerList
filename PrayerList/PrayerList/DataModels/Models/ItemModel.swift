//
//  PrayerGroup.swift
//  PrayerList
//
//  Created by Devin  on 30/11/18.
//  Copyright © 2018 Devin Davies. All rights reserved.
//

import Foundation

class ItemModel {
    
    var name: String
    var uuid: String
    var order: Int
    
    var prayerIds = [String]()
    
    var currentNotes = [NoteModel]()
    
    init(name: String, order: Int){
        self.name = name
        self.uuid = UUID().uuidString
        self.order = order
    }
    
    init(coreDataGroup: CoreDataItem){
        self.name = coreDataGroup.name
        self.uuid = coreDataGroup.uuid
        self.order = Int(coreDataGroup.order)
        
        if !coreDataGroup.items.isEmpty {
            self.currentNotes = Array(coreDataGroup.items.map({NoteModel(coreDataPrayerItem: $0)})).sorted(by: {$0.dateCreated > $1.dateCreated})
        }
        
        if !coreDataGroup.prayers.isEmpty {
            self.prayerIds = Array(coreDataGroup.prayers.map({$0.uuid}))
        }
    }
}
