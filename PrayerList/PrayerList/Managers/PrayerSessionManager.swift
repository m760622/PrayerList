//
//  PrayerSessionManager.swift
//  PrayerList
//
//  Created by Devin  on 4/02/19.
//  Copyright © 2019 Devin Davies. All rights reserved.
//

import Foundation

class PrayerSessionManager {
    
    var prayer: PrayerModel!
        
    var items = [CategoryModel: [ItemModel]]()
    var categories = [CategoryModel]()
    
    var sections: Int {
        return categories.filter({!$0.items.filter({!$0.currentNotes.isEmpty}).isEmpty}).count
    }
    
    init(prayer: PrayerModel){
        self.prayer = prayer
        categories = CategoryInterface.retrieveCategories(forIDs: prayer.categoryIds, context: CoreDataManager.mainContext)
    }
    
    func markPrayerAsComplete(){
        let context = CoreDataManager.mainContext
        
        for (_, prayerItems) in items {
            for item in prayerItems {
                item.completedForSet = true
                ItemInterface.saveGroup(group: item, inContext: context)
            }
        }
        
        prayer.lastCompleted = Date()
        PrayerInterface.savePrayer(prayer: prayer, inContext: context)
    }
    
    func getItemsForCategory(category: CategoryModel) -> [ItemModel] {
        var availableItems = category.items.filter({!$0.completedForSet})
        
        if availableItems.isEmpty && !category.items.isEmpty {
            availableItems = resetCategory(category: category)
        }
        
        if !category.showEmptyItems {
            availableItems = availableItems.filter({!$0.currentNotes.isEmpty})
        }
        
        var subsetForPrayer = [ItemModel]()
        switch category.setType {
        case .consecutive:
            
            subsetForPrayer = Array(availableItems.prefix(category.totalPerSet))
            
//            if subsetForPrayer.count < category.totalPerSet {
//                let refreshedItems = resetCategory(category: category)
//                subsetForPrayer.append(contentsOf: Array(refreshedItems.prefix(category.totalPerSet - subsetForPrayer.count)))
//            }
        case .random:
            for _ in 0...min(category.totalPerSet, availableItems.count) {
                if let randomElement = availableItems.randomElement() , let index = availableItems.firstIndex(where: {$0.uuid == randomElement.uuid}){
                    availableItems.remove(at: index)
                    subsetForPrayer.append(randomElement)
                }
            }
            
            if subsetForPrayer.count < category.totalPerSet {
                let refreshedItems = resetCategory(category: category)
                
                for _ in 0...min(category.totalPerSet - subsetForPrayer.count, refreshedItems.count) {
                    if let randomElement = availableItems.randomElement() , let index = availableItems.firstIndex(where: {$0.uuid == randomElement.uuid}){
                        availableItems.remove(at: index)
                        subsetForPrayer.append(randomElement)
                    }
                }
                subsetForPrayer.append(contentsOf: Array(refreshedItems.prefix(category.totalPerSet - subsetForPrayer.count)))
            }
        }
        
        items[category] = subsetForPrayer
        return subsetForPrayer
    }
    
    func resetCategory(category: CategoryModel) -> [ItemModel] {
        let itemsForReset = category.items.filter({$0.completedForSet})
        
        for item in itemsForReset {
            item.completedForSet = false
            ItemInterface.saveGroup(group: item, inContext: CoreDataManager.mainContext)
        }
        
        return itemsForReset
    }
    
}
