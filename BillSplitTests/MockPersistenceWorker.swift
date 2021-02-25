//
//  MockPersistenceWorker.swift
//  BillSplitTests
//
//  Created by Matheus Oliveira Costa on 06/02/21.
//

import Foundation
import CoreData
@testable import BillSplit

class MockPersistenceGateway: PersistenceGateway {
    override init() {
        super.init()

        let storeDescription = NSPersistentStoreDescription()
        storeDescription.type = NSInMemoryStoreType

        let container = NSPersistentContainer(name: "BillSplit")
        container.persistentStoreDescriptions = [storeDescription]

        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
              fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }

        self.persistentContainer = container
    }
}
