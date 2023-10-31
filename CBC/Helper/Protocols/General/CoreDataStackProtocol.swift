//
//  CoreDataStackProtocol.swift
//  CBC
//
//  Created by Danutha Fernando on 2023-10-14.
//


import CoreData
protocol CoreDataStackProtocol {
    //MARK: There are the main methods to execute from the manager class
    var persistentContainer: NSPersistentContainer { get set }
    var privateContext: NSManagedObjectContext { get set }
    
}
