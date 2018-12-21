//
//  CoreDataPrayerItem.swift
//  PrayerList
//
//  Created by Devin  on 30/11/18.
//  Copyright © 2018 Devin Davies. All rights reserved.
//

import Foundation
import CoreData

class CoreDataPrayerNote: NSManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreDataPrayerNote> {
        return NSFetchRequest<CoreDataPrayerNote>(entityName: "CoreDataPrayerNote")
    }
    
    @NSManaged var name: String
    @NSManaged var uuid: String
    @NSManaged var dateCreated: NSDate
    
    static let entityName: String = "CoreDataPrayerNote"
    
    class func new(forItem itemModel: NoteModel, in context: NSManagedObjectContext) -> CoreDataPrayerNote {
        
        let item: CoreDataPrayerNote
        if let existing = fetchItem(withID: itemModel.uuid, in: context) {
            item = existing
        } else {
            item = CoreDataPrayerNote(entity: entity(), insertInto: context)
            item.uuid = itemModel.uuid
        }
        
        item.name = itemModel.name
        item.dateCreated = itemModel.dateCreated as NSDate
        
        return item
    }
    
    //MARK: - Retrieval
    class func fetchItem(withID id: String, in context: NSManagedObjectContext) -> CoreDataPrayerNote? {
        var items = [CoreDataPrayerNote]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreDataPrayerNote")
        
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", id)
        
        do {
            let results = try context.fetch(fetchRequest)
            items = results as! [CoreDataPrayerNote]
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
        
        return items.first
    }
    
    class func fetchAllPrayers(inContext context: NSManagedObjectContext) -> [CoreDataPrayerNote] {
        var items = [CoreDataPrayerNote]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreDataPrayerNote")
        
        do {
            let results = try context.fetch(fetchRequest)
            items = results as! [CoreDataPrayerNote]
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
        
        return items
    }
    
    func delete(inContext context: NSManagedObjectContext){
        context.delete(self)
    }
    
}
