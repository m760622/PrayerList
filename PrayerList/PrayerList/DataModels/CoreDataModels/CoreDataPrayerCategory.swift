//
//  CoreDataPrayerCategory.swift
//  PrayerList
//
//  Created by Devin  on 30/11/18.
//  Copyright © 2018 Devin Davies. All rights reserved.
//

import Foundation
import CoreData

class CoreDataPrayerCategory: NSManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreDataPrayerCategory> {
        return NSFetchRequest<CoreDataPrayerCategory>(entityName: "CoreDataPrayerCategory")
    }
    
    @NSManaged var name: String
    @NSManaged var uuid: String
    @NSManaged var order: Int64
    
    @NSManaged var groups: Set<CoreDataPrayerGroup>
    @NSManaged var prayers: Set<CoreDataPrayer>
    
    static let entityName: String = "CoreDataPrayerCategory"
    
    class func new(forGroup categoryModel: PrayerCategoryModel, in context: NSManagedObjectContext) -> CoreDataPrayerCategory {
        
        let category: CoreDataPrayerCategory
        if let existing = fetchCategory(withID: categoryModel.uuid, in: context) {
            category = existing
        } else {
            category = CoreDataPrayerCategory(entity: entity(), insertInto: context)
            category.uuid = categoryModel.uuid
        }
        
        category.name = categoryModel.name
        category.order = Int64(categoryModel.order)
        
        if !categoryModel.groups.isEmpty {
            category.groups = Set<CoreDataPrayerGroup>()
            for group in categoryModel.groups {
                let group = CoreDataPrayerGroup.new(forGroup: group, in: context)
                category.groups .insert(group)
            }
        }
        
        if !categoryModel.prayers.isEmpty {
            category.prayers = Set<CoreDataPrayer>()
            for prayerModel in categoryModel.prayers {
                let prayer = CoreDataPrayer.new(forPrayer: prayerModel, in: context)
                category.prayers .insert(prayer)
            }
        }
        
        return category
    }
    
    //MARK: - Retrieval
    class func fetchCategory(withID id: String, in context: NSManagedObjectContext) -> CoreDataPrayerCategory? {
        var categories = [CoreDataPrayerCategory]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreDataPrayerCategory")
        
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", id)
        
        do {
            let results = try context.fetch(fetchRequest)
            categories = results as! [CoreDataPrayerCategory]
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
        
        return categories.first
    }
    
    class func fetchAllCategories(inContext context: NSManagedObjectContext) -> [CoreDataPrayerCategory] {
        var categories = [CoreDataPrayerCategory]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreDataPrayerCategory")
        
        do {
            let results = try context.fetch(fetchRequest)
            categories = results as! [CoreDataPrayerCategory]
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
        
        return categories
    }
    
    func delete(inContext context: NSManagedObjectContext){
        context.delete(self)
    }
    
}
