//
//  CoreDataPrayerGroup.swift
//  PrayerList
//
//  Created by Devin  on 30/11/18.
//  Copyright © 2018 Devin Davies. All rights reserved.
//

import Foundation
import CoreData

class CoreDataItem: NSManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreDataItem> {
        return NSFetchRequest<CoreDataItem>(entityName: "CoreDataItem")
    }
    
    @NSManaged var name: String
    @NSManaged var uuid: String
    @NSManaged var categoryID: String
    @NSManaged var order: Int64
    
    @NSManaged var items: Set<CoreDataPrayerNote>
    
    @NSManaged var prayers: Set<CoreDataPrayer>
    
    static let entityName: String = "CoreDataItem"
    
    class func new(forGroup groupModel: ItemModel, in context: NSManagedObjectContext) -> CoreDataItem {
        
        let group: CoreDataItem
        if let existing = fetchGroup(withID: groupModel.uuid, in: context) {
            group = existing
        } else {
            group = CoreDataItem(entity: entity(), insertInto: context)
            group.uuid = groupModel.uuid
        }
        
        group.name = groupModel.name
        group.order = Int64(groupModel.order)
        
        if !groupModel.currentNotes.isEmpty {
            group.items = Set<CoreDataPrayerNote>()
            for item in groupModel.currentNotes {
                let item = CoreDataPrayerNote.new(forItem: item, in: context)
                group.items.insert(item)
            }
        }
        
        return group
    }
    
    //MARK: - Retrieval
    class func fetchGroup(withID id: String, in context: NSManagedObjectContext) -> CoreDataItem? {
        var groups = [CoreDataItem]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreDataItem")
        
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", id)
        
        do {
            let results = try context.fetch(fetchRequest)
            groups = results as! [CoreDataItem]
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
        
        return groups.first
    }
    
    class func fetchAllPrayers(inContext context: NSManagedObjectContext) -> [CoreDataItem] {
        var groups = [CoreDataItem]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreDataItem")
        
        do {
            let results = try context.fetch(fetchRequest)
            groups = results as! [CoreDataItem]
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
        
        return groups
    }
    
    func delete(inContext context: NSManagedObjectContext){
        context.delete(self)
    }
    
}
