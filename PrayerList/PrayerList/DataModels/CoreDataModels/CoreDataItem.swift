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
    @NSManaged var completedForSet: Bool
    
    @NSManaged var notes: Set<CoreDataNote>
    
    static let entityName: String = "CoreDataItem"
    
    class func new(forItem itemModel: ItemModel, in context: NSManagedObjectContext) -> CoreDataItem {
        
        let item: CoreDataItem
        if let existing = fetchItem(withID: itemModel.uuid, in: context) {
            item = existing
        } else {
            item = CoreDataItem(entity: entity(), insertInto: context)
            item.uuid = itemModel.uuid
        }
        
        item.name = itemModel.name
        item.order = Int64(itemModel.order)
        item.completedForSet = itemModel.completedForSet
        
        if !itemModel.currentNotes.isEmpty {
            item.notes = Set<CoreDataNote>()
            for note in itemModel.currentNotes {
                let coreDataNote = CoreDataNote.new(forItem: note, in: context)
                item.notes.insert(coreDataNote)
            }
        }
        
        return item
    }
    
    //MARK: - Retrieval
    class func fetchItem(withID id: String, in context: NSManagedObjectContext) -> CoreDataItem? {
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
