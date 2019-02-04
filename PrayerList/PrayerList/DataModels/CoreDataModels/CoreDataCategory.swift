//
//  CoreDataPrayerCategory.swift
//  PrayerList
//
//  Created by Devin  on 30/11/18.
//  Copyright © 2018 Devin Davies. All rights reserved.
//

import Foundation
import CoreData

class CoreDataCategory: NSManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreDataCategory> {
        return NSFetchRequest<CoreDataCategory>(entityName: "CoreDataCategory")
    }
    
    @NSManaged var name: String
    @NSManaged var uuid: String
    @NSManaged var order: Int64
    
    @NSManaged var setType: String
    @NSManaged var totalPerSet: Int
    @NSManaged var showEmptyItems: Bool
    
    @NSManaged var groups: Set<CoreDataItem>
    @NSManaged var prayers: Set<CoreDataPrayer>
    
    static let entityName: String = "CoreDataCategory"
    
    class func new(forGroup categoryModel: CategoryModel, in context: NSManagedObjectContext) -> CoreDataCategory {
        
        let category: CoreDataCategory
        if let existing = fetchCategory(withID: categoryModel.uuid, in: context) {
            category = existing
        } else {
            category = CoreDataCategory(entity: entity(), insertInto: context)
            category.uuid = categoryModel.uuid
        }
        
        category.name = categoryModel.name
        category.order = Int64(categoryModel.order)
        category.totalPerSet = categoryModel.totalPerSet
        category.setType = categoryModel.setType.rawValue
        category.showEmptyItems = categoryModel.showEmptyItems
        
        if !categoryModel.items.isEmpty {
            category.groups = Set<CoreDataItem>()
            for group in categoryModel.items {
                let group = CoreDataItem.new(forItem: group, in: context)
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
    class func fetchCategory(withID id: String, in context: NSManagedObjectContext) -> CoreDataCategory? {
        var categories = [CoreDataCategory]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreDataCategory")
        
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", id)
        
        do {
            let results = try context.fetch(fetchRequest)
            categories = results as! [CoreDataCategory]
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
        
        return categories.first
    }
    
    class func fetchAllCategories(inContext context: NSManagedObjectContext) -> [CoreDataCategory] {
        var categories = [CoreDataCategory]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreDataCategory")
        
        do {
            let results = try context.fetch(fetchRequest)
            categories = results as! [CoreDataCategory]
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
        
        return categories
    }
    
    func delete(inContext context: NSManagedObjectContext){
        context.delete(self)
    }
    
}
