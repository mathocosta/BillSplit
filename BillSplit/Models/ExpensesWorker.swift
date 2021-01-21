//  
//  ExpensesWorker.swift
//  BillSplit
//
//  Created by Matheus Oliveira Costa on 20/01/21.
//

import Foundation
import CoreData

class ExpensesWorker {
    let persistenceWorker: PersistenceWorker

    init(persistenceWorker: PersistenceWorker) {
        self.persistenceWorker = persistenceWorker
    }

    func createExpense(name: String, price: Float, assigne: String?, quantity: Int) {
        persistenceWorker.performBackgroundTask { (context) in
            let newExpense = Expense(context: context)

            newExpense.id = UUID()
            newExpense.name = name
            newExpense.price = price
            newExpense.assignee = assigne
            newExpense.quantity = Int32(quantity)
        }
    }

    func updateExpense(id: UUID, name: String, price: Float, assigne: String?, quantity: Int) {
        let request: NSFetchRequest<Expense> = Expense.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1

        guard let expenseToUpdate = persistenceWorker.fetch(request).first else { return }

        persistenceWorker.performBackgroundTask { (context) in
            expenseToUpdate.name = name
            expenseToUpdate.price = price
            expenseToUpdate.assignee = assigne
            expenseToUpdate.quantity = Int32(quantity)
        }
    }

    func makeFetchResultsController() -> NSFetchedResultsController<Expense> {
        let fetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]

        return NSFetchedResultsController<Expense>(
            fetchRequest: fetchRequest,
            managedObjectContext: persistenceWorker.managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
    }
}
