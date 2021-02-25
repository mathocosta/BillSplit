//
//  CheckoutWorker.swift
//  BillSplit
//
//  Created by Matheus Oliveira Costa on 22/01/21.
//

import Foundation
import CoreData

class CheckoutWorker {
    let persistenceWorker: PersistenceGateway

    init(persistenceWorker: PersistenceGateway) {
        self.persistenceWorker = persistenceWorker
    }

    func performPaymentOfExpenses(
        withIds ids: [UUID],
        completionHandler: @escaping (Error?) -> Void
    ) {
        let request = NSBatchUpdateRequest(entity: Expense.entity())
        request.predicate = NSPredicate(format: "id IN %@", ids)
        request.resultType = .updatedObjectIDsResultType
        request.propertiesToUpdate = ["isPaid": true]

        let context = persistenceWorker.mainContext

        context.perform {
            do {
                let result = try context.execute(request) as? NSBatchUpdateResult
                let objectIDArray = result?.result as? [NSManagedObjectID]
                let changes = [NSUpdatedObjectsKey: objectIDArray]

                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [context])

                completionHandler(nil)
            } catch {
                debugPrint(error)

                completionHandler(error)
            }
        }
    }
}
