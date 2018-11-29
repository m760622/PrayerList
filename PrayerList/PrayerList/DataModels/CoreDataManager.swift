//
//  CoreDataManager.swift
//  PrayerList
//
//  Created by Devin  on 29/11/18.
//  Copyright © 2018 Devin Davies. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    private var parentMainContext: NSManagedObjectContext!
    private var parentPrivateContext: NSManagedObjectContext!
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: "PrayerList", withExtension: "momd") else {
            fatalError("Unable to Find Data Model")
        }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to Load Data Model")
        }
        
        return managedObjectModel
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        let fileManager = FileManager.default
        let storeName = "PrayerList.sqlite"
        
        let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let persistentStoreURL = documentsDirectoryURL.appendingPathComponent(storeName)
        
        do {
            
            let options = [ NSInferMappingModelAutomaticallyOption : true,
                            NSMigratePersistentStoresAutomaticallyOption : true]
            
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                              configurationName: nil,
                                                              at: persistentStoreURL,
                                                              options: options)
        } catch {
            fatalError("Unable to Load Persistent Store")
        }
        
        return persistentStoreCoordinator
    }()
    
    static var mainContext: NSManagedObjectContext {
        return shared.getParentMainContext()
    }
    
    static func newPrivateBackgroundContext() -> NSManagedObjectContext {
        let context: NSManagedObjectContext = NSManagedObjectContext.init(concurrencyType: .privateQueueConcurrencyType)
        context.parent = shared.getParentPrivateContext()
        
        return context;
    }
    
    static func newPrivateMainContext() -> NSManagedObjectContext {
        
        let context: NSManagedObjectContext = NSManagedObjectContext.init(concurrencyType: .privateQueueConcurrencyType)
        context.parent = shared.getParentMainContext()
        
        return context;
    }
    
    static let shared = CoreDataManager()
    private init() {
        
    }
    
    static func mergeSavedChildrenIntoParentPrivateContext() {
        let context: NSManagedObjectContext = shared.parentPrivateContext
        context.performAndWait {
            saveContext(context)
        }
    }
    
    static func resetParentPrivateContext() {
        let context: NSManagedObjectContext = shared.parentPrivateContext
        
        context.performAndWait {
            context.reset()
        }
    }
    
    static func saveContext(_ context: NSManagedObjectContext, saveRetryCount: Int = 0){
        var  retryCount = saveRetryCount;
        
        let managedObjectContext: NSManagedObjectContext = context
        
        // Don't perform a save if there are no changes.
        if (!managedObjectContext.hasChanges) { return }
        
        managedObjectContext.performAndWait {
            do {
                try managedObjectContext.save()
                return
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                
                if let nsDetailedErrors = nserror.userInfo[NSDetailedErrorsKey] as? NSArray {
                    for detailedError in nsDetailedErrors {
                        let detailedError = detailedError as! NSError
                        print("%@", detailedError);
                        
                        let objectWithError: NSManagedObject = detailedError.userInfo[NSValidationObjectErrorKey] as! NSManagedObject;
                        
                        let objectWasInserted: Bool = managedObjectContext.insertedObjects.contains(objectWithError)
                        
                        if (objectWasInserted) {
                            //We only want to delete the object if the object was inserted.
                            managedObjectContext.delete(objectWithError)
                        } else {
                            //Reset the object.
                            managedObjectContext.refresh(objectWithError, mergeChanges: false)
                        }
                    }
                    
                    if (retryCount > 10) {
                        //TODO: NSException.raise(NSExceptionName(rawValue: "CoreData saving recursively"), format: "CoreData save attempted %i times, forcing crash", arguments: retryCount)
                    } else if (retryCount > 3) {
                        // If we cannot gracefully resolve the changes, we will attempt to roll-back the changes.
                        managedObjectContext.rollback()
                    }
                    
                    retryCount += 1;
                    
                    self.saveContext(context, saveRetryCount: retryCount)
                }
                
                
            }
            
        }
        
    }
    
    //Mark: - Getters
    
    @objc func mocDidSaveNotification(notification: NSNotification) {
        let savedContext: NSManagedObjectContext = notification.object as! NSManagedObjectContext
        
        if (savedContext == self.parentPrivateContext) {
            
            // Sync the privateContext changes into the mainContext
            DispatchQueue.main.async {
                let mainContext = self.getParentMainContext()
                mainContext.perform({
                    mainContext.mergeChanges(fromContextDidSave: notification as Notification)
                    CoreDataManager.saveContext(mainContext)
                })
            }
        } else if (savedContext == self.parentMainContext) {
            var set = Set<String>.init(minimumCapacity: 0)
            
            if let inserted = notification.userInfo?["inserted"] as? Set<NSManagedObject> {
                set = set.union(self.entityNamesForEntities(entities: inserted))
            }
            
            if let inserted = notification.userInfo?["updated"] as? Set<NSManagedObject> {
                set = set.union(self.entityNamesForEntities(entities: inserted))
            }
            
            if let inserted = notification.userInfo?["deleted"] as? Set<NSManagedObject> {
                set = set.union(self.entityNamesForEntities(entities: inserted))
            }
            
            let uniqueEntityNames = Array(set)
            
            let privateContext = self.getParentPrivateContext()
            privateContext.perform {
                privateContext.mergeChanges(fromContextDidSave: notification as Notification)
            }
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MAIN_QUEUE_CONTEXT_AFTER_UPDATE"), object: uniqueEntityNames)
        }
    }
    
    func entityNamesForEntities(entities: Set<NSManagedObject>) ->[String]{
        var entityNames = Set<String>.init(minimumCapacity: 0)
        for object in entities{
            if let name = object.entity.name {
                entityNames.insert(name)
            }
        }
        return Array(entityNames)
    }
    
    private func getParentMainContext() -> NSManagedObjectContext {
        if (parentMainContext == nil) {
            self.parentMainContext = NSManagedObjectContext.init(concurrencyType: .mainQueueConcurrencyType)
            self.parentMainContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
            
            // Reset observer
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector (self.mocDidSaveNotification), name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)
        }
        
        return parentMainContext;
        
    }
    
    private func getParentPrivateContext() -> NSManagedObjectContext {
        if (parentPrivateContext == nil) {
            parentPrivateContext = NSManagedObjectContext.init(concurrencyType: .privateQueueConcurrencyType)
            parentPrivateContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
        }
        
        return parentPrivateContext;
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)
    }
}
