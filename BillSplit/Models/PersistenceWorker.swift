//
//  PersistenceWorker.swift
//  BillSplit
//
//  Created by Matheus Oliveira Costa on 21/12/20.
//

import Foundation
import CoreData

class PersistenceWorker {
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "BillSplit")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    var managedObjectContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()

            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func fetch<T>(_ request: NSFetchRequest<T>) -> [T] {
        do {
            let list = try persistentContainer.viewContext.fetch(request)
            return list
        } catch {
            return []
        }
    }
}
