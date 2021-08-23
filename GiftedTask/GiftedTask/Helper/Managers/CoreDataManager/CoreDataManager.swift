//
//  CoreDataManager.swift
//  GiftedTask
//
//  Created by zone on 8/16/21.
//

import CoreData
import UIKit

final class CoreDataManager {
    
    
    private static var CDMInstance: CoreDataManager?

    //Globally accessible, shared instance of the class.
    public static var shared: CoreDataManager {
        if CDMInstance == nil {
            CDMInstance = CoreDataManager()
        }

        return CDMInstance!
    }
    //Globally accessible, shared instance of the class.
    private init() {}
    
    //Class Properties
    private lazy var privateMOC: NSManagedObjectContext = {
        return CoreDataStack.shared.privateContext
    }()
    //Represent a single context for all the operations with lazy loading
    private lazy var managedObjectContext: NSManagedObjectContext = {

          return  CoreDataStack.shared.persistentContainer.viewContext
    }()
    
    /************** CRUD Operations **************************************/
    //Thread safe generic method

    func fetchData<T: NSFetchRequestResult>(entity: String, model: T.Type, _ custom_predicate: NSPredicate?=nil,completion:@escaping ([T])->Void) throws  {
        self.privateMOC.performAndWait {
            let request = NSFetchRequest<T>(entityName: entity)

             if custom_predicate != nil {
                request.predicate =   custom_predicate
             }

            request.returnsObjectsAsFaults = false
            let result = try? privateMOC.fetch(request)
            completion(result ?? [])
        }

   }
    
    fileprivate func synchronize(privateMOC: NSManagedObjectContext) {
        do {
            if privateMOC.hasChanges {
               /* We call save on the private context, which moves all of the changes into the main queue context without blocking the main queue.*/
               try privateMOC.save()
            }

            self.managedObjectContext.performAndWait {
                if self.managedObjectContext.hasChanges {
                    do {
                       // print(Thread.current.threadName)
                        try self.managedObjectContext.save()
                       // print("Saved to main context")
                    } catch {
                        print("Could not synchonize data. \(error), \(error.localizedDescription)")
                    }
                }
            }
        } catch {
            print("Could not save data. \(error), \(error.localizedDescription)")
        }
    }
}


extension CoreDataManager {
/************** CRUD Operations **************************************/
    
    func saveAndUpdateFilms(data:[APIData]) {
    
            self.privateMOC.performAndWait {
               for result in data {
                   if let film = result.film {
                    let film_entity = Film(context: self.privateMOC)
                       film_entity.title = film.title
                       film_entity.opening_crawl = film.opening_crawl
                       film_entity.director = film.director
                       film_entity.producer = film.producer
                       film_entity.release_date = film.release_date
                       film_entity.episode_id = Double(film.episode_id ?? 0)
                       film_entity.image_data = result.network_image
                    
                       if let characterList = result.characters {
                           var characters = [Character]()
                           for character in characterList {
                            let character_entity = Character(context: self.privateMOC)
                               character_entity.name = character.name
                               character_entity.birth_year = character.birth_year
                               character_entity.gender = character.gender
                               characters.append(character_entity)
                           }
                         
                           let all_characters = NSSet(array: characters)
                           film_entity.characters = all_characters
                       }
                       
                    self.privateMOC.insert(film_entity)
                    self.synchronize(privateMOC: self.privateMOC)
                   }
               }
            }
    }
    
     func dropTables() {
        
           let entityNames = CoreDataStack.shared.persistentContainer.managedObjectModel.entities.map({ $0.name!}).sorted()
           for (entityName) in entityNames{
                let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

                do {
                    try self.managedObjectContext.executeAndMergeChanges(using: deleteRequest)
                    
                } catch {
                    print("Data could not delete")
                }
            }
    }
}
