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
    
    var sections: Int {
        return prayer.categoryIds.count
    }
    
    init(prayer: PrayerModel){
        self.prayer = prayer
    }
    
    func markPrayerAsComplete(){
        let context = CoreDataManager.mainContext
        for (_, prayerItems) in items {
            for item in prayerItems {
                item.completedForSet = true
                ItemInterface.saveGroup(group: item, inContext: context)
            }
        }
        CoreDataManager.saveContext(context)
    }
    
    func getItemsForCategory(category: CategoryModel) -> [ItemModel] {
        var availableItems = category.items.filter({!$0.completedForSet})
        
        var subsetForPrayer = [ItemModel]()
        switch category.setType {
        case .consecutive:
            
            subsetForPrayer = Array(availableItems.prefix(category.totalPerSet))
            
            if subsetForPrayer.count < category.totalPerSet {
                let refreshedItems = resetCategory(category: category)
                subsetForPrayer.append(contentsOf: Array(refreshedItems.prefix(category.totalPerSet - subsetForPrayer.count)))
            }
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
