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

//MARK: Test stack could use an in-memory Core Data store or fileURLWithPath for testing, which is isolated from the actual production data.
final class TestCoreDataStack: BaseCoreDataStack {
    let description = NSPersistentStoreDescription()
    init(type: DescriptionType) {
        super.init(containerName: Constants.CBC)
        setupCustomDescription(type: type)
    }
    
    
    fileprivate func setupCustomDescription(type: DescriptionType) {
        switch type {
        case .inMemory:
            description.type = NSInMemoryStoreType
        case .fileURL:
            description.url = URL(fileURLWithPath: "/dev/null")
        }
        persistentContainer.persistentStoreDescriptions = [description]
    }
}

enum DescriptionType {
    case inMemory
    case fileURL
}
