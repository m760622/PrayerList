//
//  CoreDataPrayerGroup.swift
//  PrayerList
//
//  Created by Devin  on 30/11/18.
//  Copyright © 2018 Devin Davies. All rights reserved.
//

import Foundation
import CoreData

class CoreDataPrayerGroup: NSManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreDataPrayerGroup> {
        return NSFetchRequest<CoreDataPrayerGroup>(entityName: "CoreDataPrayerGroup")
    }
    
    @NSManaged var name: String
    @NSManaged var uuid: String
    @NSManaged var order: Int64
    
    @NSManaged var items: Set<CoreDataPrayerItem>
    
    static let entityName: String = "CoreDataPrayerGroup"
    
    class func new(forGroup groupModel: PrayerGroupModel, in context: NSManagedObjectContext) -> CoreDataPrayerGroup {
        
        let group: CoreDataPrayerGroup
        if let existing = fetchGroup(withID: groupModel.uuid, in: context) {
            group = existing
        } else {
            group = CoreDataPrayerGroup(entity: entity(), insertInto: context)
            group.uuid = groupModel.uuid
        }
        
        group.name = groupModel.name
        group.order = Int64(groupModel.order)
        
        if !groupModel.currentItems.isEmpty {
            group.items = Set<CoreDataPrayerItem>()
            for item in groupModel.currentItems {
                let item = CoreDataPrayerItem.new(forItem: item, in: context)
                group.items.insert(item)
            }
        }
        
        return group
    }
    
    //MARK: - Retrieval
    class func fetchGroup(withID id: String, in context: NSManagedObjectContext) -> CoreDataPrayerGroup? {
        var groups = [CoreDataPrayerGroup]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreDataPrayerGroup")
        
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", id)
        
        do {
            let results = try context.fetch(fetchRequest)
            groups = results as! [CoreDataPrayerGroup]
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
        
        return groups.first
    }
    
    class func fetchAllPrayers(inContext context: NSManagedObjectContext) -> [CoreDataPrayerGroup] {
        var groups = [CoreDataPrayerGroup]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreDataPrayerGroup")
        
        do {
            let results = try context.fetch(fetchRequest)
            groups = results as! [CoreDataPrayerGroup]
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
        
        return groups
    }
    
    func delete(inContext context: NSManagedObjectContext){
        context.delete(self)
    }
    
}
