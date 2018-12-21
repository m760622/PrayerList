//
//  CoreDataPrayer.swift
//  PrayerList
//
//  Created by Devin  on 29/11/18.
//  Copyright © 2018 Devin Davies. All rights reserved.
//

import Foundation
import CoreData

class CoreDataPrayer: NSManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreDataPrayer> {
        return NSFetchRequest<CoreDataPrayer>(entityName: "CoreDataPrayer")
    }
    
    @NSManaged var name: String
    @NSManaged var uuid: String
    @NSManaged var order: Int64
    
    @NSManaged var groups: Set<CoreDataItem>
    
    static let entityName: String = "CoreDataPrayer"
    
    class func new(forPrayer prayerModel: PrayerModel, in context: NSManagedObjectContext) -> CoreDataPrayer {
        
        let prayer: CoreDataPrayer
        if let existing = fetchPrayer(withID: prayerModel.uuid, in: context) {
            prayer = existing
        } else {
            prayer = CoreDataPrayer(entity: entity(), insertInto: context)
            prayer.uuid = prayerModel.uuid
        }
        
        
        prayer.name = prayerModel.name
        prayer.order = Int64(prayerModel.order)
        
        if !prayerModel.groupIDs.isEmpty {
            prayer.groups = Set<CoreDataItem>()
            for groupID in prayerModel.groupIDs {
                if let group = ItemInterface.retrieveGroup(withID: groupID, inContext: context){
                    let coreGroup = CoreDataItem.new(forGroup: group, in: context)
                    prayer.groups.insert(coreGroup)
                }
            }
        }
        
        return prayer
    }
    
    //MARK: - Retrieval
    
    class func fetchPrayer(withID id: String, in context: NSManagedObjectContext) -> CoreDataPrayer? {
        var prayers = [CoreDataPrayer]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreDataPrayer")
        
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", id)
        
        do {
            let results = try context.fetch(fetchRequest)
            prayers = results as! [CoreDataPrayer]
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
        
        return prayers.first
    }
    
    class func fetchPrayers(forGroup id: String, in context: NSManagedObjectContext) -> [CoreDataPrayer] {
        var prayers = [CoreDataPrayer]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreDataPrayer")
        
        fetchRequest.predicate = NSPredicate(format: "ANY groups.uuid = %@", id)
        
        do {
            let results = try context.fetch(fetchRequest)
            prayers = results as! [CoreDataPrayer]
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
        
        return prayers
    }
    
    class func fetchAllPrayers(inContext context: NSManagedObjectContext) -> [CoreDataPrayer] {
        var prayers = [CoreDataPrayer]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreDataPrayer")
        
        do {
            let results = try context.fetch(fetchRequest)
            prayers = results as! [CoreDataPrayer]
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
        
        return prayers
    }
    
    func delete(inContext context: NSManagedObjectContext){
        context.delete(self)
    }
    
}
