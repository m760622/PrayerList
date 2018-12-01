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
    
    class func retrieveAllCategories(inContext context: NSManagedObjectContext) -> [PrayerCategoryModel] {
        let coredataCategories = CoreDataPrayerCategory.fetchAllCategories(inContext: context)
        return coredataCategories.map({PrayerCategoryModel(coreDataCategory: $0)}).sorted(by: {$0.order < $1.order})
    }
    
    class func retrieveCategory(forID ID: String, context: NSManagedObjectContext) -> PrayerCategoryModel? {
        if let category = CoreDataPrayerCategory.fetchCategory(withID: ID, in: context) {
            return PrayerCategoryModel(coreDataCategory: category)
        }
        
        return nil
    }
    
    class func saveCategory(category: PrayerCategoryModel, inContext context: NSManagedObjectContext) {
        _ = CoreDataPrayerCategory.new(forGroup: category, in: context)
        CoreDataManager.saveContext(context)
    }
    
    class func deleteCategory(category: PrayerCategoryModel, inContext context: NSManagedObjectContext) {
        
        if let coreDataCategory = CoreDataPrayerCategory.fetchCategory(withID: category.uuid, in: context){
            coreDataCategory.delete(inContext: context)
        }
        CoreDataManager.saveContext(context)
    }
}
