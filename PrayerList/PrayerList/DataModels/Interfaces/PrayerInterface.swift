//
//  PrayerInterface.swift
//  PrayerList
//
//  Created by Devin  on 29/11/18.
//  Copyright © 2018 Devin Davies. All rights reserved.
//

import Foundation
import CoreData

class PrayerInterface {
    
    class func retrieveAllPrayers(inContext context: NSManagedObjectContext) -> [PrayerModel] {
        let coreDataPrayers = CoreDataPrayer.fetchAllPrayers(inContext: context)
        return coreDataPrayers.map({PrayerModel(coreDataPrayer: $0)}).sorted(by: {$0.order < $1.order})
    }
    
    class func retrievePrayersForGroup(groupID: String, inContext context: NSManagedObjectContext) -> [PrayerModel] {
        let coreDataPrayers = CoreDataPrayer.fetchPrayers(forGroup: groupID, in: context)
        return coreDataPrayers.map({PrayerModel(coreDataPrayer: $0)}).sorted(by: {$0.order < $1.order})
    }
    
    class func retrievePrayer(withID ID: String, inContext context: NSManagedObjectContext) -> PrayerModel? {
        if let coreDataPrayer = CoreDataPrayer.fetchPrayer(withID: ID, in: context) {
            return PrayerModel(coreDataPrayer: coreDataPrayer)
        }
        return nil
    }
    
    class func savePrayer(prayer: PrayerModel, inContext context: NSManagedObjectContext) {
        _ = CoreDataPrayer.new(forPrayer: prayer, in: context)
        CoreDataManager.saveContext(context)
    }
    
    
    
    class func deletePrayer(prayerModel: PrayerModel, inContext context: NSManagedObjectContext) {
        
        if let coreDataPrayer = CoreDataPrayer.fetchPrayer(withID: prayerModel.uuid, in: context){
            coreDataPrayer.delete(inContext: context)
        }
        CoreDataManager.saveContext(context)
    }
}
