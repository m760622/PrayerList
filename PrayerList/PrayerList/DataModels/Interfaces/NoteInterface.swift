//
//  ItemInterface.swift
//  PrayerList
//
//  Created by Devin  on 30/11/18.
//  Copyright © 2018 Devin Davies. All rights reserved.
//

import Foundation
import CoreData

class NoteInterface {
    
    class func retrieveAllItems(inContext context: NSManagedObjectContext) -> [NoteModel] {
        let coredataItems = CoreDataNote.fetchAllPrayers(inContext: context)
        return coredataItems.map({NoteModel(coreDataPrayerItem: $0)})
    }
    
    class func saveItem(item: NoteModel, inContext context: NSManagedObjectContext) {
        _ = CoreDataNote.new(forItem: item, in: context)
        CoreDataManager.saveContext(context)
    }
    
    class func deleteItem(item: NoteModel, inContext context: NSManagedObjectContext) {
        
        if let coreDataItem = CoreDataNote.fetchItem(withID: item.uuid, in: context){
            coreDataItem.delete(inContext: context)
        }
        
        CoreDataManager.saveContext(context)
    }
}
