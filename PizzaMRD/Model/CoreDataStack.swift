//
//  CoreDataStack.swift
//  PizzaMRD
//
//  Created by Venkata Mandala on 30/10/2016.
//  Copyright © 2016 Ramana Reddy. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack: NSObject {
    static let moduleName = "MRD"
    
    func saveMainContext() {
        guard managedObjectContext.hasChanges || saveManagedObjectContext.hasChanges else {
            return
        }
        
        managedObjectContext.performAndWait() {
            do {
                try self.managedObjectContext.save()
            } catch {
                fatalError("Error saving main managed object context! \(error)")
            }
        }
        
        saveManagedObjectContext.perform() {
            do {
                try self.saveManagedObjectContext.save()
            } catch {
                fatalError("Error saving private managed object context! \(error)")
            }
        }
        
    }
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: moduleName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var applicationDocumentsDirectory: URL = {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        let persistentStoreURL = self.applicationDocumentsDirectory.appendingPathComponent("\(moduleName).sqlite")
        
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                               configurationName: nil,
                                               at: persistentStoreURL,
                                               options: [NSMigratePersistentStoresAutomaticallyOption: true,
                                                         NSInferMappingModelAutomaticallyOption: false])
        } catch {
            fatalError("Persistent store error! \(error)")
        }
        
        return coordinator
    }()
    
    fileprivate lazy var saveManagedObjectContext: NSManagedObjectContext = {
        let moc = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        moc.persistentStoreCoordinator = self.persistentStoreCoordinator
        return moc
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.parent = self.saveManagedObjectContext
        return managedObjectContext
    }()
    
}
