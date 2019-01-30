//
//  CategoryInterface.swift
//  PrayerList
//
//  Created by Devin  on 30/11/18.
//  Copyright © 2018 Devin Davies. All rights reserved.
//

import Foundation
import CoreData

class CategoryInterface {
    
    class func retrieveAllCategories(inContext context: NSManagedObjectContext) -> [CategoryModel] {
        let coredataCategories = CoreDataPrayerCategory.fetchAllCategories(inContext: context)
        return coredataCategories.map({CategoryModel(coreDataCategory: $0)}).sorted(by: {$0.order < $1.order})
    }
    
    class func retrieveCategory(forID ID: String, context: NSManagedObjectContext) -> CategoryModel? {
        if let category = CoreDataPrayerCategory.fetchCategory(withID: ID, in: context) {
            return CategoryModel(coreDataCategory: category)
        }
        
        return nil
    }
    
    class func retrieveCategories(forIDs IDs: [String], context: NSManagedObjectContext) -> [CategoryModel] {
        var categories = [CategoryModel]()
        for id in IDs {
            if let category = retrieveCategory(forID: id, context: context) {
                categories.append(category)
            }
        }
        return categories
    }
    
    class func saveCategory(category: CategoryModel, inContext context: NSManagedObjectContext) {
        _ = CoreDataPrayerCategory.new(forGroup: category, in: context)
        CoreDataManager.saveContext(context)
    }
    
    class func deleteCategory(category: CategoryModel, inContext context: NSManagedObjectContext) {
        
        if let coreDataCategory = CoreDataPrayerCategory.fetchCategory(withID: category.uuid, in: context){
            coreDataCategory.delete(inContext: context)
        }
        CoreDataManager.saveContext(context)
    }
}
