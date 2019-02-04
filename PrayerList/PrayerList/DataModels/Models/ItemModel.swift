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

    var completedForSet: Bool = false
    
    init(name: String, order: Int){
        self.name = name
        self.uuid = UUID().uuidString
        self.order = order
    }
    
    init(coreDataItem: CoreDataItem){
        self.name = coreDataItem.name
        self.uuid = coreDataItem.uuid
        self.order = Int(coreDataItem.order)
        self.completedForSet = coreDataItem.completedForSet
        
        if !coreDataItem.notes.isEmpty {
            self.currentNotes = Array(coreDataItem.notes.map({NoteModel(coreDataPrayerItem: $0)})).sorted(by: {$0.dateCreated > $1.dateCreated})
        }
    }
}
