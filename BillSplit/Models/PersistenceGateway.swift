//
//  PersistenceGateway.swift
//  BillSplit
//
//  Created by Matheus Oliveira Costa on 21/12/20.
//

import Foundation
import CoreData

open class PersistenceGateway {
    static let sharedInstance = PersistenceGateway()

    lazy var persistentContainer: NSPersistentContainer = {
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
        context.perform {
            do {
                try context.save()
            } catch let error as NSError {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }

        if context != mainContext {
            saveContext(mainContext)
        }
    }

    func fetch<T>(_ request: NSFetchRequest<T>) -> [T] {
        do {
            let list = try mainContext.fetch(request)
            return list
        } catch {
            return []
        }
    }

    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        let derivedContext = persistentContainer.newBackgroundContext()
        derivedContext.perform {
            block(derivedContext)
            self.saveContext(derivedContext)
        }
    }
}
