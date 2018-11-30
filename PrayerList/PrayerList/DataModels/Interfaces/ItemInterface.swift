//
//  ItemInterface.swift
//  PrayerList
//
//  Created by Devin  on 30/11/18.
//  Copyright © 2018 Devin Davies. All rights reserved.
//

import Foundation
import CoreData

class ItemInterface {
    
    class func retrieveAllItems(inContext context: NSManagedObjectContext) -> [PrayerItemModel] {
        let coredataItems = CoreDataPrayerItem.fetchAllPrayers(inContext: context)
        return coredataItems.map({PrayerItemModel(coreDataPrayerItem: $0)})
    }
    
    class func saveItem(item: PrayerItemModel, inContext context: NSManagedObjectContext) {
        _ = CoreDataPrayerItem.new(forItem: item, in: context)
        CoreDataManager.saveContext(context)
    }
    
    class func deleteItem(item: PrayerItemModel, inContext context: NSManagedObjectContext) {
        
        if let coreDataItem = CoreDataPrayerItem.fetchItem(withID: item.uuid, in: context){
            coreDataItem.delete(inContext: context)
        }
        CoreDataManager.saveContext(context)
    }
}
