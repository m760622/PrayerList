//
//  CoreDataPrayerItem.swift
//  PrayerList
//
//  Created by Devin  on 30/11/18.
//  Copyright © 2018 Devin Davies. All rights reserved.
//

import Foundation
import CoreData

class CoreDataNote: NSManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreDataNote> {
        return NSFetchRequest<CoreDataNote>(entityName: "CoreDataNote")
    }
    
    @NSManaged var name: String
    @NSManaged var uuid: String
    @NSManaged var dateCreated: NSDate
    
    static let entityName: String = "CoreDataNote"
    
    class func new(forItem itemModel: NoteModel, in context: NSManagedObjectContext) -> CoreDataNote {
        
        let item: CoreDataNote
        if let existing = fetchItem(withID: itemModel.uuid, in: context) {
            item = existing
        } else {
            item = CoreDataNote(entity: entity(), insertInto: context)
            item.uuid = itemModel.uuid
        }
        
        item.name = itemModel.name
        item.dateCreated = itemModel.dateCreated as NSDate
        
        return item
    }
    
    //MARK: - Retrieval
    class func fetchItem(withID id: String, in context: NSManagedObjectContext) -> CoreDataNote? {
        var items = [CoreDataNote]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreDataNote")
        
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", id)
        
        do {
            let results = try context.fetch(fetchRequest)
            items = results as! [CoreDataNote]
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
        
        return items.first
    }
    
    class func fetchAllPrayers(inContext context: NSManagedObjectContext) -> [CoreDataNote] {
        var items = [CoreDataNote]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreDataNote")
        
        do {
            let results = try context.fetch(fetchRequest)
            items = results as! [CoreDataNote]
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
        
        return items
    }
    
    func delete(inContext context: NSManagedObjectContext){
        context.delete(self)
    }
    
}
