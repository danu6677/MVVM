//
//  CoreDataManager.swift
//  CBC
//
//  Created by Danutha Fernando on 2023-10-01.
//

import CoreData

final class CoreDataManager {
    
    init(coreDataStack:CoreDataStackProtocol) {
        _coreDataStack = coreDataStack
    }
    
    //Class Properties
    private let _coreDataStack:CoreDataStackProtocol
    private lazy var privateMOC: NSManagedObjectContext = {
        return _coreDataStack.privateContext
    }()
    //Represent a single context for all the operations with lazy loading
    private lazy var managedObjectContext: NSManagedObjectContext = {
        
        return _coreDataStack.persistentContainer.viewContext
    }()
    
    
    //MARK: Generic function to fetch data
    func fetchData<T: NSFetchRequestResult>(entity: String, model: T.Type, _ custom_predicate: NSPredicate?=nil,completion:@escaping ([NSManagedObject]?)->Void) throws  {
        self.privateMOC.performAndWait {
            let request = NSFetchRequest<T>(entityName: entity)
            
            if custom_predicate != nil {
                request.predicate =   custom_predicate
            }
            
            request.returnsObjectsAsFaults = false
            let result = try? (privateMOC.fetch(request) as! [NSManagedObject])
            completion(result ?? [])
        }
        
    }
    //synchronize data from all the child managed objects
    fileprivate func synchronize(privateMOC: NSManagedObjectContext) {
        do {
            if privateMOC.hasChanges {
                /* We call save on the private context, which moves all of the changes into the main queue context without blocking the main queue.*/
                try privateMOC.save()
            }
            
            self.managedObjectContext.performAndWait {
                if self.managedObjectContext.hasChanges {
                    do {
                        try self.managedObjectContext.save()
                        // print("Saved to main context")
                    } catch {
                        print("\(AlertMerssage.CORE_DATA_ERROR): \(error), \(error.localizedDescription)")
                    }
                }
            }
        } catch {
            print("\(AlertMerssage.CORE_DATA_ERROR): \(error), \(error.localizedDescription)")
        }
    }
    
}
//MARK: Operations
extension CoreDataManager {
    func dropTables() {
        
        let entityNames = _coreDataStack.persistentContainer.managedObjectModel.entities.map({ $0.name!}).sorted()
        for (entityName) in entityNames{
            let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
            
            do {
                try self.managedObjectContext.executeAndMergeChanges(using: deleteRequest)
                
            } catch {
                print(AlertMerssage.CORE_DATA_ERROR)
            }
        }
    }
    
    func saveAndUpdateNews(data:[NewsModel]) {
        self.privateMOC.performAndWait {
            for news in data {
                let news_entity = News(context: self.privateMOC)
                news_entity.news_id = Int32(news.id!)
                news_entity.title = news.title
                news_entity.news_type = news.type
                news_entity.news_description = news.description
                news_entity.publishedAt = Int64(news.publishedAt ?? 0)
                
                //Shortcut to download the image in a synchronous manner
                if let imageURL = URL(string: news.images?.square_140 ?? ""),
                   let imageData = try? Data(contentsOf: imageURL) {
                    news_entity.image_data = imageData
                }
                self.privateMOC.insert(news_entity)
                
            }
            self.synchronize(privateMOC: self.privateMOC)
        }
    }
}
