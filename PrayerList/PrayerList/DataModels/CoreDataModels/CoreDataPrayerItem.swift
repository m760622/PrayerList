//
//  CoreDataPrayerItem.swift
//  PrayerList
//
//  Created by Devin  on 30/11/18.
//  Copyright © 2018 Devin Davies. All rights reserved.
//

import Foundation
import CoreData

class CoreDataPrayerItem: NSManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreDataPrayerItem> {
        return NSFetchRequest<CoreDataPrayerItem>(entityName: "CoreDataPrayerItem")
    }
    
    @NSManaged var name: String
    @NSManaged var uuid: String
    @NSManaged var dateCreated: NSDate
    
    static let entityName: String = "CoreDataPrayerItem"
    
    class func new(forItem itemModel: PrayerItemModel, in context: NSManagedObjectContext) -> CoreDataPrayerItem {
        
        let item: CoreDataPrayerItem
        if let existing = fetchItem(withID: itemModel.uuid, in: context) {
            item = existing
        } else {
            item = CoreDataPrayerItem(entity: entity(), insertInto: context)
            item.uuid = itemModel.uuid
        }
        
        item.name = itemModel.name
        item.dateCreated = itemModel.dateCreated as NSDate
        
        return item
    }
    
    //MARK: - Retrieval
    class func fetchItem(withID id: String, in context: NSManagedObjectContext) -> CoreDataPrayerItem? {
        var items = [CoreDataPrayerItem]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreDataPrayerItem")
        
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", id)
        
        do {
            let results = try context.fetch(fetchRequest)
            items = results as! [CoreDataPrayerItem]
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
        
        return items.first
    }
    
    class func fetchAllPrayers(inContext context: NSManagedObjectContext) -> [CoreDataPrayerItem] {
        var items = [CoreDataPrayerItem]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreDataPrayerItem")
        
        do {
            let results = try context.fetch(fetchRequest)
            items = results as! [CoreDataPrayerItem]
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
        
        return items
    }
    
    func delete(inContext context: NSManagedObjectContext){
        context.delete(self)
    }
    
}
