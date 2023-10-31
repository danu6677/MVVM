//
//  CoreDataStack.swift
//  CBC
//
//  Created by Danutha Fernando on 2023-10-01.
//

import CoreData

class BaseCoreDataStack: CoreDataStackProtocol {
    var privateContext: NSManagedObjectContext
    var persistentContainer: NSPersistentContainer

    init(containerName: String) {
        persistentContainer = NSPersistentContainer(name: containerName)
        persistentContainer.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("\(AlertMerssage.CORE_DATA_ERROR): \(error), \(error.userInfo)")
            }
        }

        let _privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        _privateContext.parent = persistentContainer.viewContext
        privateContext = _privateContext
    }
}

final class CoreDataStack: BaseCoreDataStack {
    init() {
        super.init(containerName: Constants.CBC)
    }
}

//MARK: Test stack uses an in-memory Core Data store for testing, which is isolated from the actual production data.
final class TestCoreDataStack: BaseCoreDataStack {
    init() {
        super.init(containerName: Constants.CBC)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        persistentContainer.persistentStoreDescriptions = [description]
    }
}
