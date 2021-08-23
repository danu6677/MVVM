//
//  CoreDataStack.swift
//  GiftedTask
//
//  Created by zone on 8/16/21.
//

import CoreData


final class CoreDataStack {
    //Singleton
    private static var coreDataStackInstanse : CoreDataStack?
    
    public static var shared: CoreDataStack {
        
        if coreDataStackInstanse == nil {
            coreDataStackInstanse = CoreDataStack()
        }
        return coreDataStackInstanse!
    }
    
    
    private init() {
        let container: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "GiftedTask")

          container.loadPersistentStores(completionHandler: { (_, error) in

            if let error = error as NSError? {
              fatalError("Unresolved error \(error), \(error.userInfo)")
            }
          })
            return container
            
        }()
        persistentContainer =  container
        //Allow CoreData Concurrency
        let _privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        _privateContext.parent = persistentContainer.viewContext
        self.privateContext = _privateContext
    }
    
  //Class Properties
    let persistentContainer: NSPersistentContainer!
    let privateContext: NSManagedObjectContext!
    lazy var cacheContext: NSManagedObjectContext = {
        return self.persistentContainer.newBackgroundContext()
    }()
}



extension NSManagedObjectContext {
    
    func syncToPrivateMOC(entity:NSManagedObject,moc:NSManagedObjectContext) {
        do {
            moc.insert(entity)
            if moc.hasChanges {
               /* We call save on the private context, which moves all of the changes into the main queue context without blocking the main queue.*/
               try moc.save()
            }
        }catch{
            
        }
        
    }
}
