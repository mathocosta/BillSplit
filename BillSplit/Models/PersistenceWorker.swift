//
//  PersistenceWorker.swift
//  BillSplit
//
//  Created by Matheus Oliveira Costa on 21/12/20.
//

import Foundation
import CoreData

class PersistenceWorker {
    static let sharedInstance = PersistenceWorker()

    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "BillSplit")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    lazy var mainContext: NSManagedObjectContext = {
        let context = persistentContainer.viewContext
        context.automaticallyMergesChangesFromParent = true

        return context
    }()

    func saveContext() {
        saveContext(mainContext)
    }

    func saveContext(_ context: NSManagedObjectContext) {
        if context.hasChanges {
            context.perform {
                do {
                    try context.save()
                } catch let error as NSError {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
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

    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        persistentContainer.performBackgroundTask { (backgroundContext) in
            block(backgroundContext)
            self.saveContext(backgroundContext)
        }
    }
}
