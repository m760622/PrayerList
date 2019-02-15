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
        if let coreGroup = CoreDataItem.fetchItem(withID: ID, in: context) {
            return ItemModel(coreDataItem: coreGroup)
        }
        return nil
    }
    
    class func retrieveAllGroups(inContext context: NSManagedObjectContext) -> [ItemModel] {
        let coredataGroups = CoreDataItem.fetchAllPrayers(inContext: context)
        return coredataGroups.map({ItemModel(coreDataItem: $0)})
    }
    
    class func saveGroup(group: ItemModel, inContext context: NSManagedObjectContext) {
        _ = CoreDataItem.new(forItem: group, in: context)
        CoreDataManager.saveContext(context)
    }
    
    class func retrieveGroups(fromIds ids: [String], inContext context: NSManagedObjectContext) -> [ItemModel] {
        var itemModels = [ItemModel]()
        
        for id in ids {
            if let coreDataItem = CoreDataItem.fetchItem(withID: id, in: context) {
                itemModels.append(ItemModel(coreDataItem: coreDataItem))
            }
        }
        
        return itemModels
    }
    
    class func deleteGroup(group: ItemModel, inContext context: NSManagedObjectContext) {
        context.perform {
            if let coreDataGroup = CoreDataItem.fetchItem(withID: group.uuid, in: context){
                coreDataGroup.delete(inContext: context)
            }
            CoreDataManager.saveContext(context)
        }
        try? context.save()
    }
}
