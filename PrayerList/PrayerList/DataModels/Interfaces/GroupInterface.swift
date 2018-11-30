//
//  GroupInterface.swift
//  PrayerList
//
//  Created by Devin  on 30/11/18.
//  Copyright © 2018 Devin Davies. All rights reserved.
//

import Foundation
import CoreData

class GroupInterface {
    
    class func retrieveAllGroups(inContext context: NSManagedObjectContext) -> [PrayerGroupModel] {
        let coredataGroups = CoreDataPrayerGroup.fetchAllPrayers(inContext: context)
        return coredataGroups.map({PrayerGroupModel(coreDataGroup: $0)})
    }
    
    class func saveGroup(group: PrayerGroupModel, inContext context: NSManagedObjectContext) {
        _ = CoreDataPrayerGroup.new(forGroup: group, in: context)
        CoreDataManager.saveContext(context)
    }
    
    class func deleteGroup(group: PrayerGroupModel, inContext context: NSManagedObjectContext) {
        
        if let coreDataGroup = CoreDataPrayerGroup.fetchGroup(withID: group.uuid, in: context){
            coreDataGroup.delete(inContext: context)
        }
        CoreDataManager.saveContext(context)
    }
}
