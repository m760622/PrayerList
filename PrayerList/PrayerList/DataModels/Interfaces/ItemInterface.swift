//
//  GroupInterface.swift
//  PrayerList
//
//  Created by Devin  on 30/11/18.
//  Copyright © 2018 Devin Davies. All rights reserved.
//

import Foundation
import CoreData

class ItemInterface {
    
    class func retrieveGroup(withID ID: String, inContext context: NSManagedObjectContext) -> ItemModel? {
        if let coreGroup = CoreDataItem.fetchGroup(withID: ID, in: context) {
            return ItemModel(coreDataGroup: coreGroup)
        }
        return nil
    }
    
    class func retrieveAllGroups(inContext context: NSManagedObjectContext) -> [ItemModel] {
        let coredataGroups = CoreDataItem.fetchAllPrayers(inContext: context)
        return coredataGroups.map({ItemModel(coreDataGroup: $0)})
    }
    
    class func saveGroup(group: ItemModel, inContext context: NSManagedObjectContext) {
        _ = CoreDataItem.new(forGroup: group, in: context)
        CoreDataManager.saveContext(context)
    }
    
    class func deleteGroup(group: ItemModel, inContext context: NSManagedObjectContext) {
        
        if let coreDataGroup = CoreDataItem.fetchGroup(withID: group.uuid, in: context){
            coreDataGroup.delete(inContext: context)
        }
        CoreDataManager.saveContext(context)
    }
}
