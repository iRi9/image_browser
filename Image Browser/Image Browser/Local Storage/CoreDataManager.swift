//
//  CoreDataManager.swift
//  Image Browser
//
//  Created by Giri Bahari on 05/02/23.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()

    let container: NSPersistentContainer
    let backgroundContext: NSManagedObjectContext

    init(_ storageType: StorageType = .persistent) {
        container = NSPersistentContainer(name: "ImageBrowser")
        if storageType == .inMemory {
            let description = NSPersistentStoreDescription()
            description.url = URL(fileURLWithPath: "/dev/null")
            container.persistentStoreDescriptions = [description]
        }

        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })

        backgroundContext = container.newBackgroundContext()
        backgroundContext.undoManager = nil
        backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
}

enum StorageType {
    case persistent, inMemory
}
